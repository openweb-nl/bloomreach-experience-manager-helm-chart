#!/usr/bin/env bash
basePath=${BASH_SOURCE%/*}
env="$1"

. ${basePath}/scripts/utils.sh
validationEnv ${env}
valuesFolder=${basePath}/values/${env}
. ${valuesFolder}/variables.sh

kubectl create namespace "${namespace}"

helm install --namespace=${namespace}  -f ${valuesFolder}/bem-values.yaml volumes ${basePath}/charts/volumes/