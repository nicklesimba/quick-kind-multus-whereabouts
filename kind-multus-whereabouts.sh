#!/usr/bin/env bash

# start the KIND cluster
kind create cluster --config config-3node.yml --name test

# install multus
kubectl create -f multus-daemonset.yml
kubectl config set-context --current --namespace=kube-system

# install whereabouts
kubectl apply \
    -f whereabouts-yml/daemonset-install.yml \
    -f whereabouts-yml/whereabouts.cni.cncf.io_ippools.yml \
    -f whereabouts-yml/whereabouts.cni.cncf.io_overlappingrangeipreservations.yml \
    -f whereabouts-yml/ip-reconciler-job.yml

# install macvlan
kubectl apply -f cni-install.yml
