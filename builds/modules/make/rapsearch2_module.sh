##########################
# variables
#############
status
	6x - 
	7x - 

software:
	- RAPSearch2

dependencies:
	-

information source:
	- http://omics.informatics.indiana.edu/mg/RAPSearch2/

downloads:
	- https://github.com/zhaoyanswill/RAPSearch2
	- https://github.com/zhaoyanswill/RAPSearch2.git
instructions:
	- 

citation:


Scripts:


##########################
# replace variables
#############
rapsearch     "is the modules name  (lower case only)"
2.22     "is the modules version x.x.x prefered"
https://github.com/zhaoyanswill/RAPSearch2.git     "is the download url, this can vary"
git     "the type of remote repo 'git' or 'tar'"
RAPSearch2 "directory name of post extraction, or clone"

# NOTE must varify the variables.source is properly configured

##########################
# init the build directories
#############
mkdir -p "/packages/6x/build/rapsearch/2.22"
mkdir -p "/packages/7x/build/rapsearch/2.22"

cd "/packages/6x/build/rapsearch/2.22"

##########################
# variables.source
#############

#cat <<EOF > variables.source
#!/bin/bash

OSPREFIX="6x"

source /packages/\$OSPREFIX/build/header.source

module purge

# REQUIRED for file structure
MODULE="rapsearch"
VERSION="2.22"
BUILD_DIR="/packages/\$OSPREFIX/build/\$MODULE/\$VERSION"
INSTALL_DIR="/packages/\$OSPREFIX/\$MODULE/\$VERSION"

# program flow controls:
# BUILD_TYPE="binary | make | virtualenv | hybrid | other"
REMOTE_REPO_TYPE="git"      
  # download.sh

# Getting the source files:
# git, tar
DOWNLOAD_URL="https://github.com/zhaoyanswill/RAPSearch2.git"
GIT_BRANCH=""
GIT_VERSION_TAG=""
TAR_SRC_FILE=""
TAR_HASH_CHECK=""
TAR_SOURCE_FILE="\$BUILD_DIR/\$TAR_SRC_FILE"
  # download.sh

# directory name where the source files will be extracted, cloned, or copied to
SRC_DIR_NAME="RAPSearch2"
SOURCE_DIR="\$BUILD_DIR/\$SRC_DIR_NAME"
  # download.sh, build.sh

# Configure virtualenv 
PYTHON_VERSION=""
PY_VIRTUALENV_DIR="\$INSTALL_DIR/lib.venv.py.d/\$PYTHON_VERSION"
PERL_VERSION=""
PL_VIRTUALENV_DIR="\$INSTALL_DIR/lib.venv.pl.d/\$PERL_VERSION"
  # build.sh

EOF

##########################
# download process
#############

# vi download.sh
#cat <<EOF >> download.sh
#!/bin/bash

source variables.source

# case EXPRESSION in CASE1) COMMAND-LIST;; CASE2) COMMAND-LIST;; ... CASEN) COMMAND-LIST;; esac
download_remote_files(){
  if [ ! -f "\$REMOTE_SOURCE_FILE" ]; then
    echo-yellow "Download remote file....."
    wget -c "\$DOWNLOAD_URL"
    
    # if can check the source tar files do it
    if [ ! -z "\$REMOTE_HASH_CHECK" ]; then
      md5sum -c <<<"\$REMOTE_HASH_CHECK  \$REMOTE_SRC_FILE" 2>&1 | tee "\$BUILD_DIR/_md5sum_check.out"
      pipe_error_check
    fi
  fi
}

case "\$REMOTE_REPO_TYPE" in
  tar)
    # configured for a tar download and extraction
    download_remote_files
    echo-yellow "Extract files from archive....."
    tar -xzf "\$REMOTE_SOURCE_FILE"
  ;;
  zip)
    download_remote_files
    echo-yellow "Extract zipped files....."
    unzip "\$REMOTE_SOURCE_FILE"
  ;;
  git)
    # configured for a git downlad and extraction
    echo-yellow "Clone git remote repo....."
    if [ ! -z "\$GIT_BRANCH" ]; then
      git clone --branch "\$GIT_BRANCH" "\$DOWNLOAD_URL"
    else
      git clone "\$DOWNLOAD_URL"
    fi
    if [ ! -z "\$GIT_VERSION_TAG"]; then
      #
      cd "\$SOURCE_DIR"
      git checkout tags/"\$GIT_VERSION_TAG"
    fi
  ;;
  hg)
    # donfigure with mercurial
    echo-yellow "Clone mercurial remote repo....."
    hg clone "\$DOWNLOAD_URL"
  ;;
  *)
    # we have to know how to get the files...
    echo-red "Must set the value for REMOTE_REPO_TYPE to an accepted value, git or tar"
    exit 1
  ;;
