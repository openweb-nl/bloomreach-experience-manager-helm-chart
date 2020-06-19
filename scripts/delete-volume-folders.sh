#!/usr/bin/env bash
possibleEnvs=("prod" "acc" "test" "local")
volumes=("repository" "logs" "database")
applicationName="bem"
basePath="/var/lib/k8s"
replicationPerNode=4
env="$1"

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

function validationEnv() {
  argumentRequiredMessage="This script expect an argument containing the environment flag. Accepted values are [${possibleEnvs[@]}]"
  if [[ -z ${1} ]]; then
    exitWithError "${argumentRequiredMessage}"
  fi
  if [[ $(contains "${possibleEnvs[@]}" "${1}") == "n" ]]; then
    exitWithError "${argumentRequiredMessage}"
  fi
}

function areYouSure() {
  read  -p "Are you sure you want to continue (yes/no): " decision
  if [[ "${decision}" != "yes" ]]; then
    echo "Exiting script because the user decided not to continue."
    exit 1
  fi
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

validationEnv ${env}
gettingUserConsent ${env}

volumeFolder="${basePath}/${env}/${applicationName}"
for volume in ${volumes[@]} ; do
    path="${volumeFolder}/${volume}"
    for ((i=0;i<${replicationPerNode};i++));
    do
        folderPath="${path}-${i}"
        rm -r ${folderPath}
    done
done
