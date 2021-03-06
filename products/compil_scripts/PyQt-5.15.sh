#!/bin/bash

echo "##########################################################################"
echo "PyQt" $VERSION
echo "##########################################################################"



python_name=python$PYTHON_VERSION

# OP 01/08/2017 Artifact 8859 : test compilation PyQt 5.9
#                               On fait tout dans les sources
#CURRENT_DIR=`pwd`
cd $SOURCE_DIR
if [ $? -ne 0 ]
then
    echo "ERROR on $SOURCE_DIR access"
    exit 1
fi


echo
echo "*** configure.py --confirm-license --no-designer-plugin --verbose --bindir=${PRODUCT_INSTALL}/bin --destdir=${PRODUCT_INSTALL}/lib/$python_name/site-packages --sipdir=${SIP_ROOT_DIR} --disable=QtNetwork --disable=QtWebSockets"
$PYTHONBIN ./configure.py --confirm-license --no-designer-plugin --verbose \
    --bindir=${PRODUCT_INSTALL}/bin \
    --destdir=${PRODUCT_INSTALL}/lib/$python_name/site-packages \
    --sipdir=${SIP_ROOT_DIR} \
    --disable=QtNetwork --disable=QtWebSockets 2>&1
#    --disable=QtNetwork --disable=QtWebSockets --disable=QtWebKit  --disable=QtWebKitWidgets --disable=QAxContainer --disable=QtMacExtras --disable=QtWinExtras --disable=QtX11Extras --disable=Enginio 2>&1

if [ $? -ne 0 ]
then
    echo "ERROR on configure"
# OP 01/08/2017 Artifact 8859 : test compilation PyQt 5.9
#                               On fait tout dans les sources
#    exit 1
#    cd $CURRENT_DIR
    exit 2
fi

echo
echo "*** make" $MAKE_OPTIONS
make $MAKE_OPTIONS
if [ $? -ne 0 ]
then
    echo "ERROR on make"
# OP 01/08/2017 Artifact 8859 : test compilation PyQt 5.9
#                               On fait tout dans les sources
#    exit 2
#    cd $CURRENT_DIR
    exit 3
fi

echo
echo "*** make install"
make install
if [ $? -ne 0 ]
then
    echo "ERROR on make install"
# OP 01/08/2017 Artifact 8859 : test compilation PyQt 5.9
#                               On fait tout dans les sources
#    exit 3
#    cd $CURRENT_DIR
    exit 4
fi

# OP 01/08/2017 Artifact 8859 : test compilation PyQt 5.9
#                               Ajout du make clean
echo
echo "*** make clean"
make clean
if [ $? -ne 0 ]
then
    echo "ERROR on make clean"
#    cd $CURRENT_DIR
    exit 5
fi

# Issue with GUI - TO BE FIXED
if [ -n "$SIP_ROOT_DIR" ]
then
    mkdir -p $PRODUCT_INSTALL/sip
    cp -r $SIP_ROOT_DIR/* $PRODUCT_INSTALL/sip
else
    echo "FATAL: Please set SIP_ROOT_DIR environment variable"
    exit 6
fi

echo
echo "########## END"

exit 0

