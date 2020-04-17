#!/bin/bash

# Install Argocd
kubectl create ns argocd
helm repo add argo https://argoproj.github.io/argo-helm
helm install argocd argo/argo-cd -n argocd
kubectl wait --for=condition=available deployment -l "app.kubernetes.io/name=argocd-server" -n argocd --timeout=300s
kubectl patch deployment argocd-server --type json -p='[ { "op": "replace", "path":"/spec/template/spec/containers/0/command","value": ["argocd-server","--staticassets","/shared/app","--insecure"] }]' -n argocd
kubectl -n argocd patch secret argocd-secret \
-p '{"stringData": {
  "admin.password": "$2a$10$7OKyjsd.mwz4j1rQ8OuxiOOK.lm7YSMOn5kPdLnYdbhpeDlGxWGDu",
  "admin.passwordMtime": "'$(date +%FT%T%Z)'"
}}' -n argocd
# password
