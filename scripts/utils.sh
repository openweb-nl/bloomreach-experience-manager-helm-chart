#!/usr/bin/env bash

possibleEnvs=("test")
scriptsFolder=${BASH_SOURCE%/*}

function contains() {
    local n=$#
    local value=${!n}
    for ((i=1;i < $#;i++)) {
        if [[ "${!i}" == "${value}" ]]; then
            echo "y"
            return 0
        fi
    }
    echo "n"
    return 1
}

function exitWithError() {
  if [[ -n $1 ]]; then
    echo $1
  fi
  exit 1
}

function areYouSure() {
  read  -p "Are you sure you want to continue (yes/no): " decision
  if [[ "${decision}" != "yes" ]]; then
    echo "Exiting script because the user decided not to continue."
    exit 1
  fi
}

function validationEnv() {
  argumentRequiredMessage="This script expect an argument containing the environment flag"
  if [[ -z ${1} ]]; then
    exitWithError "${argumentRequiredMessage}"
  fi
  if [[ ! -d "${scriptsFolder}/../environments/${1}" ]]; then
    exitWithError "Environment: '${1}' not found in values folder."
  fi
  envFolder="${scriptsFolder}/../environments/${1}"
}

function gettingUserConsent() {
  echo "Selected environment is \"${1}\""
  echo "Value of KUBECONFIG is \"${KUBECONFIG}\""
  areYouSure

  if [[ ${1} == "prod" ]]; then
    echo "since the selected environment is \"${1}\" I will ask you again."
    areYouSure
  fi
}

function deletePvcs() {
  local ns=${1}
  pvcs=$(kubectl get -n ${ns} pvc --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}')
  for pvc in $pvcs
  do
    kubectl delete -n ${ns} pvc/${pvc}
  done
}
