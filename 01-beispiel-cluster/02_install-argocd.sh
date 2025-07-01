#!/bin/bash

kubectl --context=kind-my-production-cluster apply -k argocd_setup
sleep 2
kubectl get Secrets/argocd-initial-admin-secret -o template='Username: admin{{"\n"}}Passwort: {{ .data.password | base64decode  }}'
