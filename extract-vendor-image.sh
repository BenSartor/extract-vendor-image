#!/bin/bash
set -eu -o pipefail

declare -r VENDOR_IMAGE_ID=${1:?"usage example: $0 opm6.171019.030.H1"}


declare -r TEMP_DIR=$(mktemp --directory --tmpdir extract-vendor-image-XXXXXXXXXX)
echo "created temporary directory: ${TEMP_DIR}"

function cleanup {
    echo "removing temporary directory: ${TEMP_DIR}"
    rm -rf "${TEMP_DIR}"
}
trap cleanup EXIT


declare -r DEST_DIR="vendor-image-${VENDOR_IMAGE_ID}"
mkdir "${DEST_DIR}"
echo "created destination directory: ${DEST_DIR}"
