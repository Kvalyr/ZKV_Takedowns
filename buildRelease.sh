#!/bin/bash

if [ -z "$1" ]
then
    echo "Error: Release version not specified"
    exit 1
fi


set -e

MOD="ZKV_Takedowns"

VERSION="$1"
VERSION=${VERSION//./_}

RELEASE_DIR=${MOD}_${VERSION}

echo "${MOD}"
echo "${VERSION}"
echo "${RELEASE_DIR}"

cd release

# [ -d "${RELEASE_DIR}" ] && echo "Directory ${RELEASE_DIR} exists."
# [ -d ${RELEASE_DIR} ] && echo "Directory ${RELEASE_DIR} exists." || echo "Error: Directory ${RELEASE_DIR} does not exist."

if [ -d "$RELEASE_DIR" -a ! -h "$RELEASE_DIR" ]
then
    echo "RELEASE_DIR: ${RELEASE_DIR}/ exists."
    rm -rf ${RELEASE_DIR}
else
    echo "RELEASE_DIR: ${RELEASE_DIR}/ does not exist."
fi

mkdir ${RELEASE_DIR}

# Archives
mkdir -p ${RELEASE_DIR}/archive/pc/mod
rsync -v -a ../ --files-from=manifest_archive.zkv ${RELEASE_DIR}

# CET
mkdir -p ${RELEASE_DIR}/bin/x64/plugins/cyber_engine_tweaks/mods/$MOD
rsync -v -a ../_CET --files-from=manifest_cet.zkv ${RELEASE_DIR}/bin/x64/plugins/cyber_engine_tweaks/mods/$MOD

# Redscript
mkdir -p ${RELEASE_DIR}/r6/scripts/$MOD
rsync -v -a ../ --files-from=manifest_r6.zkv ${RELEASE_DIR}

ZIP_FILENAME=${RELEASE_DIR}.zip

if [ -f "$ZIP_FILENAME" ] ; then
    rm "$ZIP_FILENAME"
fi

cd ${RELEASE_DIR}
zip -r ../${ZIP_FILENAME} *

cd ..
echo "Done. Release zip at: ${ZIP_FILENAME}"