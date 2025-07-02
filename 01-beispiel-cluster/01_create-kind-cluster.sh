#!/bin/bash

kind create cluster --name="my-production-cluster"
sleep 10;
kubectl --context=kind-my-production-cluster apply -k argocd_setup
sleep 10;
kubectl get -n argocd Secrets/argocd-initial-admin-secret -o template='Username: admin{{"\n"}}Passwort: {{ .data.password | base64decode  }}'