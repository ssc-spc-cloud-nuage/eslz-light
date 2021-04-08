#!/bin/bash
set -euo pipefail

# PURPOSE: 
# Check if a given environment has changes identified in a .env_changes file.
#
# USE:
# check-changes.sh ENV [PROJECT_DIR] # defaults to /tf/caf
# check_changes.sh dev /tf/caf

ENV="${1}"
PROJECT_DIR="${2:-/tf/caf}"

set -euo pipefail

# Load changes from the .env_changes file
if [[ -f "${PROJECT_DIR}/.env_changes" ]]; then
  set -o allexport; source "${PROJECT_DIR}/.env_changes"; set +o allexport
else
  echo "FATAL: could not find ${PROJECT_DIR}/.env_changes file"
  exit 1
fi

# Check if any changes exist for the given environment
if [[ ! -z "${CHANGES_LN}" ]] || [[ -v "${ENV}_envvars" ]]; then
  echo "RUN: found changes for ${ENV}, running plan..."
  echo "##vso[task.setvariable variable=DO_PLAN;isOutput=true]1"
else
  echo "SKIP: no changes for ${ENV}."
fi