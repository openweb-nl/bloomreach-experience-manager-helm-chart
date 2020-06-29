#!/usr/bin/env bash
basePath=${BASH_SOURCE%/*}
env="$1"

. ${basePath}/scripts/utils.sh
validationEnv ${env}
valuesFolder=${basePath}/environments/${env}
. ${valuesFolder}/variables.sh

${basePath}/setup-basics.sh ${env}
${basePath}/setup-mysql.sh ${env}
${basePath}/setup-app.sh ${env}
