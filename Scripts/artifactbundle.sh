#!/bin/sh

set -e

ARTIFACT_BUNDLE=adevices.artifactbundle
INFO_TEMPLATE=Scripts/spm-artifact-bundle-info.template
VERSION=0.1.0
BINARY_OUTPUT_DIR=$ARTIFACT_BUNDLE/adevices-$VERSION/bin

mkdir $ARTIFACT_BUNDLE

# Copy license into bundle
cp LICENSE $ARTIFACT_BUNDLE

# Create bundle info.json from template, replacing version
sed 's/__VERSION__/'"${VERSION}"'/g' $INFO_TEMPLATE > "${ARTIFACT_BUNDLE}/info.json"

# Copy MacOS adevices binary into bundle
mkdir -p $BINARY_OUTPUT_DIR
unzip release_binary.zip
cp release_binary/adevices $BINARY_OUTPUT_DIR

# Create ZIP
zip -yr - $ARTIFACT_BUNDLE > "${ARTIFACT_BUNDLE}.zip"

rm -rf $ARTIFACT_BUNDLE
rm -rf release_binary