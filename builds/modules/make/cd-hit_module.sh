##########################
# variables
#############
status
    6x - 
    7x - 

software:
    - cdhit

dependencies:
    -

information source:
    - http://www.bioinformatics.org/cd-hit/  # this is old and busted, a bad source
    
    - http://weizhongli-lab.org/cd-hit/      # appears to be the offical site and leads to:
    -    


downloads:
    - https://github.com/weizhongli/cdhit
    
instructions:
    - 


Scripts:


##########################
# replace variables
#############
cdhit "is the modules name  (lower case only)"
4.6.8 "is the modules version x.x.x prefered"
https://github.com/weizhongli/cdhit.git "is the download url, this can vary"


##########################
# init the build directories
#############
mkdir -p "/packages/6x/build/cdhit/4.6.8"
mkdir -p "/packages/7x/build/cdhit/4.6.8"

cd "/packages/6x/build/cdhit/4.6.8"

##########################
# variables.source
#############

cat <<EOF > variables.source
#!/bin/bash

OSPREFIX="6x"

source /packages/\$OSPREFIX/build/header.source

module purge

DOWNLOAD_URL="https://github.com/weizhongli/cdhit.git"
GIT_VERSION_TAG="V4.6.8"

MODULE="cdhit"
VERSION="4.6.8"
# SRC_FILE="cdhit"
SRC_DIR="cdhit"
HASH_CHECK=""

BUILD_DIR="/packages/\$OSPREFIX/build/\$MODULE/\$VERSION"
# SOURCE_FILE="\$BUILD_DIR/\$SRC_FILE"
SOURCE_DIR="\$BUILD_DIR/\$SRC_DIR"
INSTALL_DIR="/packages/\$OSPREFIX/\$MODULE/\$VERSION"

EOF

##########################
# download process
#############

# vi download.sh
#cat <<EOF > download.sh
#!/bin/bash

source variables.source

git clone "\$DOWNLOAD_URL"
cd "\$SOURCE_DIR"
git checkout tags/"\$GIT_VERSION_TAG"


EOF

##########################
# build process ( make )
#############

#cat <<EOF > build.sh
#!/bin/bash

source variables.source

echo-yellow "Setting up the RC file structure....."
if [ -d "\$SOURCE_DIR" ]; then
    rm -rf "\$SOURCE_DIR"
fi

if [ ! -d "\$INSTALL_DIR" ]; then
    mkdir -p "\$INSTALL_DIR"
fi

mkdir -p "\$INSTALL_DIR/bin"

echo-yellow "Download software (git build)....."
bash "\$BUILD_DIR/download.sh" 2>&1 | tee "\$BUILD_DIR/_download.out"


echo-yellow "Modify the Makefile PREFIX the install....."
# package Makefile doesn't except prefix hardcoded to orig
orig="PREFIX ?= \/usr\/local\/bin"
replace="PREFIX = \/packages\/\$OSPREFIX\/\$MODULE\/\$VERSION\/bin"
sed -i "s/^\$orig/\$replace/" "\$SOURCE_DIR/Makefile"


echo-yellow "Load the module dependencies....."
module load gcc/"\$OSPREFIX"
module load openmpi/2.1.1-gnu-"\$OSPREFIX"

echo-yellow "Make build the software....."
cd "\$SOURCE_DIR"
make -d 2>&1 | tee "\$BUILD_DIR/_make.out"

pipe_error_check

# cd "\$SOURCE_DIR/cd-hit-auxtools"
# echo-yellow "Make build the auxtools software....."
# make -d 2>&1 | tee "\$BUILD_DIR/_make_auxtools.out"

# pipe_error_check

echo-yellow "Make install the software....."
make install 2>&1 | tee "\$BUILD_DIR/_make_install.out"

pipe_error_check

echo-yellow "Make clean and other clean up....."
make clean 2>&1 | tee "\$BUILD_DIR/_make_clean.out"

pipe_error_check

module purge

EOF

##########################
# modulefile
#############
files:
    - .modulerc
    - .norun
    - .module_usage-4.6.8
    - 4.6.8

module_dir="/packages/sysadmin/environment_modules/modulefiles/cdhit"

mkdir -p /packages/sysadmin/environment_modules/modulefiles/cdhit
cd /packages/sysadmin/environment_modules/modulefiles/cdhit

# .modulerc
cat <<EOF > .modulerc
#%Module1.0
module-version cdhit/.norun default
EOF

# .norun
cat <<EOF > .norun
#%Module1.0

