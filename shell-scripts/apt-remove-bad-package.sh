#! /bin/bash

# https://askubuntu.com/a/510887

package_name=${1:-''}
dump_directory=${2:-"/tmp/${package_name}-dump"}
remove_dump=${3:-''}

if [[ ${#} -lt 2 || ${#} -ge 5 ]]; then
	echo "Usage: <package name> [OPT: dump directory] [OPT: save dump directory]"
	exit 1
fi

if [[ -z $package_name ]]; then
	echo "Package name not supplied"
	exit 2
fi

if [[ -d $dump_directory ]]; then
	echo "Directory does not exist"
	exit 3
fi

sudo mkdir ${dump_directory}
sudo mv "/var/lib/dpkg/info/${package_name}.*" ${dump_directory}
sudo dpkg --remove --force-remove-reinstreq ${package_name}
sudo apt-get remove ${package_name}
sudo apt-get autoremove && sudo apt-get autoclean

if [ -z ${remove_dump} ]; then
	sudo rm -rf ${dump_directory}
fi

