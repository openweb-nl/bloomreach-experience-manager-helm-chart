#!/usr/bin/env bash
basePath=${BASH_SOURCE%/*}
env="$1"

. ${basePath}/scripts/utils.sh
validationEnv ${env}
valuesFolder=${basePath}/values/${env}
. ${basePath}/values/${env}/variables.sh

helm uninstall --namespace=${namespace} myapp

deletePvcs "${namespace}"

helm uninstall --namespace=${namespace} volumes

kubectl delete --namespace=${namespace} -f ${valuesFolder}/secrets.yml

kubectl delete namespace "${namespace}"
