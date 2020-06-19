#!/usr/bin/env bash
basePath=${BASH_SOURCE%/*}
env="$1"

. ${basePath}/scripts/utils.sh
validationEnv ${env}
. ${basePath}/values/${env}/variables.sh

helm uninstall --namespace=${namespace} volumes
kubectl delete namespace "${namespace}"
