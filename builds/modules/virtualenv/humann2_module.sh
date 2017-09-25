##########################
# variables
#############
status
	6x - 
	7x - 

software:
	- humann2

dependencies:
  - MetaPhlAn2  # a rc module # BUILT
  - Bowtie2 (version >= 2.1) (see NOTE)  # built = module bowtie2/2.2.5
  
  - Diamond (version >= 0.7.3) (see NOTE) 
      # gcc make build, will require a module build
      # there is a binary source of the software already added
  - MinPath (see NOTE) 
      # python package
  - Python (version >= 2.7)
  - Memory (>= 16 GB)
  - Disk space (>= 10 GB [to accommodate comprehensive sequence databases])
  - Operating system (Linux or Mac) 

information source:
	- http://huttenhower.sph.harvard.edu/humann2
  - https://bitbucket.org/biobakery/humann2/overview

downloads:
	- 
	- 
instructions:
	- virtualenv install
  - tests available
  - 


Scripts:


##########################
# replace variables
#############
humann2     "is the modules name  (lower case only)"
2017.09.12     "is the modules version x.x.x prefered"
https://bitbucket.org/biobakery/humann2     "is the download url, this can vary"
hg     "the type of remote repo 'git' or 'tar'"
srcsrcsrc "directory name of post extraction, or clone"

# NOTE must varify the variables.source is properly configured

##########################
# init the build directories
#############
mkdir -p "/packages/6x/build/humann2/2017.09.12"
mkdir -p "/packages/7x/build/humann2/2017.09.12"

cd "/packages/6x/build/humann2/2017.09.12"

##########################
# variables.source
#############

#cat <<EOF > variables.source
#!/bin/bash

OSPREFIX="6x"

source /packages/\$OSPREFIX/build/header.source

module purge

# REQUIRED for file structure
MODULE="humann2"
VERSION="2017.09.12"
BUILD_DIR="/packages/\$OSPREFIX/build/\$MODULE/\$VERSION"
INSTALL_DIR="/packages/\$OSPREFIX/\$MODULE/\$VERSION"

# program flow controls:
# BUILD_TYPE="binary | make | virtualenv | hybrid | other"
REMOTE_REPO_TYPE="hg"      
  # download.sh

# Getting the source files:
# git, tar
DOWNLOAD_URL="https://bitbucket.org/biobakery/humann2"
GIT_BRANCH=""
GIT_VERSION_TAG=""
TAR_SRC_FILE=""
TAR_HASH_CHECK=""
TAR_SOURCE_FILE="\$BUILD_DIR/\$TAR_SRC_FILE"
  # download.sh

# directory name where the source files will be extracted, cloned, or copied to
SRC_DIR_NAME="srcsrcsrc"
SOURCE_DIR="\$BUILD_DIR/\$SRC_DIR_NAME"
  # download.sh, build.sh

# Configure virtualenv 
PYTHON_VERSION="2.7.12"
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

case "\$REMOTE_REPO_TYPE" in
  tar)
    # configured for a tar download and extraction
    if [ ! -f "\$TAR_SOURCE_FILE" ]; then
      echo-yellow "Download archive file....."
      wget -c "\$DOWNLOAD_URL"
      
      # if can check the source tar files do it
      if [ ! -z "\$TAR_HASH_CHECK" ]; then
        md5sum -c <<<"\$TAR_HASH_CHECK  \$TAR_SRC_FILE" 2>&1 | tee "\$BUILD_DIR/_md5sum_check.out"
        pipe_error_check
      fi
    fi
    
    echo-yellow "Extract files from archive....."
    tar -xzf "\$TAR_SOURCE_FILE"
  
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

#cat <<EOF >> build.sh
#!/bin/bash

source variables.source

echo-yellow "Setting up the RC file structure....."
if [ -d "\$SOURCE_DIR" ]; then
  rm -rf "\$SOURCE_DIR"
fi

if [ ! -d "\$INSTALL_DIR" ]; then
  mkdir -p "\$INSTALL_DIR"
fi

# extract or clone source
/bin/bash "\$BUILD_DIR/download.sh"

echo-yellow "Load the module dependencies....."
module load gcc/"\$OSPREFIX"

echo-yellow "Configure the software....."
cd "\$SOURCE_DIR"
./configure \
  --prefix="\$INSTALL_DIR" 2>&1 | tee "\$BUILD_DIR/_configure.out"

pipe_error_check

echo-yellow "Make test or check the configuration....."
make check 2>&1 | tee "\$BUILD_DIR/_make_check.out"
# this hung on a ./ftp_list test, not sure why