esac

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

if [ -d "\$INSTALL_DIR" ]; then
  rm -rf "\$INSTALL_DIR"
fi

mkdir -p "\$INSTALL_DIR/bin"

# extract or clone source
/bin/bash "\$BUILD_DIR/download.sh"

echo-yellow "Load the module dependencies....."
module load gcc/"\$OSPREFIX"

echo-yellow "Run Provided installer script....."
cd "\$SOURCE_DIR"
# seems the build script provided is bad...
# mkdir "\$SOURCE_DIR/Src/rapsearch"
# mkdir "\$SOURCE_DIR/Src/prerapsearch"

./install 2>&1 | tee "\$BUILD_DIR/_install_script.out"

pipe_error_check

# ./configure \
# 	--prefix="\$INSTALL_DIR" 2>&1 | tee "\$BUILD_DIR/_configure.out"

# pipe_error_check

# echo-yellow "Make build the software....."
# make 2>&1 | tee "\$BUILD_DIR/_make.out"

# pipe_error_check

echo-yellow "Make install the software....."
rsync -av --progress "\$SOURCE_DIR/bin/" "\$INSTALL_DIR/bin"

# echo-yellow "Make clean and other clean up....."
# make clean 2>&1 | tee "\$BUILD_DIR/_make_clean.out"

# pipe_error_check

module purge

check_for_errors

EOF


##########################
# modulefile
#############
files:
	- .modulerc
	- .norun
	- .module_usage-2.22
	- 2.22

module_dir="/packages/sysadmin/environment_modules/modulefiles/rapsearch"

mkdir -p /packages/sysadmin/environment_modules/modulefiles/rapsearch
cd /packages/sysadmin/environment_modules/modulefiles/rapsearch

# .modulerc
cat <<EOF > .modulerc
#%Module1.0
module-version rapsearch/.norun default
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

# .module_usage-2.22
cat <<EOF >> .module_usage-2.22
#%Module1.0

if { [module-info mode load] } {

    puts stderr "##############################################"
    puts stderr "# How to use:"
    puts stderr "##############################################"
    puts stderr ""
    puts stderr "Software Help Menu:"
    puts stderr "  "
    puts stderr ""
    puts stderr ""
    puts stderr ""
    puts stderr ""
    puts stderr ""
    puts stderr ""
    puts stderr ""
    puts stderr "Documentation References:"
    puts stderr "  "
    puts stderr ""
    puts stderr "##############################################"

}

# vim: ft=tcl

EOF





# 2.22
cat <<EOF >> 2.22
#%Module1.0
proc ModulesHelp { } {
  puts stderr "rapsearch 2.22"
}
module-whatis "rapsearch 2.22"

source \$env(MODULESHOME)/modulefiles/.osversion

#source \$env(MODULESHOME)/modulefiles/.5xonly

#source \$env(MODULESHOME)/modulefiles/.6xonly

#source \$env(MODULESHOME)/modulefiles/.7xonly

#source \$env(MODULESHOME)/modulefiles/.gui_warning 

#source \$env(MODULESHOME)/modulefiles/.deprecated_warning

#source \$env(MODULESHOME)/modulefiles/.experimental_warning

#source \$env(MODULESHOME)/modulefiles/.discouraged_warning

#source \$env(MODULESHOME)/modulefiles/.retired_error

source \$env(MODULESHOME)/modulefiles/rapsearch/.module_usage-2.22

conflict rapsearch

# module dependencies
module load other_xx/other_yy
prereq other_xx/other_yy

set topdir /packages/\$osprefix/rapsearch/2.22

prepend-path PATH               \$topdir
#prepend-path PATH               \$topdir/bin

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

setenv A2C2_TAGS ""
setenv A2C2_DESCRIPTION ""
setenv A2C2_URL ""
setenv A2C2_NOTES ""

setenv A2C2_INSTALL_DATE "2017-07-24"
setenv A2C2_INSTALLER "primusdj"
setenv A2C2_BUILDPATH "/packages/6x/build/rapsearch/2.22"

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

cp /packages/6x/build/rapsearch/2.22/*.s* /packages/7x/build/rapsearch/2.22
cp /packages/6x/build/rapsearch/2.22/tartartar /packages/7x/build/rapsearch/2.22
