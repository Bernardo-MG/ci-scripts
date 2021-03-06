#!/bin/bash
#
# Deploys a Debian file to Bintray.
#
# To increase security it takes authentication data from environmental
# variables, using parameters only for non-sensitive data.
#
# -- PARAMETERS --
# $1: flow control boolean flag, indicating if the script should be run or not.
# $2: distribution name
# $3: package version
# $4: architecture supported
# $5: Debian repo URL
#
# --- ENVIRONMENTAL VARIABLES ---
#
# The following environmental variables are required by the script, but read by Maven:
# - DEPLOY_USER: string, user for the packages repo
# - DEPLOY_PASSWORD: string, password for the packages repo
#

# Fails if any used variable is not set
set -o nounset
# Fails if any commands returns a non-zero value
set -e

deploy=${1:-}
distribution=${2:-}
version=${3:-}
architecture=${4:-}
repo_url=${5:-}

# Expects a flow control parameter
if [ "${deploy}" == "true" ]; then

   echo "Deploying Debian package"

   file_name="${distribution}_${version}_${architecture}.deb"
   file_path="../$file_name"
   deploy_url="${repo_url}${file_name};deb_distribution=${distribution};deb_component=${distribution};deb_architecture=${architecture}"

   curl -T "${file_path}" -u"${DEPLOY_USER}":"${DEPLOY_PASSWORD}" -H "X-Bintray-Package:${distribution}" -H "X-Bintray-Version:${version}" "${deploy_url}"

   exit 0

else

   echo "Debian package won't be deployed"

   exit 0

fi