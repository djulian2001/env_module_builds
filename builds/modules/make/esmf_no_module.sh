TODO:
# install esmf 6x
# install esmf 7x
add modulefile for esmf
setenv ESMF_OS="Linux"
setenv ESMF_DIR="$topdir"
setenv ESMF_COMM="openmpi"
setenv ESMF_COMPILER="gfortran"
setenv ESMF_INSTALL_PREFIX="$topdir"
setenv ESMF_ABI=64



-DJAS_ENABLE_OPENGL=true
https://github.com/mdadams/jasper.git
git clone -b "$git_branch" -"$git_repo"

git checkout tags/"$git_tag" -b "$git_branch"


install jasper 6x
install jasper 7x
add modulefile for jasper

install grib-api 6x 
install grib-api 7x 
add modulefile for grib-api
https://software.ecmwf.int/wiki/download/attachments/3473437/grib_api-1.21.0-Source.tar.gz?api=v2


###############################################################################
# jasper build scripts:
###############################################################################
# 
mkdir -p /packages/7x/build/esmf/6.3.0rp1


###############################################################################
# jasper build scripts:
###############################################################################
# download.sh
#!/bin/bash

wget -c http://www.ece.uvic.ca/~frodo/jasper/software/jasper-2.0.12.tar.gz


###############################################################################
# 
# variables.source
#!/bin/bash

set -e

SOURCE_DIR=
BUILD_DIR=
package_dir=
OPTIONS=""

# make the makefiles:
cmake -G "Unix Makefiles" -H$source_dir -B$build_dir \
      -DCMAKE_INSTALL_PREFIX=$package_dir $options


###############################################################################
# clean.sh
if [ -d "$source_dir" ]; then
    /bin/rm -r $source_dir
fi

tar xzf "$archive_file"

cd "$source_dir"

echo "clean the enviornment"
make clean 2>&1 | tee "$build_path"/_clean.out
module purge

pipe_error_check





#!/bin/bash

export ESMF_OS="Linux"
export ESMF_DIR="$source_files"
export ESMF_COMM="openmpi"
export ESMF_COMPILER="intelgcc"
export ESMF_CXX="gcc"
export ESMF_F90="gfortran"



# pipe the outputs to the _stage_file
_clean

_build

_test


_install
make install 2>&1 | tee ../$PACKAGE\_make_install_out

if [[ condition ]]; then
	#statements

--------------------------------------------------------------- /usr/share/Modules/modulefiles ----------------------------------------------------------------
os_base=gcc/4.4.7
gcc/4.7.4 
gcc/4.8.2 
gcc/4.9.2 
gcc/4.9.3 
gcc/5.1.0 
gcc/5.2.0 
gcc/5.3.0 
gcc/6.1.0 
gcc/6.3.0 
gcc/7.1.0


--------------------------------------------------------------- /usr/share/Modules/modulefiles ----------------------------------------------------------------

openbugs/3.2.3             
openmpi/1.10.3-gnu-4.9.3   
openmpi/1.8.4-gnu-4.9.2    
openmpi/1.8.5-gnu-4.9.2    
openmpi/1.8.5-pgi-15.3

opencv/2.4.9               
openmpi/1.4.5-intel-2011   
openmpi/1.8.4-gnu-stock    
openmpi/1.8.5-gnu-stock    
openmpi/1.8.5-pgi-15.4

openmpi/1.10.2-gnu-4.9.3   
openmpi/1.6.5-gnu-stock    
openmpi/1.8.4-intel-2015.2 
openmpi/1.8.5-intel-2011   
openmpi/1.8.7-gnu-4.9.2

openmpi/1.10.2-gnu-stock   
openmpi/1.8.2-intel-2015.0 
openmpi/1.8.4-pgi-15.3     
openmpi/1.8.5-intel-2015.3


