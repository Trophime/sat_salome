#!/bin/bash

echo "##########################################################################"
echo "solvespace" $VERSION
echo "##########################################################################"




CMAKE_OPTIONS=""
CMAKE_OPTIONS=$CMAKE_OPTIONS" -DCMAKE_INSTALL_PREFIX:STRING=${PRODUCT_INSTALL}"
CMAKE_OPTIONS=$CMAKE_OPTIONS" -DCMAKE_BUILD_TYPE:STRING=Release"
CMAKE_OPTIONS=$CMAKE_OPTIONS" -DONLY_LIB=ON"

echo '$SOURCE_DIR '  $SOURCE_DIR
cmake $CMAKE_OPTIONS $SOURCE_DIR

if [ $? -ne 0 ]
then
    echo "ERROR on CMake"
    exit 1
fi

echo
echo "*** make" $MAKE_OPTIONS
make $MAKE_OPTIONS
if [ $? -ne 0 ]
then
    echo "ERROR on make"
    exit 2
fi

echo
echo "*** make install"
make install
if [ $? -ne 0 ]
then
    echo "ERROR on make install"
    exit 3
fi

echo
echo "########## END"

