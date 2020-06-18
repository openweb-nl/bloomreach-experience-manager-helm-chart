#!/usr/bin/env bash

helm template test ./charts/volumes/ > ./samples/volumes.yml
