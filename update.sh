#!/usr/bin/env bash
basePath=${BASH_SOURCE%/*}
env="$1"

. ${basePath}/scripts/utils.sh
validationEnv ${env}

. ${envFolder}/variables.sh

helm upgrade --namespace=${namespace}  -f ${envFolder}/bem-values.yaml ${deployment} ${basePath}/charts/bloomreach/
