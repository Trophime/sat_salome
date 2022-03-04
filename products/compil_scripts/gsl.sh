#!/bin/bash

echo "##########################################################################"
echo "gsl" $VERSION
echo "##########################################################################"

rm -Rf $PRODUCT_INSTALL

cp -r $SOURCE_DIR/* .

echo
echo "*** manual call of the aclocal, libtoolize, autoconf and automake in order to re-generate configure script and Makefiles"
aclocal -I m4 
if [ $? -ne 0 ]
then
    echo "error on manual call to aclocal"
    exit 1
fi
libtoolize --force --copy --automake
if [ $? -ne 0 ]
then
    echo "error on manual call to libtoolize"
    exit 1
fi
autoconf
if [ $? -ne 0 ]
then
    echo "error on manual call to autoconf"
    exit 1
fi
automake --copy --gnu --add-missing
if [ $? -ne 0 ]
then
    echo "error on manual call to automake"
    exit 1
fi

echo
echo "*** configure"
BFLAG="-m64"
OLEVEL="-O2"

echo ./configure --prefix=${PRODUCT_INSTALL}
./configure --prefix=${PRODUCT_INSTALL}
    
if [ $? -ne 0 ]
then
    echo "error on configure"
    exit 1
fi

echo
echo "*** compile"
make
if [ $? -ne 0 ]
then
    echo "error on make"
    exit 2
fi

echo
echo "*** install"
make install
if [ $? -ne 0 ]
then
    echo "error on make install"
    exit 3
fi


echo
echo "########## END"
