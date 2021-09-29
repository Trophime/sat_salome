#!/bin/bash                                                                                                                                                                              

echo "##########################################################################"
echo "openturns" $VERSION
echo "##########################################################################"

COPY_OPENTURNS=0
# we don't install in python directory -> modify environment as described in INSTALL file
mkdir -p $PRODUCT_INSTALL/lib/python${PYTHON_VERSION:0:3}/site-packages
export PATH=$(pwd)/bin:$PATH
export PYTHONPATH=$(pwd):$PYTHONPATH
export PYTHONPATH=${PRODUCT_INSTALL}/lib/python${PYTHON_VERSION:0:3}/site-packages:$PYTHONPATH

if [ -n "$MPI_ROOT_DIR" ]
then
    echo "WARNING: setting CC and CXX environment variables and target MPI wrapper"
    export CC=${MPI_ROOT_DIR}/bin/mpicc
    export CXX=${MPI_ROOT_DIR}/bin/mpicxx
fi

CMAKE_OPTIONS=""
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_PREFIX:STRING=${PRODUCT_INSTALL}"
CMAKE_OPTIONS+=" -DCMAKE_BUILD_TYPE:STRING=Release"
CMAKE_OPTIONS+=" -DPYTHON_EXECUTABLE=${PYTHONBIN}"
CMAKE_OPTIONS+=" -DSWIG_EXECUTABLE=${SWIG_ROOT_DIR}/bin/swig"
CMAKE_OPTIONS+=" -DHDF5_DIR:PATH=${HDF5_ROOT_DIR}/share/cmake/hdf5"
CMAKE_OPTIONS+=" -DHDF5_USE_STATIC_LIBRARIES:BOOL=OFF"
CMAKE_OPTIONS+=" -DHDF5_ROOT:PATH=${HDF5_ROOT_DIR}"
CMAKE_OPTIONS+=" -DHDF5_hdf5_LIBRARY_RELEASE=${HDF5_ROOT_DIR}/lib"
CMAKE_OPTIONS+=" -DHDF5_hdf5_hl_LIBRARY_RELEASE=${HDF5_ROOT_DIR}/lib/libhdf5_hl.so"
CMAKE_OPTIONS+=" -DHDF5_HL_LIBRARY=${HDF5_ROOT_DIR}/lib/libhdf5_hl.so"
CMAKE_OPTIONS+=" -DHDF5_C_INCLUDE_DIR=${HDF5_ROOT_DIR}/include"

# CMINPACK
if [ "${CMINPACK_ROOT_DIR}" != "/usr" ]
then
    CMAKE_OPTIONS+=" -DCMINPACK_ROOT_DIR=${CMINPACK_ROOT_DIR}"
    CMAKE_OPTIONS+=" -DCMINPACK_INCLUDE_DIR=${CMINPACK_ROOT_DIR}/include/cminpack-1"
    CMAKE_OPTIONS+=" -DCMINPACK_LIBRARY=$CMINPACK_ROOT_DIR/lib/libcminpack_s.a"
else
    CMAKE_OPTIONS+=" -DCMINPACK_ROOT_DIR=${CMINPACK_ROOT_DIR}"
    CMAKE_OPTIONS+=" -DCMINPACK_INCLUDE_DIR=${CMINPACK_ROOT_DIR}/include/cminpack-1"
fi
# Blas/Lapack
if [ "${LAPACK_ROOT_DIR}" != "/usr" ]
then
    CMAKE_OPTIONS+=" -DLAPACK_DIR=${LAPACK_ROOT_DIR}/lib/cmake/lapack-3.8.0"
    CMAKE_OPTIONS+=" -DCBLAS_DIR=${LAPACK_ROOT_DIR}/lib/cmake/cblas-3.8.0"
    CMAKE_OPTIONS+=" -DCBLAS_LIBRARIES=$LAPACK_ROOT_DIR/lib/libcblas.so"
