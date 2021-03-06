#!/bin/bash

echo "##########################################################################"
echo "SOLVERLAB" $VERSION
echo "##########################################################################"


CMAKE_OPTIONS+=" -DPython_ROOT_DIR=${PYTHON_ROOT_DIR}"
CMAKE_OPTIONS+=" -DPython_EXECUTABLE=${PYTHONBIN}"
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_PREFIX=${PRODUCT_INSTALL}"

if [ $VERSION == "V9_6_0" ]
then
    # GUI was ported after 9.6.0
    CMAKE_OPTIONS+=" -DCOREFLOWS_WITH_GUI=OFF"
    # following variables are automatically detected in environment after 9.6.0
    CMAKE_OPTIONS+=" -DPYQT5_ROOT_DIR=${PYQT5_ROOT_DIR}"
    CMAKE_OPTIONS+=" -DMATPLOTLIB_ROOT_DIR=${MATPLOTLIB_ROOT_DIR}"
    CMAKE_OPTIONS+=" -DSWIG_EXECUTABLE=${SWIG_ROOT_DIR}/bin/swig"
    CMAKE_OPTIONS+=" -DDOXYGEN_EXECUTABLE=${DOXYGEN_ROOT_DIR}/bin/doxygen"
    CMAKE_OPTIONS+=" -DCPPUNIT_ROOT_USER=${CPPUNIT_ROOT_DIR}"
    CMAKE_OPTIONS+=" -DHDF5_ROOT=${HDF5_ROOT_DIR}"
    CMAKE_OPTIONS+=" -DMEDFILE_ROOT_DIR=${MEDFILE_ROOT_DIR}"
    CMAKE_OPTIONS+=" -DPARAVIEW_ROOT_DIR=${PARAVIEW_ROOT_DIR}"
    CMAKE_OPTIONS+=" -DPETSC_DIR=${PETSC_ROOT_DIR}"
    CMAKE_OPTIONS+=" -DKERNEL_ROOT_DIR=${KERNEL_ROOT_DIR}"
    CMAKE_OPTIONS+=" -DGUI_ROOT_DIR=${GUI_ROOT_DIR}"
    CMAKE_OPTIONS+=" -DMEDCOUPLING_ROOT_DIR=${MEDCOUPLING_ROOT_DIR}"
else
    CMAKE_OPTIONS+=" -DCOREFLOWS_WITH_GUI=ON"
fi

if [ -n "$SAT_HPC" ]
then
    if [ $VERSION == "V9_6_0" ]
    then
        # following variable is automatically detected in environment after 9.6.0
        CMAKE_OPTIONS="${CMAKE_OPTIONS} -DMPI_HOME=${MPI_ROOT_DIR}"
    fi
    CMAKE_OPTIONS="${CMAKE_OPTIONS} -DCMAKE_CXX_COMPILER:STRING=${MPI_ROOT_DIR}/bin/mpic++"
    CMAKE_OPTIONS="${CMAKE_OPTIONS} -DCMAKE_C_COMPILER:STRING=${MPI_ROOT_DIR}/bin/mpicc"
    if [ -n "$MPI4PY_ROOT_DIR" ]
    then
	CMAKE_OPTIONS="${CMAKE_OPTIONS} -DMPI4PY_ROOT_DIR:PATH=${MPI4PY_ROOT_DIR}"
    else
        echo "WARNING: mpi4py environment variable not detected"
    fi
fi

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
