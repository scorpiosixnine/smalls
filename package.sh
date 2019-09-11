#!/bin/sh

VERSION="1.0.0a2"
FOLDER="Releases/Smalls-$VERSION"
mkdir -p "$FOLDER/Source"
cp Smalls.esp "$FOLDER/"
cp -r Source/Scripts "$FOLDER/Source/Scripts"
cp -r Scripts "$FOLDER/Scripts"
cp -r fomod "$FOLDER/"
