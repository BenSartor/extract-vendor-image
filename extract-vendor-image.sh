#!/bin/bash
set -eu -o pipefail

declare -r VENDOR_IMAGE_ID=${1:?"usage example: $0 opm6.171019.030.H1"}
declare -r DEVICE=${DEVICE:-"bullhead"}


echo "guess download url"
declare -r DOWNLOAD_URL=$(curl https://developers.google.com/android/images | grep "https://dl.google.com/dl/android/aosp/${DEVICE}" | grep "${VENDOR_IMAGE_ID}")
if [ -z "${DOWNLOAD_URL}" ] ; then
    echo "no download url found => aborting"
    exit 1
fi
echo "using download url: ${DOWNLOAD_URL}"


declare -r DEST_DIR="vendor-image-${DEVICE}-${VENDOR_IMAGE_ID}"
mkdir "${DEST_DIR}"
echo "created destination directory: ${DEST_DIR}"


declare -r TEMP_DIR=$(mktemp --directory --tmpdir extract-vendor-image-XXXXXXXXXX)
echo "created temporary directory: ${TEMP_DIR}"

function cleanup {
    echo "removing temporary directory: ${TEMP_DIR}"
    rm -rf "${TEMP_DIR}"
}
trap cleanup EXIT
