#!/usr/bin/env bash
basePath=${BASH_SOURCE%/*}
env="$1"

. ${basePath}/scripts/utils.sh
validationEnv ${env}
valuesFolder=${basePath}/environments/${env}
. ${basePath}/environments/${env}/variables.sh

if [[ ! -z "$2" ]]; then
deployment="$2"
fi

helm uninstall --namespace=${namespace} ${deployment}
