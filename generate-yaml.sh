#!/usr/bin/env bash
basePath=${BASH_SOURCE%/*}
helm template deploymentName ${basePath}/charts/volumes/ > ${basePath}/samples/volumes.yml
helm template deploymentName ${basePath}/charts/bloomreach/ > ${basePath}/samples/bloomreach.yml
helm template deploymentName ${basePath}/charts/mysql/ > ${basePath}/samples/mysql.yml