pipe_error_check

echo-yellow "Make build the software....."
make 2>&1 | tee "\$BUILD_DIR/_make.out"

pipe_error_check

echo-yellow "Make install the software....."
make install 2>&1 | tee "\$BUILD_DIR/_make_install.out"

pipe_error_check

echo-yellow "Optionally, Make install check the software....."
make installcheck 2>&1 | tee "\$BUILD_DIR/_make_installcheck.out"

pipe_error_check

echo-yellow "Make clean and other clean up....."
make clean 2>&1 | tee "\$BUILD_DIR/_make_clean.out"

pipe_error_check

module purge

EOF

##########################
# build process ( binary )
#############

#cat <<EOF >> build.sh
#!/bin/bash

source variables.source

echo-yellow "File structure tasks and setup....."
if [ -d "\$SOURCE_DIR" ]; then
  rm -rf "\$SOURCE_DIR"
fi

if [ -d "\$INSTALL_DIR" ]; then
  rm -rf "\$INSTALL_DIR"
fi

mkdir -p "\$INSTALL_DIR/bin"
# an example of adding a man 1 page
# mkdir -p "\$INSTALL_DIR/man/man1"

# extract or clone source
/bin/bash "\$BUILD_DIR/download.sh"

echo-yellow "Binary software setup....."
chown root:root -R "\$SOURCE_DIR"

# copy binary files
# could add a loop here
/bin/cp "\$SOURCE_DIR/\$BINARY_FILE" "\$INSTALL_DIR/bin"

# Example of setting up a man page.
# echo-yellow "Manual pages setup....."
# cp "\$SOURCE_DIR/\$BINARY_FILE.1" "\$INSTALL_DIR/man/man1"
# gzip "\$INSTALL_DIR/man/man1/\$BINARY_FILE.1"

# echo-yellow "Other files setup....."
# # could be a loop...
# cp "\$SOURCE_DIR/\$OTHER_FILE" "\$INSTALL_DIR"

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

mkdir -p "\$INSTALL_DIR/bin"
# py or pl module dependencies
if [ ! -z "\$PYTHON_VERSION" ]; then
  mkdir -p "\$PY_VIRTUALENV_DIR"
fi
if [ ! -z "\$PERL_VERSION" ]; then
  mkdir -p "\$PY_VIRTUALENV_DIR"
fi

# extract or clone source
/bin/bash "\$BUILD_DIR/download.sh"

echo-yellow "Load module dependencies....."
# module load python/"\$PYTHON_VERSION"
# module load perl/"\$PERL_VERSION"

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
  - .module_usage-2017.09.12
  - 2017.09.12

module_dir="/packages/sysadmin/environment_modules/modulefiles/humann2"

mkdir -p /packages/sysadmin/environment_modules/modulefiles/humann2
cd /packages/sysadmin/environment_modules/modulefiles/humann2

# .modulerc
cat <<EOF > .modulerc
#%Module1.0
module-version humann2/.norun default
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

# .module_usage-2017.09.12
cat <<EOF >> .module_usage-2017.09.12
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





# 2017.09.12
cat <<EOF >> 2017.09.12
#%Module1.0
proc ModulesHelp { } {
  puts stderr "humann2 2017.09.12"
}
module-whatis "humann2 2017.09.12"

source \$env(MODULESHOME)/modulefiles/.osversion

#source \$env(MODULESHOME)/modulefiles/.5xonly

#source \$env(MODULESHOME)/modulefiles/.6xonly

#source \$env(MODULESHOME)/modulefiles/.7xonly

#source \$env(MODULESHOME)/modulefiles/.gui_warning 

#source \$env(MODULESHOME)/modulefiles/.deprecated_warning

#source \$env(MODULESHOME)/modulefiles/.experimental_warning

#source \$env(MODULESHOME)/modulefiles/.discouraged_warning

#source \$env(MODULESHOME)/modulefiles/.retired_error

source \$env(MODULESHOME)/modulefiles/humann2/.module_usage-2017.09.12

conflict humann2

# module dependencies
module load other_xx/other_yy
prereq other_xx/other_yy

set topdir /packages/\$osprefix/humann2/2017.09.12

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
setenv A2C2_BUILDPATH "/packages/6x/build/humann2/2017.09.12"

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

cp /packages/6x/build/humann2/2017.09.12/*.s* /packages/7x/build/humann2/2017.09.12
cp /packages/6x/build/humann2/2017.09.12/tartartar /packages/7x/build/humann2/2017.09.12
