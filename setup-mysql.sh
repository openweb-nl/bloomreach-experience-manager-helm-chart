#!/usr/bin/env bash
basePath=${BASH_SOURCE%/*}
env="$1"

. ${basePath}/scripts/utils.sh
validationEnv ${env}
valuesFolder=${basePath}/environments/${env}
. ${valuesFolder}/variables.sh

helm install  --namespace=${namespace} -f ${valuesFolder}/mysql-values.yaml mysql ${basePath}/charts/mysql/

