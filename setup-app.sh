#!/usr/bin/env bash
basePath=${BASH_SOURCE%/*}
env="$1"

. ${basePath}/scripts/utils.sh
validationEnv ${env}
valuesFolder=${basePath}/environments/${env}
. ${valuesFolder}/variables.sh

if [[ ! -z "$2" ]]; then
deployment="$2"
cmsUrl="${2}-cms-bloomreach.openweb.nl"
siteUrl="${2}-site-bloomreach.openweb.nl"
fi

if [[ ! -z "${cmsUrl}" ]]; then
 helm install --namespace=${namespace} -f ${valuesFolder}/bem-values.yaml --set "ingress.cms.host=${cmsUrl}" --set "ingress.site.host=${siteUrl}" ${deployment} ${basePath}/charts/bloomreach/
else
 helm install --namespace=${namespace}  -f ${valuesFolder}/bem-values.yaml ${deployment} ${basePath}/charts/bloomreach/
fi


