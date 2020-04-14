.DEFAULT_GOAL := help
.ONESHELL:
SHELL:=/usr/bin/env bash

KIND_CLUSTER_NAME := ${KIND_CLUSTER_NAME}
KINDCFG := ${PWD}/kind/kind-configuration.yaml

KUBECONFIG := $(cat ${PWD}/kubeconfig-path)
export KUBECONFIG

.PHONY: help
help:
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

.PHONY: kind_create
kind_create: ## Install Control plane K8S
	kind get clusters | grep ${KIND_CLUSTER_NAME} || \
	kind create cluster --name ${KIND_CLUSTER_NAME} --config $(KINDCFG) && \
	kubectl cluster-info --context kind-${KIND_CLUSTER_NAME}

.PHONY: kind_delete
kind_delete: ## Delete Control plane K8S
	kind delete cluster --name ${KIND_CLUSTER_NAME} && \
	kind get clusters

define taskawsbootstrapdelete
	aws --profile=vmw cloudformation delete-stack --stack-name ${AWS_CLOUDFORMATION_STACK}
endef

.PHONY: aws_bootstrap_delete
aws_bootstrap_delete: ## Delete bootstraped AWS environment
	$(value taskawsbootstrapdelete)

.PHONY: clusterctl_init_dry
clusterctl_init_dry:
	clusterctl init --infrastructure aws --list-images

.PHONY: clusterctl_init
clusterctl_init:
	clusterctl init --infrastructure=aws:${CAPA_VERSION} --core=cluster-api:${CAPI_VERSION} --v 10
	
.PHONY: clean_all
clean_all: ## Clean all the local environment
	kind get clusters | xargs -I NAME kind delete cluster --name=NAME || exit 0
	rm -rf ${PWD}/*kubeconfig*
	touch ${PWD}/kubeconfig-path

define taskkubeconfig
	rm -f ${PWD}/kubeconfig-path && touch ${PWD}/kubeconfig-path; \
	mkdir -p ${PWD}/kubeconfig/; \
	for k in $(kind get clusters); \
		do \
			kind get kubeconfig --name=${k} > ${PWD}/kubeconfig/${k}-kubeconfig; \
			echo "$(cat kubeconfig-path)${PWD}/kubeconfig/${k}-kubeconfig" > ${PWD}/kubeconfig-path; \
		done
endef

.PHONY: kubeconfig_export
kubeconfig_export: ## Export KUBECONFIG parameters
	$(value taskkubeconfig)