fi
### libxml2 settings
if [ -n "$LIBXML2_ROOT_DIR" ]
then
    # with a native libxml2, do not use these options
    if [ "${LIBXML2_ROOT_DIR}" != "/usr" ]
    then
        CMAKE_OPTIONS+=" -DLIBXML2_INCLUDE_DIR:STRING=${LIBXML2_ROOT_DIR}/include/libxml2"
        CMAKE_OPTIONS+=" -DLIBXML2_LIBRARIES:STRING=${LIBXML2_ROOT_DIR}/lib/libxml2.so"
        CMAKE_OPTIONS+=" -DLIBXML2_XMLLINT_EXECUTABLE=${LIBXML2_ROOT_DIR}/bin/xmllint"
    fi
fi

echo
echo "*** cmake" $CMAKE_OPTIONS
mkdir -p $BUILD_DIR/openturns
cd  $BUILD_DIR/openturns
cmake $CMAKE_OPTIONS $SOURCE_DIR/openturns-1.17
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
chmod +x ${SOURCE_DIR}/openturns-1.17/python/test/t_features.py
${SOURCE_DIR}/openturns-1.17/python/test/t_features.py
if [ $? -ne 0 ]
then
    echo "ERROR  testing Openturns features...."
    exit 4
fi

CMAKE_OPTIONS=""
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_PREFIX:STRING=${PRODUCT_INSTALL}"
CMAKE_OPTIONS+=" -DCMAKE_BUILD_TYPE:STRING=Release"
CMAKE_OPTIONS+=" -DPYTHON_EXECUTABLE=${PYTHONBIN}"
CMAKE_OPTIONS+=" -DSWIG_EXECUTABLE=${SWIG_ROOT_DIR}/bin/swig"
CMAKE_OPTIONS+=" -DTBB_ROOT_DIR=${TBB_ROOT_DIR}"
### HDF5 settings
CMAKE_OPTIONS+=" -DHDF5_DIR:PATH=${HDF5_ROOT_DIR}/share/cmake/hdf5"
CMAKE_OPTIONS+=" -DHDF5_USE_STATIC_LIBRARIES:BOOL=OFF"
CMAKE_OPTIONS+=" -DHDF5_ROOT:PATH=${HDF5_ROOT_DIR}"
CMAKE_OPTIONS+=" -DHDF5_hdf5_LIBRARY_RELEASE=${HDF5_ROOT_DIR}/lib"
CMAKE_OPTIONS+=" -DHDF5_hdf5_hl_LIBRARY_RELEASE=${HDF5_ROOT_DIR}/lib/libhdf5_hl.so"
CMAKE_OPTIONS+=" -DHDF5_hdf5_CXX_LIBRARY_RELEASE=${HDF5_ROOT_DIR}/lib/libhdf5_cxx.so"
CMAKE_OPTIONS+=" -DHDF5_HL_LIBRARY=${HDF5_ROOT_DIR}/lib/libhdf5_hl.so"
CMAKE_OPTIONS+=" -DHDF5_C_INCLUDE_DIR=${HDF5_ROOT_DIR}/include"
# CMINPACK
CMAKE_OPTIONS+=" -DCMINPACK_ROOT_DIR=${CMINPACK_ROOT_DIR}"
CMAKE_OPTIONS+=" -DCMINPACK_INCLUDE_DIR=${CMINPACK_ROOT_DIR}/include/cminpack-1"
CMAKE_OPTIONS+=" -DCMINPACK_LIBRARY=$CMINPACK_ROOT_DIR/lib/libcminpack_s.a"
# Blas/Lapack
CMAKE_OPTIONS+=" -DLAPACK_DIR=${LAPACK_ROOT_DIR}/lib/cmake/lapack-3.8.0"
CMAKE_OPTIONS+=" -DCBLAS_DIR=${LAPACK_ROOT_DIR}/lib/cmake/cblas-3.8.0"
CMAKE_OPTIONS+=" -DCBLAS_LIBRARIES=$LAPACK_ROOT_DIR/lib/libcblas.so"
### libxml2 settings
if [ -n "$LIBXML2_ROOT_DIR" ]
then
    # with a native libxml2, do not use these options
    if [ "${LIBXML2_ROOT_DIR}" != "/usr" ]
    then
        CMAKE_OPTIONS+=" -DLIBXML2_INCLUDE_DIR:STRING=${LIBXML2_ROOT_DIR}/include/libxml2"
        CMAKE_OPTIONS+=" -DLIBXML2_LIBRARIES:STRING=${LIBXML2_ROOT_DIR}/lib/libxml2.so"
        CMAKE_OPTIONS+=" -DLIBXML2_XMLLINT_EXECUTABLE=${LIBXML2_ROOT_DIR}/bin/xmllint"
    fi
