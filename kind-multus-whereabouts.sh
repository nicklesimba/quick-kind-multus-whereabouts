#!/usr/bin/env bash

# start the KIND cluster
kind create cluster --config config-3node.yml --name test

# install multus
kubectl create -f multus-daemonset.yml
kubectl config set-context --current --namespace=kube-system
