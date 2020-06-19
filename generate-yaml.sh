#!/usr/bin/env bash

helm template deploymentName ./charts/volumes/ > ./samples/volumes.yml
helm template deploymentName ./charts/bloomreach/ > ./samples/bloomreach.yml
