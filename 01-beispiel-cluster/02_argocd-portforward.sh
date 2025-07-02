#!/bin/bash

while true; do 
  kubectl --context=kind-my-production-cluster port-forward svc/argocd-server 9000:80
  echo restarting port forward. 
  sleep 5
done