##########################
# variables
#############
status
	6x - 
	7x - 

software:
  - graphlan.py
	- graphlan_annotate.py

dependencies:
	- python (version >= 2.7)
  - the biopython python library ( version >=1.6)
  - the matplotlib python library (version >=1.1)

information source:
	- https://huttenhower.sph.harvard.edu/graphlan

downloads:
	mercurial repo:
  - https://hg@bitbucket.org/nsegata/graphlan
 
instructions:
	- clone the repo and set the path? ...


Scripts:

2017.09.05
##########################
# replace variables
#############
graphlan "is the modules name  (lower case only)"
2017.09.05 "is the modules version x.x.x prefered"
https://hg@bitbucket.org/nsegata/graphlan "is the download url, this can vary"
tartartar "if a tar file, the name of that tar"

##########################
# init the build directories
#############
mkdir -p "/packages/6x/build/graphlan/2017.09.05"
mkdir -p "/packages/7x/build/graphlan/2017.09.05"

cd "/packages/6x/build/graphlan/2017.09.05"

##########################
# variables.source
#############

#cat <<EOF > variables.source
#!/bin/bash

OSPREFIX="6x"

source /packages/\$OSPREFIX/build/header.source

module purge

DOWNLOAD_URL="https://bitbucket.org/nsegata/graphlan"
#GIT_VERSION_TAG=""

MODULE="graphlan"
VERSION="2017.09.05"
SRC_DIR="graphlan"
PYTHON_VERSION="2.7.12"

BUILD_DIR="/packages/\$OSPREFIX/build/\$MODULE/\$VERSION"
SOURCE_DIR="\$BUILD_DIR/\$SRC_DIR"
INSTALL_DIR="/packages/\$OSPREFIX/\$MODULE/\$VERSION"
VIRTUALENV_DIR="\$INSTALL_DIR/lib.venv.py.d/\$PYTHON_VERSION"

EOF

##########################
# download process
#############

# vi download.sh
cat <<EOF > download.sh
#!/bin/bash

source variables.source

echo-yellow "MERCURIAL repo....."

hg clone "\$DOWNLOAD_URL" 2>&1 | tee "\$BUILD_DIR/_hg_download.out"

EOF

##########################
# build process ( virtualenv )
#############

#cat <<EOF > build.sh
#!/bin/bash

source variables.source

echo-yellow "File structure tasks and setup....."
if [ ! -d "\$SOURCE_DIR" ]; then
  /bin/bash download.sh
fi

if [ -d "\$INSTALL_DIR" ]; then
  rm -rf "\$INSTALL_DIR"
fi

# where the graphlan files will go
mkdir -p "\$INSTALL_DIR/bin"
# where the python dependencies will go
mkdir -p "\$VIRTUALENV_DIR"

echo-yellow "Load module dependencies....."
module load python/"\$PYTHON_VERSION"

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
# seperate commands to track issues:
pip install biopython 2>&1 | tee "\$BUILD_DIR/_pip_dep_biopython.out"
pipe_error_check

pip install matplotlib 2>&1 | tee "\$BUILD_DIR/_pip_dep_matplotlib.out"
pipe_error_check