fi

LD_LIBRARY_PATH_REF=${LD_LIBRARY_PATH}
if [[ -d "$SOURCE_DIR/otfftw-0.11" ]]; then

    declare -A OTC
    OTC["otagrum"]="0.4"
    OTC["otfftw"]="0.11"
    OTC["otmixmod"]="0.12"
    OTC["otmorris"]="0.10"
    OTC["otpmml"]="1.11"
    OTC["otrobopt"]="0.9"
    OTC["otsubsetinverse"]="1.8"
    OTC["otsvm"]="0.10"

    for k in ${!OTC[@]};
    do         
        echo
        echo "*** C O M P O N E N T : $k-${OTC[$k]} "
        if [[ $k == "otagrum" ]]; then
            echo "WARNING: skipping $k.."
            continue
        fi

        cd  $BUILD_DIR
        mkdir ${BUILD_DIR}/$k
        cd ${BUILD_DIR}/$k 
        CMAKE_EXTRA_OPTIONS=
        if [[ $k == "otmixmod" ]]; then
            CMAKE_EXTRA_OPTIONS+=" -DBUILD_DOC=OFF"
            CMAKE_EXTRA_OPTIONS+=" -DSOURCEFILES=$SOURCE_DIR/$k-${OTC[$k]}"
        elif [[ $k == "otsubsetinverse" ]]; then
            CMAKE_EXTRA_OPTIONS+=" -DOPENTURNS_HOME=$PRODUCT_INSTALL"
            CMAKE_EXTRA_OPTIONS+=" -DCMAKE_SKIP_INSTALL_RPATH:BOOL=ON"
            CMAKE_EXTRA_OPTIONS+=" -DUSE_SPHINX=OFF"
        elif  [[ $k == "otfftw" ]]; then
            CMAKE_EXTRA_OPTIONS+=" -DBUILD_DOC=OFF"  # needs extra latex modules on CentOS 7
        elif  [[ $k == "otpmml" ]]; then
            CMAKE_EXTRA_OPTIONS+=" -DBUILD_DOC=OFF"  # needs extra latex modules on CentOS 7
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
    OTP["otfmi"]="0.11"
    #OTP["otpod"]="0.6.7"
    OTP["otwrapy"]="0.10"
    for k in ${!OTP[@]};
    do 
        echo
        echo "*** C O M P O N E N T : $k-${OTP[$k]} "

        cd  $BUILD_DIR
        mkdir ${BUILD_DIR}/$k
        cd ${BUILD_DIR}/$k
        cp -R $SOURCE_DIR/$k-${OTP[$k]}/* .
        #
        $PYTHONBIN setup.py build
        if [ $? -ne 0 ]
        then
            echo "ERROR on ${PYTHONBIN} setup.py  build"
            exit 4
        fi
        #
        $PYTHONBIN setup.py install --prefix=$PRODUCT_INSTALL
        if [ $? -ne 0 ]
        then
            echo "ERROR on ${PYTHONBIN} setup.py  install --prefix=$PRODUCT_INSTALL"
            exit 5
        fi
    done
fi

echo
echo "########## END"
