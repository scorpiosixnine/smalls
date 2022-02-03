
export MODULE_NAME=Smalls
export MAJOR=2
export MINOR=0
export PATCH=0
export GIT_NO=`git log --oneline | wc -l`
export BUILD_NO=$(($GIT_NO + 20))
export VERSION="$MAJOR.$MINOR.$PATCH"
export SDKS="sdks/skyui/dist/Data/Scripts/Headers;sdks/skse64-sdk;sdks/jcontainers-sdk;sdks/skyrim-sdk/Source/Scripts"

echo "Module: $MODULE_NAME"
echo "Version is $VERSION ($BUILD_NO)"