echo-yellow "Copy files to the bin install directory....."
cp -R \$SOURCE_DIR/* \$INSTALL_DIR/bin

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
	- .module_usage-2017.09.05
	- 2017.09.05

module_dir="/packages/sysadmin/environment_modules/modulefiles/graphlan"

mkdir -p /packages/sysadmin/environment_modules/modulefiles/graphlan
cd /packages/sysadmin/environment_modules/modulefiles/graphlan

# .modulerc
cat <<EOF > .modulerc
#%Module1.0
module-version graphlan/.norun default
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

# .module_usage-2017.09.05
cat <<EOF >> .module_usage-2017.09.05
#%Module1.0

if { [module-info mode load] } {

    puts stderr "##############################################"
    puts stderr "# How to use:"
    puts stderr "##############################################"
    puts stderr ""
    puts stderr "Software Help Menu:"
    puts stderr "  graphlan.py -h"
    puts stderr "  graphlan_annotate.py -h"
    puts stderr ""
    puts stderr ""
    puts stderr "Documentation References:"
    puts stderr "  https://huttenhower.sph.harvard.edu/graphlan"
    puts stderr ""
    puts stderr "##############################################"

}

# vim: ft=tcl

EOF



# env diff
19c19,20
< PATH=/packages/6x/python/2.7.12/bin:/packages/6x/curl/7.49.1/bin:/usr/lib64/qt-3.3/bin:/packages/scripts:/usr/kerberos/sbin:/usr/kerberos/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/opt/ibutils/bin:/packages/sysadmin/saguaro/scripts/:/opt/dell/toolkit/bin:/packages/6x/perl5lib/bin:/opt/puppetlabs/bin:/opt/dell/srvadmin/bin:/opt/dell/srvadmin/sbin:/packages/6x/build/mocat2/2.0/mocat2-git/dev/public/src:/root/bin:/packages/6x/build/mocat2/2.0/mocat2-git/dev/public/src
---
> VIRTUAL_ENV=/packages/6x/graphlan/2017.09.05/lib.venv.py.d/2.7.12/venv
> PATH=/packages/6x/graphlan/2017.09.05/lib.venv.py.d/2.7.12/venv/bin:/packages/6x/python/2.7.12/bin:/packages/6x/curl/7.49.1/bin:/usr/lib64/qt-3.3/bin:/packages/scripts:/usr/kerberos/sbin:/usr/kerberos/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/opt/ibutils/bin:/packages/sysadmin/saguaro/scripts/:/opt/dell/toolkit/bin:/packages/6x/perl5lib/bin:/opt/puppetlabs/bin:/opt/dell/srvadmin/bin:/opt/dell/srvadmin/sbin:/packages/6x/build/mocat2/2.0/mocat2-git/dev/public/src:/root/bin:/packages/6x/build/mocat2/2.0/mocat2-git/dev/public/src
28a30
> PS1=(venv) 




# 2017.09.05
cat <<EOF >> 2017.09.05
#%Module1.0
proc ModulesHelp { } {
  puts stderr "graphlan 2017.09.05"
}
module-whatis "graphlan 2017.09.05"

source \$env(MODULESHOME)/modulefiles/.osversion

#source \$env(MODULESHOME)/modulefiles/.5xonly

#source \$env(MODULESHOME)/modulefiles/.6xonly

#source \$env(MODULESHOME)/modulefiles/.7xonly

#source \$env(MODULESHOME)/modulefiles/.gui_warning 

#source \$env(MODULESHOME)/modulefiles/.deprecated_warning

#source \$env(MODULESHOME)/modulefiles/.experimental_warning

#source \$env(MODULESHOME)/modulefiles/.discouraged_warning

#source \$env(MODULESHOME)/modulefiles/.retired_error

source \$env(MODULESHOME)/modulefiles/graphlan/.module_usage-2017.09.05

# modulefile variables
set topdir /packages/\$osprefix/graphlan/2017.09.05
set py_version 2.7.12

# module dependencies
module load python/\$py_version
prereq python/\$py_version

# set the env
prepend-path PATH               \$topdir/bin
prepend-path PATH               \$topdir/lib.venv.py.d/\$py_version/venv/bin
prepend-path VIRTUAL_ENV        \$topdir/lib.venv.py.d/\$py_version/venv

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

setenv A2C2_TAGS "taxonomic,phylogenetic,graphing"
setenv A2C2_DESCRIPTION "GraPhlAn is a software tool for producing high-quality circular representations of taxonomic and phylogenetic trees. GraPhlAn focuses on concise, integrative, informative, and publication-ready representations of phylogenetically- and taxonomically-driven investigation."
setenv A2C2_URL "https://huttenhower.sph.harvard.edu/graphlan"
setenv A2C2_NOTES "python virtualenv build"

setenv A2C2_INSTALL_DATE "2017-09-08"
setenv A2C2_INSTALLER "primusdj"
setenv A2C2_BUILDPATH "/packages/6x/build/graphlan/2017.09.05"

setenv A2C2_MODIFY_DATE "2017-09-08"
setenv A2C2_MODIFIER "primusdj"

setenv A2C2_VERIFY_DATE "2017-09-08"
setenv A2C2_VERIFIER "primusdj"

source \$env(MODULESHOME)/modulefiles/.unset_a2c2

# vim: ft=tcl


EOF

##########################
# make it 7x ready also:
#############

cp /packages/6x/build/graphlan/2017.09.05/*.s* /packages/7x/build/graphlan/2017.09.05
