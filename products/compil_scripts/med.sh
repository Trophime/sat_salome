#!/bin/bash

echo "##########################################################################"
echo "med" $VERSION
echo "##########################################################################"



CONFIGURE_FLAGS=$CONFIGURE_FLAGS'CFLAGS=-m64 CXXFLAGS=-m64' 
# OP 06/02/2017
# Putting option enable-python=no 
# Reason : compilation failure of python interface modules on FD24 (generated by swig in medfile)
# CEA decision 13/02/2017 : deactivation of the compilation of python interface modules because no need python interface
CONFIGURE_FLAGS=$CONFIGURE_FLAGS' --enable-python=no'

if [ -n "$SAT_HPC" ]
then
    CONFIGURE_FLAGS=$CONFIGURE_FLAGS' --enable-parallel'
else
    # CNC 24/01/2017
    # the line "export F77=gfortran" is commented, as we think it is not useful.
    # at least it should'n.
    # If it happens to be necessary, we will correct automake procedure.
    #
    # SRE 27/01/2017
    # In fact this line is necessary because when the g77 compiler exists on the machine,
    # it is found before gfortran and it makes the compilation fail.
    # A mail has been sent to Eric Fayolle to fix this bug.
    # En attendant, on remet la ligne.
    export F77=gfortran
fi

if [ -n "$SALOME_USE_64BIT_IDS" ]
then
    echo "WARNING: user requested 64 bits encoding for integers..."
    export FFLAGS=-fdefault-integer-8
    export FFLAGS=$FFLAGS' -g -O2 -ffixed-line-length-none'
    CONFIGURE_FLAGS=$CONFIGURE_FLAGS' --with-med_int=long'
else
    FFLAGS="-g -O2 -ffixed-line-length-none"
fi

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

# post-build action in case devtoolset-8 is used
LINUX_DISTRIBUTION="$DIST_NAME$DIST_VERSION"
case $LINUX_DISTRIBUTION in
    CO7)
	if [ -n "$X_SCLS" ]
	then
	    X_SCLSVALUE=$(echo $X_SCLS)
	    if [ $X_SCLSVALUE == "devtoolset-8" ]; then
		echo "WARNING: devtoolset-8 is installed on ${LINUX_DISTRIBUTION} - libgfortran will be embedded..."
		cp -RP /usr/lib64/libgfortran.so.5* $PRODUCT_INSTALL/lib/
	    fi
	else
	    echo "INFO: X_SCLS does not seem to be set. skipping..."
	fi
	;;
    *)
        ;;
esac

echo
echo "########## END"

