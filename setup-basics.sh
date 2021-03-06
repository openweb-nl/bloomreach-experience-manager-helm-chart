#!/usr/bin/env bash
basePath=${BASH_SOURCE%/*}
env="$1"

. ${basePath}/scripts/utils.sh
validationEnv ${env}
valuesFolder=${basePath}/environments/${env}
. ${valuesFolder}/variables.sh

kubectl create namespace "${namespace}"

kubectl apply -f ${basePath}/k8s/storageclass.yaml

kubectl apply --namespace=${namespace} -f ${valuesFolder}/secrets.yml

helm install --namespace=${namespace}  -f ${valuesFolder}/volumes-values.yaml volumes ${basePath}/charts/volumes/
