#!/bin/bash

echo "Destroy dynamically provisioned resources..."

set -x

kubectl delete application ecostream -n argocd
helm uninstall grafana prometheus -n monitoring
helm uninstall ecostream-argo -n argocd

kubectl delete ingress --all --all-namespaces
kubectl delete pvc --all --all-namespaces

kubectl delete namespaces ecostream monitoring argocd

set +x

echo "Done"