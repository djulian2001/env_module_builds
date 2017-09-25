##########################
# variables
#############
status
	6x - complete (pip via virtualenv) 
	7x - complete (pip via virtualenv)

software:
	- pynast y

dependencies:
	- module load uclust/1.2.22

information source:
	- http://biocore.github.io/pynast/

downloads:
	hard way:
  - git://github.com/qiime/pynast.git
  - https://github.com/biocore/pynast.git
	easy way:
  - pip install numpy, pynast
  - going to use virtualenv with python 2.7.12

instructions:
	- 


Scripts:


##########################
# replace variables
#############
pynast "is the modules name  (lower case only)"
1.2.2 "is the modules version x.x.x prefered"
https://github.com/biocore/pynast.git "is the download url, this can vary"
tartartar "if a tar file, the name of that tar"

##########################
# init the build directories
#############
mkdir -p "/packages/6x/build/pynast/1.2.2"
mkdir -p "/packages/7x/build/pynast/1.2.2"

cd "/packages/6x/build/pynast/1.2.2"

##########################
# variables.source
#############

# cat <<EOF > variables.source
#!/bin/bash

OSPREFIX="6x"

source /packages/\$OSPREFIX/build/header.source

module purge

echo-yellow "INSTALL setup for pip with virtualenv..."
# DOWNLOAD_URL="https://github.com/biocore/pynast.git"
# GIT_VERSION_TAG="1.2.2"

MODULE="pynast"
VERSION="1.2.2"
# SRC_FILE="tartartar"
SRC_DIR="pynast"
PYTHON_VERSION="2.7.12"

BUILD_DIR="/packages/\$OSPREFIX/build/\$MODULE/\$VERSION"
# SOURCE_FILE="\$BUILD_DIR/\$SRC_FILE"
SOURCE_DIR="\$BUILD_DIR/\$SRC_DIR"
INSTALL_DIR="/packages/\$OSPREFIX/\$MODULE/\$VERSION"
VIRTUALENV_DIR="\$INSTALL_DIR/lib.venv.py.d/\$PYTHON_VERSION"

EOF

##########################
# download process
#############

# vi download.sh
#cat <<EOF >> download.sh
#!/bin/bash

source variables.source

echo-yellow "INSTALL with pip, virtualenv...."

# echo-yellow "INSTALL with git...."
# git clone "\$DOWNLOAD_URL"
# git checkout tags/"\$GIT_VERSION_TAG"

EOF

##########################
# build process ( virtualenv )
#############

#cat <<EOF > build.sh
#!/bin/bash

source variables.source

echo-yellow "File structure tasks and setup....."
if [ -d "\$SOURCE_DIR" ]; then
  rm -rf "\$SOURCE_DIR"
fi

if [ -d "\$INSTALL_DIR" ]; then
  rm -rf "\$INSTALL_DIR"
fi

mkdir -p "\$VIRTUALENV_DIR"

echo-yellow "Load module dependencies....."
module load python/"\$PYTHON_VERSION"
module load uclust/1.2.22

echo-yellow "Modulefile requirements (before)....."
env > "\$BUILD_DIR/_env_before.out"

echo-yellow "Install build dependencies....."
pip install virtualenv 2>&1 | tee "\$BUILD_DIR/_build_dep_virtualenv.out"
pipe_error_check

echo-yellow "Setup and activate virtualenv....."
virtualenv "\$VIRTUALENV_DIR/venv"
source "\$VIRTUALENV_DIR/venv/bin/activate"

echo-yellow "Modulefile requirements (after and diff)....."
env > "\$BUILD_DIR/_env_after.out"
colordiff "\$BUILD_DIR/_env_before.out" "\$BUILD_DIR/_env_after.out" > "\$BUILD_DIR/_env_diff.out"

echo-yellow "With pip software setup....."
# documentation states these need to be run in seperate commands:
pip install numpy 2>&1 | tee "\$BUILD_DIR/_pip_dep_numpy.out"
pipe_error_check

pip install pynast 2>&1 | tee "\$BUILD_DIR/_pip_dep_pynast.out"
pipe_error_check

echo-yellow "Build clean up....."
deactivate
module purge

EOF

##########################
# modulefile
#############
files:
	- .modulerc
	- .norun
	- .module_usage-1.2.2
	- 1.2.2

module_dir="/packages/sysadmin/environment_modules/modulefiles/pynast"

mkdir -p /packages/sysadmin/environment_modules/modulefiles/pynast
cd /packages/sysadmin/environment_modules/modulefiles/pynast

# .modulerc
cat <<EOF > .modulerc
#%Module1.0
module-version pynast/.norun default
EOF

# .norun
cat <<EOF >> .norun
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

# .module_usage-1.2.2
cat <<EOF >> .module_usage-1.2.2
#%Module1.0

