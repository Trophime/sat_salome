#!/bin/bash                                                                                                                                                                              

echo "##########################################################################"
echo "openturns" $VERSION
echo "##########################################################################"

COPY_OPENTURNS=0

if [ -n "$MPI_ROOT_DIR" ]
then
    echo "WARNING: setting CC and CXX environment variables and target MPI wrapper"
    export CC=${MPI_ROOT_DIR}/bin/mpicc
    export CXX=${MPI_ROOT_DIR}/bin/mpicxx
fi

if [ $COPY_OPENTURNS -ne 1 ]; then
    CMAKE_OPTIONS=""
    CMAKE_OPTIONS+=" -DCMAKE_INSTALL_PREFIX:STRING=${PRODUCT_INSTALL}"
    CMAKE_OPTIONS+=" -DCMAKE_BUILD_TYPE:STRING=Release"
    CMAKE_OPTIONS+=" -DPYTHON_EXECUTABLE=${PYTHONBIN}"
    CMAKE_OPTIONS+=" -DSWIG_EXECUTABLE=${SWIG_ROOT_DIR}/bin/swig"

    echo
    echo "*** cmake" $CMAKE_OPTIONS
    cmake $CMAKE_OPTIONS $SOURCE_DIR/openturns-1.16
    if [ $? -ne 0 ]
    then
	echo "ERROR on cmake"
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
    echo "*** check installation"

    if [ -d "${PRODUCT_INSTALL}/lib64" ]
    then
	mv ${PRODUCT_INSTALL}/lib64/* ${PRODUCT_INSTALL}/lib
	rmdir ${PRODUCT_INSTALL}/lib64
    fi

    export PYTHONPATH=${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages:${PYTHONPATH}
    export LD_LIBRARY_PATH=${PRODUCT_INSTALL}/lib:${LD_LIBRARY_PATH}
    chmod +x ${SOURCE_DIR}/openturns-1.16/python/test/t_features.py
    ${SOURCE_DIR}/openturns-1.16/python/test/t_features.py
    if [ $? -ne 0 ]
    then
	echo "ERROR  testing Openturns features...."
	exit 4
    fi
else
    mkdir -p $PRODUCT_INSTALL
    cp -r /volatile/salome/support/SPNS-24377/SALOME-master-CO7/INSTALL/openturns-1.16/* $PRODUCT_INSTALL/
fi
exit 0

CMAKE_OPTIONS=""
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_PREFIX:STRING=${PRODUCT_INSTALL}"
CMAKE_OPTIONS+=" -DCMAKE_BUILD_TYPE:STRING=Release"
CMAKE_OPTIONS+=" -DPYTHON_EXECUTABLE=${PYTHONBIN}"
CMAKE_OPTIONS+=" -DSWIG_EXECUTABLE=${SWIG_ROOT_DIR}/bin/swig"
CMAKE_OPTIONS+=" -DTBB_ROOT_DIR=${TBB_ROOT_DIR}"

LD_LIBRARY_PATH_REF=${LD_LIBRARY_PATH}
if [[ -d "$SOURCE_DIR/otfftw-0.10" ]]; then
    CMAKE_OPTIONS+=" -DCMINPACK_INCLUDE_DIR=${CMINPACK_ROOT_DIR}/include/cminpack-1"
    CMAKE_OPTIONS+=" -DCMINPACK_LIBRARIES=${CMINPACK_ROOT_DIR}/lib64"
    CMAKE_OPTIONS+=" -DCMINPACK_LIBRARY=${CMINPACK_ROOT_DIR}/lib64/libcminpack_s.a"
    CMAKE_OPTIONS+=" -DHDF5_ROOT=${HDF5_ROOT_DIR}"

    declare -A OTC
    OTC["otagrum"]="0.3"
    OTC["otfftw"]="0.10"
    OTC["otmixmod"]="0.11"
    OTC["otmorris"]="0.9"
    OTC["otpmml"]="1.10"
    OTC["otrobopt"]="0.8"
    OTC["otsubsetinverse"]="1.7"
    OTC["otsvm"]="0.9"

    for k in ${!OTC[@]};
    do         
        cd  $BUILD_DIR
        mkdir ${BUILD_DIR}/$k
        cd ${BUILD_DIR}/$k 
        echo
        echo "*** C O M P O N E N T : $SOURCE_DIR/$k-${OTC[$k]} "
        CMAKE_EXTRA_OPTIONS=
        if [[ $k == "otmixmod" ]]; then
            CMAKE_EXTRA_OPTIONS+=" -DBUILD_DOC=OFF"
            CMAKE_EXTRA_OPTIONS+=" -DSOURCEFILES=$SOURCE_DIR/$k-${OTC[$k]}"
        elif [[ $k == "otsubsetinverse" ]]; then
            CMAKE_EXTRA_OPTIONS+=" -DOPENTURNS_HOME=$PRODUCT_INSTALL"
            CMAKE_EXTRA_OPTIONS+=" -DCMAKE_SKIP_INSTALL_RPATH:BOOL=ON"
            CMAKE_EXTRA_OPTIONS+=" DUSE_SPHINX=OFF"
        fi
        if [[ $k == "otmixmod" ]]; then
            LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${BUILD_DIR}/$k/lib/src
        else
            LD_LIBRARY_PATH=${LD_LIBRARY_PATH_REF}
        fi
        echo
        echo "*** cmake " $CMAKE_OPTIONS ${CMAKE_EXTRA_OPTIONS}  $SOURCE_DIR/$k-${OTC[$k]}
        cmake $CMAKE_OPTIONS ${CMAKE_EXTRA_OPTIONS} $SOURCE_DIR/$k-${OTC[$k]}
        if [ $? -ne 0 ]
        then
            echo "ERROR on cmake"
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
    done
    declare -A OTP
    OTP["otfmi"]="0.7"
    OTP["otpod"]="0.6.6"
    OTP["otwrapy"]="0.9"
    for k in ${!OTP[@]};
    do 
        cd  $BUILD_DIR
        mkdir ${BUILD_DIR}/$k
        cd ${BUILD_DIR}/$k
        ${PYTHONBIN} setup.py  install --prefix==${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages
    done
fi

echo
echo "*** check installation"

if [ -d "${PRODUCT_INSTALL}/lib64" ]
then
    mv ${PRODUCT_INSTALL}/lib64/* ${PRODUCT_INSTALL}/lib
    rmdir ${PRODUCT_INSTALL}/lib64
fi

export PYTHONPATH=${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION}/site-packages:${PYTHONPATH}
export LD_LIBRARY_PATH=${PRODUCT_INSTALL}/lib:${LD_LIBRARY_PATH}
chmod +x ${SOURCE_DIR}/openturns-1.16/python/test/t_features.py
${SOURCE_DIR}/openturns-1.16/python/test/t_features.py
if [ $? -ne 0 ]
then
    echo "ERROR  testing Openturns features...."
    exit 4
fi

echo
echo "########## END"
