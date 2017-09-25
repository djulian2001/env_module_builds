#!/bin/bash
# download.sh

wget -c https://www.python.org/ftp/python/3.6.0/Python-3.6.0.tar.xz


source /packages/build/header.source

SOURCE_PKG=Python-3.6.0.tar.xz
BUILD_DIR=Python-3.6.0
PKG_VERSION=3.6.0

TARGET=/packages/6x/python/$PKG_VERSION/
# Prerequisite packages

module purge

# configure
# source variables.include

/bin/rm -rf $TARGET
mkdir -p $TARGET

# Delete our build directory and re-recreate it from the archive
echo-green "\nExtracting source package\n"
/bin/rm -rf $BUILD_DIR
tar xf $SOURCE_PKG

cd $BUILD_DIR

./configure \
	--prefix=$TARGET \
    --enable-shared \
    --enable-optimizations \
	2>&1 | tee ../_configure_out

if [ $? -ne 0 ] ; then
    echo-red "\nError\n"
fi

#build.sh
# source variables.include

cd $BUILD_DIR

echo-green "\nmake -j8\n"

make -j 8 2>&1 | tee ../_make_out

if [ $? -ne 0 ] ; then
    echo-red "\nError\n"
fi



