#!/bin/bash

VERSION="1.0.0a2"
FOLDER="Releases/Smalls-$VERSION"

mkdir -p "$FOLDER"
cp Smalls.esp "$FOLDER/"
cp Source/Scripts "$FOLDER/"

DATA="/mnt/d/Steam/steamapps/common/Skyrim Special Edition/Data"
COMPILER="$DATA/../Papyrus Compiler/PapyrusCompiler.exe"
BUILD="Temp-Build"
SOURCE="$BUILD/Source"
OUTPUT="$BUILD/Output"

mkdir -p "$DATA/$BUILD"
mkdir -p "$DATA/$SOURCE"
mkdir -p "$DATA/$OUTPUT"

echo "Copying source"
cp Source/Scripts/* "$DATA/$SOURCE/"
cp Smalls.flg "$DATA/$SOURCE"

echo "Compiling"
pushd "$DATA"
ls "$SOURCE"

"$COMPILER" "$SOURCE" -all -o="$OUTPUT" -i="Scripts/Source" -i="Source/Scripts" -f="$SOURCE/Smalls.flg"
cp "$OUTPUT/"*.pex "Scripts/"
cp "$SOURCE/"*.psc "Source/Scripts/"
popd

cp "$DATA/$OUTPUT"/*.pex Scripts/
cp "$DATA/Smalls.esp" .
rm -r "$DATA/$BUILD"
