#! /bin/bash

if [[ ( ${#} -ne 1 ) ]]; then
    NAMESPACE=$(kubectl config view --minify | grep 'namespace' | sed 's/^ *namespace: \([a-zA-Z0-9_-]*\)$/\1/' | tr -d '\n')
else
    NAMESPACE="${1}"
fi

if [[ -z "${NAMESPACE}" ]]; then
    echo "Namespace was an empty string."
    exit 1
fi

echo "About to delete all deployments, services, jobs, daemonsets, and pods from ${NAMESPACE}."
read -p "Are you sure? [y/N] " -r
if [[ "${REPLY}" =~ [yY]$ ]]; then
    # Using kubectl resource type shorthands
    # - deployments -> deploy
    # - services -> svc
    # - daemonsets -> ds
    # - po -> pods
    kubectl delete --all --namespace="${NAMESPACE}" deploy,svc,jobs,ds,po
else
    echo "Aborted."
fi
