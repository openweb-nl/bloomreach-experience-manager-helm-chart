#!/usr/bin/env bash
volumes=("repository" "logs" "database")
basePath=${BASH_SOURCE%/*}
env=$1
user=$2
servers=${@:3}

volumesRootFolder="/var/lib/k8s"

. ${basePath}/utils.sh

if [[ -z ${1} ]] || [[ -z ${2} ]] || [[ -z ${3} ]]; then
  exitWithError "This script expects at least 3 arguments. Example: > ./create-volume-folders.sh <environment> <userName> <ipOfServer1> <ipOfServer2>"
fi

validationEnv "${env}"
. ${envFolder}/variables.sh


echo "Env: ${env}"
echo "User: ${user}"
echo "Servers: ${servers}"

areYouSure

volumeFolder="${volumesRootFolder}/${env}/${applicationName}"

for s in ${servers[@]}
do
    ssh "${user}@${s}" sudo rm -r "${volumeFolder}"
done

