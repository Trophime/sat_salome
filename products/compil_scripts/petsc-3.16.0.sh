#!/bin/bash

echo "##########################################################################"
echo "Petsc" $VERSION
echo "##########################################################################"

cp -r $SOURCE_DIR/* .

CONFIGURE_FLAGS=
CONFIGURE_FLAGS+=" --download-f2cblaslapack"
CONFIGURE_FLAGS+=" --download-slepc"

if [ -n "${HDF5_ROOT_DIR}" ]
then
    if [ "${HDF5_ROOT_DIR}" != "/usr" ]
    then
       CONFIGURE_FLAGS+=" --with-hdf5-include=${HDF5_INCLUDE_DIRS} --with-hdf5-lib=${HDF5_LIBRARIES}"
    fi
fi

# CONFIGURE_FLAGS+=" --download-metis"
CONFIGURE_FLAGS+=" --with-debugging=0" # by default Petsc is build in debug mode
CONFIGURE_FLAGS+=" --with-petsc4py=yes"
CONFIGURE_FLAGS+=" --download-slepc-configure-arguments=--with-slepc4py=yes "
echo
if [ -n "${MPI_ROOT_DIR}" ]
then
  echo "*** configure with mpi"
  CONFIGURE_FLAGS+=" --download-hypre"
  CONFIGURE_FLAGS+=" --download-parms"
  CONFIGURE_FLAGS+=" --download-parmetis"
  CONFIGURE_FLAGS+=" --download-ptscotch"
  # if [ -n "${MPI4PY_ROOT_DIR}" ]
  # then
  #     echo "*** mpi4py external dependency detected..."
  #     CONFIGURE_FLAGS+=" --with-mpi4py-dir=${MPI4PY_ROOT_DIR}"
  # else
  #     CONFIGURE_FLAGS+=" --download-mpi4py"
  # fi
  ./configure --prefix=${PRODUCT_INSTALL} --with-mpi-dir=${MPI_ROOT_DIR} ${CONFIGURE_FLAGS}
else
  echo "*** configure without mpi"
  ./configure --prefix=${PRODUCT_INSTALL} --with-mpi=0 ${CONFIGURE_FLAGS}
fi

if [ $? -ne 0 ]
then
    echo "ERROR on configure"
    exit 1
fi

MAKE_OPTIONS="PETSC_DIR=${BUILD_DIR}"

echo
echo "*** make" $MAKE_OPTIONS
make $MAKE_OPTIONS
if [ $? -ne 0 ]
then
    echo "ERROR on make"
    exit 2
fi

# CentOS 6 automatically set PETSC_ARCH to arch-linux2-c-debug : remove arch specification
# MAKE_OPTIONS=$MAKE_OPTIONS" PETSC_ARCH=arch-linux-c-debug"

echo
echo "*** make install"
make $MAKE_OPTIONS install
if [ $? -ne 0 ]
then
    echo "ERROR on make install"
    exit 3
fi

echo
echo "########## END"

