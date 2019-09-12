#!/bin/bash
DATA="/mnt/d/Steam/steamapps/common/Skyrim Special Edition/Data"
COMPILER="$DATA/../Papyrus Compiler/PapyrusCompiler.exe"
BUILD="Temp-Build"
SOURCE="$BUILD/Source"
OUTPUT="$BUILD/Output"

MAJOR=1
MINOR=0
PATCH=1
BUILD_NO=34


mkdir -p "$DATA/$BUILD"
mkdir -p "$DATA/$SOURCE"
mkdir -p "$DATA/$OUTPUT"

echo "Copying source"
chmod -R u+rw Source

cp Source/Scripts/* "$DATA/$SOURCE/"
cp Smalls.flg "$DATA/$SOURCE"

echo "int property pMajorVersion = $MAJOR AutoReadOnly" >> "$DATA/$SOURCE/SmallsQuest.psc"
echo "int property pMinorVersion = $MINOR AutoReadOnly" >> "$DATA/$SOURCE/SmallsQuest.psc"
echo "int property pPatchVersion = $PATCH AutoReadOnly" >> "$DATA/$SOURCE/SmallsQuest.psc"
echo "int property pBuildNumber = $BUILD_NO AutoReadOnly" >> "$DATA/$SOURCE/SmallsQuest.psc"

echo "Compiling"
pushd "$DATA"
ls "$SOURCE"

"$COMPILER" "$SOURCE" -all -o="$OUTPUT" -i="Scripts/Source" -i="Source/Scripts" -f="$SOURCE/Smalls.flg"

echo "Copying Output"
cp "$OUTPUT/"*.pex "Scripts/"
cp "$SOURCE/"*.psc "Source/Scripts/"
popd

touch "$DATA/Smalls.esp"

cp "$DATA/$OUTPUT"/*.pex Scripts/
cp "$DATA/Smalls.esp" .
rm -r "$DATA/$BUILD"
