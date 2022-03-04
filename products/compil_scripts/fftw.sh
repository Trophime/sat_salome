#!/bin/bash

echo "##########################################################################"
echo "fftw" $VERSION
echo "##########################################################################"


CONFIGURE_FLAGS='--enable-shared'

if [ -n "$SAT_HPC" ]
then
    CONFIGURE_FLAGS=$CONFIGURE_FLAGS' --enable-mpi'
fi
CONFIGURE_FLAGS=$CONFIGURE_FLAGS' --enable-threads'


echo
echo "*** configure"
$SOURCE_DIR/configure --prefix=$PRODUCT_INSTALL FFLAGS="${FFLAGS}" $CONFIGURE_FLAGS
if [ $? -ne 0 ]
then
    echo "ERROR on configure"
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

