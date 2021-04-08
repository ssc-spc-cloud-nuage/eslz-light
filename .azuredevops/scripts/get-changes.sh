#!/bin/bash
set -euo pipefail

# PURPOSE: 
# Compare the current git branch changes against main branch.  The goal
# is to get a list of all the L{N} folders and .envvars files with
# changes.  These will be used to control which folders we run
# Terraform plan/apply on later in the pipeline.
#
# USE:
# get-changes.sh TARGET_BRANCH [PROJECT_DIR] # defaults to /tf/caf
# get_changes.sh feature-branch-name /tf/caf

MAIN_BRANCH="main"
TARGET_BRANCH="${1}"
PROJECT_DIR="${2:-/tf/caf}"

# Check if we're working with the main branch.  If yes, we want to compare our changes
# to the last operation against main.  Otherwise, we can just compare to the current
# state of main.
if [[ "${TARGET_BRANCH}" == "${MAIN_BRANCH}" ]]; then  
  echo "Comparing ${MAIN_BRANCH} to previous state of ${MAIN_BRANCH}"
  COMMIT_REF="$(git merge-base HEAD HEAD~1)"  
else
  echo "Comparing ${TARGET_BRANCH} to current state of ${MAIN_BRANCH}"
  git fetch --no-tags --prune --depth=100 origin "${MAIN_BRANCH}"
  COMMIT_REF="origin/${MAIN_BRANCH}"
fi

# Get the list of changed files
echo "Getting diffs with ${COMMIT_REF}"
CHANGED_FILES="$(git diff HEAD ${COMMIT_REF} --name-only)"
CHANGES_LN=""

# Get all L{N} folders
ALL_LN_FOLDERS="$(ls ${PROJECT_DIR} | egrep '^L[0-9]+_.*$' | tr '\n' ';')"
echo "ALL_LN_FOLDERS=\"${ALL_LN_FOLDERS}\"" > "${PROJECT_DIR}/.env_changes"

# Loop over changes to find the L{N} and envvars changes
echo -e "Checking following changed files:\n${CHANGED_FILES}"
for FILE in $CHANGED_FILES
do

  # Check for L{N} folder changes to the `code` or `environments` folders
  if [[ "$FILE" =~ ^L[0-9]+_[^/]+/(code|environments)/.*$ ]]; then
    echo "CHANGED: ${FILE}"
    LN_FOLDER=$(echo "${FILE}" | cut -d/ -f1)

    # Add the L{N} folder if it doesn't already exist
    if [[ "${CHANGES_LN}" != *"${LN_FOLDER}"* ]]; then
      CHANGES_LN="${CHANGES_LN}${LN_FOLDER};"
    fi
  fi

  # Check for .envvars changes.  These need all L{N} to be run for that environment.
  if [[ "$FILE" =~ ^envvars/.*envvars$ ]]; then
    echo "CHANGED: ${FILE}"
    ENV=$(echo "${FILE}" | cut -d/ -f2 | cut -d. -f1)

    # Mark this environment as having all folders changed
    echo "${ENV}_envvars=true" >> "${PROJECT_DIR}/.env_changes"
  fi
done

# Store changes as an artifact for future jobs.  We can't use stageDependencies 
# variables because they only persist for stages with an explicit dependsOn, 
# which would cause all environments to run in parallel.
echo "CHANGES_LN=\"${CHANGES_LN}\"" >> "${PROJECT_DIR}/.env_changes"
