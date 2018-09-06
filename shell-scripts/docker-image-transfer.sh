#! /bin/bash

function print_usage() {
  echo -e "${usage_msg}"
}

usage_msg="Usage: docker-image-transfer [ OPTION ]
\n====== OPTIONS ======
-h          Display help message
-p          Pull source image from Docker registry
-y [ARG]    Yield to default values
            - [ARG] should be the image name (no tag)
"

default_src_proj="voltron"
default_src_tag="latest"
default_tgt_proj="$(oc project -q)"

is_pulling=false

while getopts "hpy:" opt; do
  case "${opt}" in
    h)
        print_usage
        exit 0
        ;;
    p)
        is_pulling=true
        ;;
    y)
        using_defaults=true
        src_name="$OPTARG"
        ;;
    :)  # Argument required but not provided
        ;&  # Fallthrough
    \?)
        print_usage
        exit 1
        ;;
  esac
done

if [ "$using_defaults" = true ]; then
    src_proj="$default_src_proj"
    src_tag="$default_src_tag"
    tgt_proj="$default_tgt_proj"
    tgt_name="$src_name"
    tgt_tag="$src_tag"
else
    if [ "$is_pulling" = true ]; then
        read -p "Enter source project (voltron): " src_proj
    fi
    src_proj="${src_proj:-voltron}"

    read -p "Enter source image name: " src_name

    read -p "Enter source image tag (latest): " src_tag
    src_tag="${src_tag:-latest}"

    read -p "Enter target project ($(oc project -q)): " tgt_proj
    tgt_proj="${tgt_proj:-$(oc project -q)}"

    read -p "Enter target image name ($src_name): " tgt_name
    tgt_name="${tgt_name:-$src_name}"

    read -p "Enter target tag ($src_tag): " tgt_tag
    tgt_tag="${tgt_tag:-$src_tag}"
fi


if [ "$is_pulling" = true ]; then
    # pull image from OpenShift Docker registry
    src_string="docker-registry-default.router.default.svc.cluster.local/${src_proj}/${src_name}:${src_tag}"
    docker pull "${src_string}"
else
    # image is on local machine
    src_string="${src_name}:${src_tag}"
fi
tgt_string="docker-registry-default.router.default.svc.cluster.local/${tgt_proj}/${tgt_name}:${tgt_tag}"

echo "Source image: $src_string"
echo "Target image: $tgt_string"
if [ ! "$using_defaults" = true ]; then
    read -p "Is this correct? (Y/n): " is_pushing
    if [ "$is_pushing" = "n" ]; then
        echo "Aborted pushing image."
        exit 0
    fi
fi

docker tag "${src_string}" "${tgt_string}"
docker push "${tgt_string}"
