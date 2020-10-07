#!/bin/bash

echo "##########################################################################"
echo "SOLVERLAB" $VERSION
echo "##########################################################################"


CMAKE_OPTIONS=$CMAKE_OPTIONS" -DPYTHON_ROOT_DIR=${PYTHON_ROOT_DIR}"
CMAKE_OPTIONS=$CMAKE_OPTIONS" -DPYQT5_ROOT_DIR=${PYQT5_ROOT_DIR}"
CMAKE_OPTIONS=$CMAKE_OPTIONS" -DMATPLOTLIB_ROOT_DIR=${MATPLOTLIB_ROOT_DIR}"
CMAKE_OPTIONS=$CMAKE_OPTIONS" -DSWIG_EXECUTABLE=${SWIG_ROOT_DIR}/bin/swig"
CMAKE_OPTIONS=$CMAKE_OPTIONS" -DDOXYGEN_EXECUTABLE=${DOXYGEN_ROOT_DIR}/bin/doxygen"
CMAKE_OPTIONS=$CMAKE_OPTIONS" -DCPPUNIT_ROOT_USER=${CPPUNIT_ROOT_DIR}"
CMAKE_OPTIONS=$CMAKE_OPTIONS" -DHDF5_ROOT=${HDF5_ROOT_DIR}"
CMAKE_OPTIONS=$CMAKE_OPTIONS" -DMEDFILE_ROOT_DIR=${MEDFILE_ROOT_DIR}"
CMAKE_OPTIONS=$CMAKE_OPTIONS" -DPARAVIEW_ROOT_DIR=${PARAVIEW_ROOT_DIR}"
CMAKE_OPTIONS=$CMAKE_OPTIONS" -DPETSC_DIR=${PETSC_ROOT_DIR}"
CMAKE_OPTIONS=$CMAKE_OPTIONS" -DMEDCOUPLING_ROOT_DIR=${MEDCOUPLING_ROOT_DIR}"
CMAKE_OPTIONS=$CMAKE_OPTIONS" -DCMAKE_INSTALL_PREFIX=${PRODUCT_INSTALL}"

echo
echo "*** cmake "$CMAKE_OPTIONS
cmake $CMAKE_OPTIONS $SOURCE_DIR
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
echo "*** make doc install"
make docCDMATH docCoreFlows install
if [ $? -ne 0 ]
then
    echo "ERROR on make install"
    exit 3
fi

echo
echo "########## END"

