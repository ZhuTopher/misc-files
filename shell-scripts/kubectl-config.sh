#! /bin/bash

function setup_check() {
  if [[ ( ! -r /opt/kubectl-config/certificate-authority ) ||
    ( ! -r /opt/kubectl-config/client-key ) ||
    ( ! -r /opt/kubectl-config/client-certificate ) ]]; then
    echo -e "Required config files at \"/opt/kubectl-config/\""\
            "were missing or unreadable.\nPlease run" \
            "\"kubectl-config -s\" to perform setup."
    exit 3
  fi
}

function print_usage() {
  echo -e "${USAGE_MSG}"
}

USAGE_MSG="Usage: kubectl-config [ OPTION ]
\n====== OPTIONS ======
-s \t\t Setup kubectl-config
-c [ CONTEXT ]\t Set context to CONTEXT
-n [ ARGUMENT ]\t Set namespace to ARGUMENT
\n====== TYPES ======
CONTEXT\t\tone of { kubernetes, gcp-dev, gcp-uat, gcp-prod }
\t\t-- shorthand is { k8s, dev, uat, prod }"

read -d '' GCLOUD_PERM_MSG <<"EOF"
Please ensure you have run 'gcloud auth login'
and that your Google account has the correct 
permissions for your project.
EOF

if [[ ${#} -eq 0 ]]; then
  print_usage
  exit 0
fi

while getopts "shc:n:" opt; do
  case ${opt} in
    s)
      echo "Configuring kubectl-config."

      if [[ ! ( -d '/opt/kubectl-config') ]]; then
        echo "Saving config files in /opt/kubectl-config"
        sudo mkdir /opt/kubectl-config
      fi

      # Download the .pem files from https://confluence.esentire.com:8443/display/DEVOPS/Kubernetes+Developer+Guide
      read -p "Please enter the path to your certificate authority .pem file: " -r
      if [[ -r "${REPLY}" ]]; then
        echo -n "${REPLY}" | sudo tee /opt/kubectl-config/certificate-authority > /dev/null 2>&1
      else
        echo "Specified file did not exist or did not have read permissions."
        exit 2
      fi

      read -p "Please enter the path to your client key .pem file: " -r
      if [[ -r "${REPLY}" ]]; then
        echo -n "${REPLY}" | sudo tee /opt/kubectl-config/client-key > /dev/null 2>&1
      else
        echo "Specified file did not exist or did not have read permissions."
        exit 2
      fi

      read -p "Please enter the path to your client certificate .pem file: " -r
      if [[ -r "${REPLY}" ]]; then
        echo -n "${REPLY}" | sudo tee /opt/kubectl-config/client-certificate > /dev/null 2>&1
      else
        echo "Specified file did not exist or did not have read permissions."
        exit 2
      fi

      echo "Finished configuring kubectl-config."
      ;;
    c)
      setup_check
      echo "Setting context to \"${OPTARG}\"."
      # 'kubeapi.dev' internal Kubernetes cluster
      if [[ ( "${OPTARG}" = 'kubernetes' ) || ( "${OPTARG}" = 'k8s' ) ]]; then
        kubectl config set-cluster dev-cluster \
          --server=https://kubeapi.dev \
          --certificate-authority="$(cat /opt/kubectl-config/certificate-authority)"
        kubectl config set-credentials dev-admin \
          --certificate-authority="$(cat /opt/kubectl-config/certificate-authority)" \
          --client-key="$(cat /opt/kubectl-config/client-key)" \
          --client-certificate="$(cat /opt/kubectl-config/client-certificate)"

        kubectl config set-context cds-dev-system --cluster=dev-cluster --user=dev-admin --namespace='default'
        kubectl config use-context cds-dev-system
      # 'cds-dev-152616' GCP project
      elif [[ ( "${OPTARG}" = 'gcp-dev' ) || ( "${OPTARG}" = 'dev' ) ]]; then
        gcloud container clusters get-credentials kubernetes --zone us-east1-d --project cds-dev-152616
        if [[ ${?} -ne 0 ]]; then
          echo "${GCLOUD_PERM_MSG}"
        fi

        CUR_CONTEXT=$(kubectl config current-context)
        kubectl config set-context "${CUR_CONTEXT}" --namespace='default'
      # 'cds-uat' GCP project
      elif [[ ( "${OPTARG}" = 'gcp-uat' ) || ( "${OPTARG}" = 'uat' ) ]]; then
         gcloud container clusters get-credentials kubernetes --zone us-east1-b --project cds-uat
         if [[ ${?} -ne 0 ]]; then
          echo "${GCLOUD_PERM_MSG}"
        fi

        CUR_CONTEXT=$(kubectl config current-context)
        kubectl config set-context "${CUR_CONTEXT}" --namespace='default'
      # 'cds-prod' GCP project
      elif [[ ( "${OPTARG}" = 'gcp-prod' ) || ( "${OPTARG}" = 'prod' ) ]]; then
        gcloud container clusters get-credentials kubernetes --zone us-east1-b --project cds-prod
        if [[ ${?} -ne 0 ]]; then
          echo "${GCLOUD_PERM_MSG}"
        fi

        CUR_CONTEXT=$(kubectl config current-context)
        kubectl config set-context "${CUR_CONTEXT}" --namespace='default'
      fi
      ;;
    n)
      setup_check
      CUR_CONTEXT=$(kubectl config current-context)
      NAMESPACE="${OPTARG}"
      echo "Setting namespace to \"${NAMESPACE}\" in context \"${CUR_CONTEXT}\"."

      kubectl config set-context "${CUR_CONTEXT}" --namespace="${NAMESPACE}"
      ;;
    h)
      print_usage
      ;;
    \?)
      #echo -e -n "Invalid option.\n\n"
      print_usage
      exit 1
      ;;
    :)
      #echo -e -n "Option -${OPTARG} requires an argument.\n\n"
      print_usage
      exit 1
      ;;
  esac
done

exit 0