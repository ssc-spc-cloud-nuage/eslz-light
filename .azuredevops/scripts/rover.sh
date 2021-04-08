#!/bin/bash
set -euo pipefail
IFS=';'

# PURPOSE:
# Run a rover command for given L{N} folders and environment.
# If the command is "plan", script checks if there are any changes to apply.
# 
# USE:
# rover.sh ENV COMMAND [PROJECT_DIR]
# rover.sh dev plan /tf/caf

ENV="${1}"
COMMAND="${2}"
PROJECT_DIR="${3:-/tf/caf}"
PLAN_FOLDERS=""

# Set error exit code
set_error() {
  EXIT_VALUE=1
}

# Load environment vars from a .env file
load_env_vars() {
  ENV_FILE="${PROJECT_DIR}/${1}"
  if [[ -f "${ENV_FILE}" ]]; then
    set -o allexport; source "${ENV_FILE}"; set +o allexport
  fi
}

# Capture all errors and set our overall exit value.
trap 'set_error' ERR

# Load the environment files
load_env_vars ".env_plans_${ENV}"
load_env_vars ".env_changes"

# Get the folders we need to run this rover command against:
# 1. CHANGES_PLAN   (from .env_plans) all L{N} folders that have infrastructure changes (a plan exists)
# 2. ALL_LN_FOLDERS (from .env_changes) all L{N} folders in the project.  Required when an environment's .envvars file changes.
# 3. CHANGES_LN     (from .env_changes) all L{N} folders with code changes.
if [[ "${COMMAND}" == "apply" ]] && [[ -v "CHANGES_PLAN" ]]; then
  FOLDERS="${CHANGES_PLAN}"
elif [[ -v "${ENV}_envvars" ]]; then
  FOLDERS="${ALL_LN_FOLDERS}"
else
  FOLDERS="${CHANGES_LN}"
fi

# Set non-plan rover commands to auto approve
COMMAND_ARGS=""
if [[ "${COMMAND}" != "plan" ]]; then
  COMMAND_ARGS="-auto-approve"
fi

# Run rover command for all folders
for FOLDER in ${FOLDERS}; do  

  # Cleanup and check for skip_env variables in the environment's .env file
  unset skip_${ENV}
  load_env_vars "${FOLDER}/environments/.env"

  # Only run a plan if an environment .tfvars file exists and skip_${ENV} variable is not set
  if [[ -f "${PROJECT_DIR}/${FOLDER}/environments/${ENV}.tfvars" ]] && [[ ! -v "skip_${ENV}" ]]; then

    cd "${PROJECT_DIR}/${FOLDER}"
    echo "RUN: gorover ${ENV} ${COMMAND} ${COMMAND_ARGS} (${FOLDER})"

    # Duplicate STDOUT (&1) file descriptor so that we can capture script output in a variable
    # and also output it to the terminal.  This way a non-zero exit from gorover.sh doesn't
    # stop the script output from being displayed.
    exec 5>&1
    OUTPUT=$(/tf/rover/gorover.sh ${ENV} ${COMMAND} ${COMMAND_ARGS} | tee >(cat - >&5))

    # Check if there were changes in the plan.
    if [[ "${COMMAND}" == "plan" ]]; then   
      if [[ "${OUTPUT}" != *"No changes. Infrastructure is up-to-date."* ]]; then
        echo "PLAN: changes exist for  ${FOLDER}"
        PLAN_FOLDERS="${PLAN_FOLDERS}${FOLDER};"
      else
        echo "PLAN: no changes for ${FOLDER}"
      fi
    fi

  elif [[ -v "skip_${ENV}" ]]; then
    echo "SKIP: ${FOLDER}/environments/.env skip_${ENV} variable exists"
  else
    echo "SKIP: ${FOLDER}/environments/${ENV}.tfvars does not exist"
  fi
done

# Store the folders that have an infrastructure change (plans)
echo "CHANGES_PLAN=\"${PLAN_FOLDERS}\"" > "${PROJECT_DIR}/.env_plans_${ENV}"
if [[ ! -z "${PLAN_FOLDERS}" ]]; then  
  echo "##vso[task.setvariable variable=DO_APPLY;isOutput=true]1"
fi
