#!/bin/bash

echo "##########################################################################"
echo "glu" $VERSION
echo "##########################################################################"



cd $SOURCE_DIR

echo
echo "*** configure"
./configure --prefix=$PRODUCT_INSTALL
if [ $? -ne 0 ]
then
    echo "ERROR on configure"
    exit 1
fi

echo
echo "*** make" $MAKE_OPTIONS
make -j8 $MAKE_OPTIONS
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

