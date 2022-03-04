#!/bin/bash

echo "##########################################################################"
echo "Spectra" $VERSION
echo "##########################################################################"


mkdir -p ${PRODUCT_INSTALL}
cp -rp ${SOURCE_DIR}/include ${PRODUCT_INSTALL}
if [ $? -ne 0 ]
then
    echo "ERROR installing spectra"
    exit 3
fi

echo
echo "########## END"

