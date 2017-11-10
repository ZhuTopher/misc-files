#! /bin/bash

if [ ${#} -eq 1 ]; then
	# m: (local machine) Minikube cluster
	if [ "$1" = 'm' ]; then
		kubectl config set-cluster minikube
		# kubectl create namespace czhu-local-machine
		kubectl config set-context cds-local --cluster=minikube --user=minikube --namespace=czhu-local-machine
		# eval $(minikube docker-env)
		# - this would push the docker images to the
		#   Minikube VM, rather than push them to a registry
	# d: (internal) Kubernetes cluster
	elif [ "$1" = 'k' ]; then
		kubectl config set-cluster dev-cluster --server=https://kubeapi.dev --certificate-authority=/etc/ssl/certs/ca.pem
        	kubectl config set-credentials dev-admin --certificate-authority=/etc/ssl/certs/ca.pem --client-key=/etc/ssl/certs/admin-key.pem --client-certificate=/etc/ssl/certs/admin.pem
        	kubectl config set-context cds-dev-system --cluster=dev-cluster --user=dev-admin --namespace=czhu-cds-test
		# eval $(minikube docker-env -u)
		# - undoes the pushing to Minikube VM
	elif [ "$1" = 'g' ]; then
		gcloud container clusters get-credentials kubernetes --zone us-east1-d --project cds-dev-152616

		# by default using the 'cds-test' namespace
		cur_context=$(kubectl config current-context)
		kubectl config set-context "$cur_context" --namespace="cds-test"
	# s-m: swap-to-minikube context
	elif [ "$1" = 's-m' ]; then
		kubectl config use-context cds-local
	# s-d: swap-to-kubernetes context
        elif [ "$1" = 's-k' ]; then
                kubectl config use-context cds-dev-system
	else
		echo "Usage: kubectl-config.sh [m|k|s-m|s-k] OR\n kubectl-config.sh n <namespace>"
	fi
elif [ ${#} -eq 2 ]; then
	if [ "$1" = 'n' ]; then
		# switch namespace on  to ${2}
		cur_context=$(kubectl config current-context)
		namespace="${2}"
		echo "Switching to namespace $namespace in context $cur_context"
		kubectl config set-context "$cur_context" --namespace="$namespace"
	else
		echo "Usage: kubectl-config.sh [m|k|s-m|s-k] OR\n kubectl-config.sh n <namespace>"
	fi
else
	 echo "Usage: kubectl-config.sh [m|k|s-m|s-k] OR\n kubectl-config.sh n <namespace>"
fi
