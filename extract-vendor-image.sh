#!/bin/bash
set -eu -o pipefail

declare -r VENDOR_IMAGE_ID=${1:?"usage example: $0 opm6.171019.030.H1"}
declare -r DEVICE=${DEVICE:-"bullhead"}


echo "guess download url"
declare -r DOWNLOAD_URL=$(curl https://developers.google.com/android/images | sed -n "s|.*href=\"\(https://dl.google.com/dl/android/aosp/${DEVICE}.*${VENDOR_IMAGE_ID}.*\.zip\)\"|\1|p")
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


echo "download and unpack factory image"
declare -r FACTORY_IMAGE="${TEMP_DIR}/factory-image.zip"
curl "${DOWNLOAD_URL}" -o "${FACTORY_IMAGE}"
unzip -d "${TEMP_DIR}" "${FACTORY_IMAGE}"
rm "${FACTORY_IMAGE}"
unzip -d "${TEMP_DIR}" $(find "${TEMP_DIR}" -name \*.zip)


echo "copy files to destination directory"
declare -r RADIO_IMG=$(find "${TEMP_DIR}" -name radio-*.img)
cp "${RADIO_IMG}" "${DEST_DIR}"

declare -r BOOTLOADER_IMG=$(find "${TEMP_DIR}" -name bootloader*.img)
cp "${BOOTLOADER_IMG}" "${DEST_DIR}"

declare -r VENDOR_IMG=$(find "${TEMP_DIR}" -name vendor*.img)
cp "${VENDOR_IMG}" "${DEST_DIR}"


echo "SUCCESS use the following commands to flash"
echo "  adb reboot bootloader"
echo "  fastboot flash radio ${RADIO_IMG}"
echo "  fastboot flash bootloader ${BOOTLOADER_IMG}"
echo "  fastboot flash vendor ${BOOTLOADER_IMG}"