# A2C2 FIELDS
setenv A2C2_5X "1"
setenv A2C2_6X "1"
setenv A2C2_7X "1"
setenv A2C2_NOLOGIN "0"
setenv A2C2_DEPRECATED "0"
setenv A2C2_EXPERIMENTAL "0"
setenv A2C2_DISCOURAGED "0"
setenv A2C2_RETIRED "0"
setenv A2C2_VIRTUAL "0"

setenv A2C2_INSTALL_DATE "YYYY-MM-DD" 
setenv A2C2_INSTALLER "<ASURITE>"
setenv A2C2_BUILDPATH "" 

setenv A2C2_MODIFY_DATE "YYYY-MM-DD" 
setenv A2C2_MODIFIER "<ASURITE>"

setenv A2C2_VERIFY_DATE "YYYY-MM-DD" 
setenv A2C2_VERIFIER "<ASURITE>"

source \$env(MODULESHOME)/modulefiles/.unset_a2c2

# vim: ft=tcl

EOF

# .module_usage-4.6.8
cat <<EOF > .module_usage-4.6.8
#%Module1.0

if { [module-info mode load] } {

    puts stderr "##############################################"
    puts stderr "# How to use:"
    puts stderr "##############################################"
    puts stderr ""
    puts stderr "Software Help Menu:"
    puts stderr "  cd-hit -h"
    puts stderr "  cd-hit-est -h"
    puts stderr "  cd-hit-2d -h"
    puts stderr "  cd-hit-est-2d -h"
    puts stderr "  cd-hit-div"
    puts stderr "  cd-hit-454 -h"
    puts stderr ""
    puts stderr "Documentation References:"
    puts stderr "  https://github.com/weizhongli/cdhit/blob/master/doc/cdhit-user-guide.pdf"
    puts stderr ""
    puts stderr "##############################################"

}

# vim: ft=tcl

EOF

# 4.6.8
cat <<EOF >> 4.6.8
#%Module1.0
proc ModulesHelp { } {
  puts stderr "cdhit 4.6.8"
}
module-whatis "cdhit 4.6.8"

source \$env(MODULESHOME)/modulefiles/.osversion

#source \$env(MODULESHOME)/modulefiles/.5xonly

#source \$env(MODULESHOME)/modulefiles/.6xonly

#source \$env(MODULESHOME)/modulefiles/.7xonly

#source \$env(MODULESHOME)/modulefiles/.gui_warning 

#source \$env(MODULESHOME)/modulefiles/.deprecated_warning

#source \$env(MODULESHOME)/modulefiles/.experimental_warning

#source \$env(MODULESHOME)/modulefiles/.discouraged_warning

#source \$env(MODULESHOME)/modulefiles/.retired_error

source \$env(MODULESHOME)/modulefiles/cdhit/.module_usage-4.6.8

# module dependencies
module load gcc/\$osprefix
prereq gcc/\$osprefix

module load openmpi/2.1.1-gnu-\$osprefix
prereq openmpi/2.1.1-gnu-\$osprefix

set topdir /packages/\$osprefix/cdhit/4.6.8

prepend-path PATH               \$topdir/bin

#prepend-path LD_LIBRARY_PATH    \$topdir/lib
#prepend-path LD_LIBRARY_PATH    \$topdir/lib64
#prepend-path MANPATH            \$topdir/share/man
#prepend-path INFOPATH           \$topdir/share/info

# A2C2 FIELDS
setenv A2C2_5X "1"
setenv A2C2_6X "1"
setenv A2C2_7X "1"
setenv A2C2_NOLOGIN "1"
setenv A2C2_DEPRECATED "0"
setenv A2C2_EXPERIMENTAL "0"
setenv A2C2_DISCOURAGED "0"
setenv A2C2_RETIRED "0"
setenv A2C2_VIRTUAL "0"

setenv A2C2_TAGS "clustering,proteins,DNA"
setenv A2C2_DESCRIPTION "CD-HIT is a very widely used program for clustering and comparing protein or nucleotide sequences. CD-HIT was originally developed by Dr. Weizhong Li at Dr. Adam Godzik's Lab at the Burnham Institute (now Sanford-Burnham Medical Research Institute)"
setenv A2C2_URL "http://weizhongli-lab.org/cd-hit/"
setenv A2C2_NOTES "git checkout version for build"

setenv A2C2_INSTALL_DATE "2017-09-06"
setenv A2C2_INSTALLER "primusdj"
setenv A2C2_BUILDPATH "/packages/$osprefix/build/cdhit/4.6.8"

setenv A2C2_MODIFY_DATE "2017-09-06"
setenv A2C2_MODIFIER "primusdj"

setenv A2C2_VERIFY_DATE "2017-09-06"
setenv A2C2_VERIFIER "primusdj"

source \$env(MODULESHOME)/modulefiles/.unset_a2c2

# vim: ft=tcl


EOF