if { [module-info mode load] } {

    puts stderr "##############################################"
    puts stderr "# How to use:"
    puts stderr "##############################################"
    puts stderr ""
    puts stderr "Software Help Menu:"
    puts stderr "  pynast -h"
    puts stderr ""
    puts stderr ""
    puts stderr "Documentation References:"
    puts stderr "  http://biocore.github.io/pynast/index.html"
    puts stderr ""
    puts stderr "##############################################"

}

# vim: ft=tcl

EOF

# env diff:
< PATH=/packages/6x/uclust/1.2.22/bin:/packages/6x/python/2.7.12/bin:/packages/6x/curl/7.49.1/bin:/usr/lib64/qt-3.3/bin:/packages/scripts:/usr/kerberos/sbin:/usr/kerberos/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/opt/ibutils/bin:/packages/sysadmin/saguaro/scripts/:/opt/dell/toolkit/bin:/packages/6x/perl5lib/bin:/opt/puppetlabs/bin:/opt/dell/srvadmin/bin:/opt/dell/srvadmin/sbin:/packages/6x/build/mocat2/2.0/mocat2-git/dev/public/src:/root/bin:/packages/6x/build/mocat2/2.0/mocat2-git/dev/public/src
---
> VIRTUAL_ENV=/packages/6x/pynast/1.2.2/lib.venv.py.d/2.7.12/venv
> PATH=/packages/6x/pynast/1.2.2/lib.venv.py.d/2.7.12/venv/bin:/packages/6x/uclust/1.2.22/bin:/packages/6x/python/2.7.12/bin:/packages/6x/curl/7.49.1/bin:/usr/lib64/qt-3.3/bin:/packages/scripts:/usr/kerberos/sbin:/usr/kerberos/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/opt/ibutils/bin:/packages/sysadmin/saguaro/scripts/:/opt/dell/toolkit/bin:/packages/6x/perl5lib/bin:/opt/puppetlabs/bin:/opt/dell/srvadmin/bin:/opt/dell/srvadmin/sbin:/packages/6x/build/mocat2/2.0/mocat2-git/dev/public/src:/root/bin:/packages/6x/build/mocat2/2.0/mocat2-git/dev/public/src



# 1.2.2
cat <<EOF > 1.2.2
#%Module1.0
proc ModulesHelp { } {
  puts stderr "pynast 1.2.2"
}
module-whatis "pynast 1.2.2"

source \$env(MODULESHOME)/modulefiles/.osversion

#source \$env(MODULESHOME)/modulefiles/.5xonly

#source \$env(MODULESHOME)/modulefiles/.6xonly

#source \$env(MODULESHOME)/modulefiles/.7xonly

#source \$env(MODULESHOME)/modulefiles/.gui_warning 

#source \$env(MODULESHOME)/modulefiles/.deprecated_warning

#source \$env(MODULESHOME)/modulefiles/.experimental_warning

#source \$env(MODULESHOME)/modulefiles/.discouraged_warning

#source \$env(MODULESHOME)/modulefiles/.retired_error

source \$env(MODULESHOME)/modulefiles/pynast/.module_usage-1.2.2

conflict pynast

set topdir /packages/\$osprefix/pynast/1.2.2
set py_version 2.7.12

# module dependencies
module load python/\$py_version
prereq python/\$py_version

module load uclust/1.2.22
prereq uclust/1.2.22

# env variables
prepend-path PATH            \$topdir/lib.venv.py.d/\$py_version/venv/bin
prepend-path VIRTUAL_ENV     \$topdir/lib.venv.py.d/\$py_version/venv/bin

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

setenv A2C2_TAGS "sequence,aligner,rRNA"
setenv A2C2_DESCRIPTION "PyNAST is a reimplementation of the NAST sequence aligner, which has become a popular tool for adding new 16s rRNA sequences to existing 16s rRNA alignments."
setenv A2C2_URL "http://biocore.github.io/pynast/"
setenv A2C2_NOTES "python virtualenv install"

setenv A2C2_INSTALL_DATE "2017-07-24"
setenv A2C2_INSTALLER "primusdj"
setenv A2C2_BUILDPATH "/packages/6x/build/pynast/1.2.2"

setenv A2C2_MODIFY_DATE "2017-07-28"
setenv A2C2_MODIFIER "primusdj"

setenv A2C2_VERIFY_DATE "2017-07-28"
setenv A2C2_VERIFIER "primusdj"

source \$env(MODULESHOME)/modulefiles/.unset_a2c2

# vim: ft=tcl


EOF

##########################
# make it 7x ready also:
#############

cp /packages/6x/build/pynast/1.2.2/*.s* /packages/7x/build/pynast/1.2.2
cp "/packages/6x/build/pynast/1.2.2/tartartar" "/packages/7x/build/pynast/1.2.2"
