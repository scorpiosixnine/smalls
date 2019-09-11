#!/bin/sh

VERSION="1.0.0a2"
NAME="Smalls-$VERSION"
FOLDER="Releases/Smalls"
ARCHIVE="$NAME.zip"

DATA="/mnt/d/Steam/steamapps/common/Skyrim Special Edition/Data"
cp "$DATA/Smalls.esp" .


mkdir -p "$FOLDER/Smalls/Source"
cp Smalls.esp "$FOLDER/Smalls/"
cp -r Source/Scripts "$FOLDER/Smalls/Source/Scripts"
cp -r Scripts "$FOLDER/Smalls/Scripts"
cp -r fomod "$FOLDER/"

rm "Releases/$ARCHIVE"
cd "Releases/Smalls"
zip -r "../$ARCHIVE" "fomod" "Smalls"
cd ../..
rm -rf "$FOLDER"
