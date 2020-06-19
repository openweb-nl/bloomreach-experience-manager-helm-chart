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


validationEnv ${env}
volumeFolder="${basePath}/${env}/${applicationName}"
mkdir -p ${volumeFolder}
for volume in ${volumes[@]} ; do
    path="${basePath}/${env}/${applicationName}/${volume}"
    for ((i=0;i<${replicationPerNode};i++));
    do
       folderPath="${path}-${i}"
       echo "${folderPath}"
       mkdir "${folderPath}"
    done
done
