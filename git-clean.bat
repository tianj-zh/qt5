SET SOURCE_PATH=%~dp0
pushd %SOURCE_PATH%
git clean -xdf
git submodule foreach --recursive "git clean -xdf"
popd