
export MODULE_NAME=Smalls
export MAJOR=1
export MINOR=1
export PATCH=5
export GIT_NO=`git log --oneline | wc -l`
export BUILD_NO=$(($GIT_NO + 20))
export VERSION="$MAJOR.$MINOR.$PATCH"
export SDKS="sdks/skyui/dist/Data/Scripts/Headers;sdks/skse64-sdk;sdks/skyrim-sdk/Source/Scripts"

echo "Module: $MODULE_NAME"
echo "Version is $VERSION ($BUILD_NO)"
