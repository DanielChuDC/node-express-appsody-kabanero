#!/bin/bash

set -Eeuox pipefail

### Configuration ###

# Resultant Appsody container image #
DOCKER_IMAGE="${DOCKER_IMAGE:-docker-registry.default.svc:5000/kabanero/java-microprofile}"

# Appsody project GitHub repository #
APP_REPO="${APP_REPO:-https://github.com/dacleyra/appsody-hello-world/}"

### Tekton Example ###
namespace=kabanero

# Cleanup
oc -n ${namespace} delete pipelinerun java-microprofile-build-deploy-pipeline-run-kabanero || true
oc -n ${namespace} delete pipelineresource docker-image git-source || true

# Pipeline Resources: Source repo and destination container image
cat <<EOF | oc -n ${namespace} apply -f -
apiVersion: v1
items:
- apiVersion: tekton.dev/v1alpha1
  kind: PipelineResource
  metadata:
    name: docker-image
  spec:
    params:
    - name: url
      value: ${DOCKER_IMAGE}
    type: image
- apiVersion: tekton.dev/v1alpha1
  kind: PipelineResource
  metadata:
    name: git-source
  spec:
    params:
    - name: revision
      value: master
    - name: url
      value: ${APP_REPO}
    type: git
kind: List
EOF


# Manual Pipeline Run
cat <<EOF | oc -n ${namespace} apply -f -
apiVersion: tekton.dev/v1alpha1
kind: PipelineRun
metadata:
  labels:
    app: tekton-app
    tekton.dev/pipeline: java-microprofile-build-deploy-pipeline
  name: java-microprofile-build-deploy-pipeline-run-kabanero
  namespace: kabanero
spec:
  params: []
  pipelineRef:
    name: java-microprofile-build-deploy-pipeline
  resources:
  - name: git-source
    resourceRef:
      name: git-source
  - name: docker-image
    resourceRef:
      name: docker-image
  serviceAccount: kabanero-operator
  timeout: 60m
EOF
