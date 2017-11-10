#! /bin/bash

kubectl delete --all deploy
kubectl delete --all services
kubectl delete --all jobs
kubectl delete --all daemonsets
kubectl delete --all po
