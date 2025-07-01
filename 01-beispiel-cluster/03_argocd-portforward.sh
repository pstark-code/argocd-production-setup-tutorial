#!/bin/bash

while true; do 
  kubectl --context=kind-my-production-cluster port-forward 
  echo restarting port forward. 
  sleep 1
done