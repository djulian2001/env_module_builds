##########################
# variables
#############
status
	6x - 
	7x - 

software:
	- xipe

dependencies:
	- python 2.7.12

information source:
	- https://edwards.sdsu.edu/cgi-bin/xipe.cgi

downloads:
	- http://edwards.sdsu.edu/xipe/xipe.py.zip
	- 
instructions:
	- 

citation:


Scripts:


##########################
# replace variables
#############
xipe     "is the modules name  (lower case only)"
2014.12.07     "is the modules version x.x.x prefered"
http://edwards.sdsu.edu/xipe/xipe.py.zip     "is the download url, this can vary"
zip     "the type of remote repo 'git' or 'tar'"
var/www/html/xipe "directory name of post extraction, or clone"

# NOTE must varify the variables.source is properly configured

##########################
# init the build directories
#############
mkdir -p "/packages/6x/build/xipe/2014.12.07"
mkdir -p "/packages/7x/build/xipe/2014.12.07"

cd "/packages/6x/build/xipe/2014.12.07"

##########################
# variables.source
#############

#cat <<EOF > variables.source
#!/bin/bash

OSPREFIX="6x"

source /packages/\$OSPREFIX/build/header.source

module purge

# REQUIRED for file structure
MODULE="xipe"
VERSION="2014.12.07"
BUILD_DIR="/packages/\$OSPREFIX/build/\$MODULE/\$VERSION"
INSTALL_DIR="/packages/\$OSPREFIX/\$MODULE/\$VERSION"

# program flow controls:
# BUILD_TYPE="binary | make | virtualenv | hybrid | other"
REMOTE_REPO_TYPE="zip"      
  # download.sh

# Getting the source files:
# git, tar
DOWNLOAD_URL="http://edwards.sdsu.edu/xipe/xipe.py.zip"
GIT_BRANCH=""
GIT_VERSION_TAG=""

REMOTE_SRC_FILE="xipe.py.zip"
REMOTE_HASH_CHECK=""
REMOTE_SOURCE_FILE="\$BUILD_DIR/\$REMOTE_SRC_FILE"
  # download.sh

# where is the root directory (../source_files) extracted to, cloned, or copied to
SRC_DIR_NAME="var/www/html/xipe"
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
      # headless checkout
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
# build process ( binary )
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

# extract or clone source
/bin/bash "\$BUILD_DIR/download.sh"

echo-yellow "Binary software setup....."
chown root:root -R "\$SOURCE_DIR"
chmod 0551 "\$SOURCE_DIR/xipe.py"
ls -la "\$SOURCE_DIR"
rsync -av --progress "\$SOURCE_DIR/xipe.py" "\$INSTALL_DIR/bin"

EOF



##########################
# modulefile
#############
files:
	- .modulerc
	- .norun
	- .module_usage-2014.12.07
	- 2014.12.07

module_dir="/packages/sysadmin/environment_modules/modulefiles/xipe"

mkdir -p /packages/sysadmin/environment_modules/modulefiles/xipe
cd /packages/sysadmin/environment_modules/modulefiles/xipe

# .modulerc
cat <<EOF > .modulerc
#%Module1.0
module-version xipe/.norun default
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

# .module_usage-2014.12.07
cat <<EOF > .module_usage-2014.12.07
#%Module1.0

if { [module-info mode load] } {

    puts stderr "##############################################"
    puts stderr "# How to use:"
    puts stderr "##############################################"
    puts stderr ""
    puts stderr "Software Help Menu:"
    puts stderr "  xipe.py --help"
    puts stderr ""
    puts stderr "Documentation References:"
    puts stderr "  https://edwards.sdsu.edu/cgi-bin/xipe.cgi"
    puts stderr ""
    puts stderr "##############################################"

}

# vim: ft=tcl

EOF





# 2014.12.07
cat <<EOF >> 2014.12.07
#%Module1.0
proc ModulesHelp { } {
  puts stderr "xipe 2014.12.07"
}
module-whatis "xipe 2014.12.07"

source \$env(MODULESHOME)/modulefiles/.osversion

#source \$env(MODULESHOME)/modulefiles/.5xonly

#source \$env(MODULESHOME)/modulefiles/.6xonly

#source \$env(MODULESHOME)/modulefiles/.7xonly

#source \$env(MODULESHOME)/modulefiles/.gui_warning 

#source \$env(MODULESHOME)/modulefiles/.deprecated_warning

#source \$env(MODULESHOME)/modulefiles/.experimental_warning

#source \$env(MODULESHOME)/modulefiles/.discouraged_warning

#source \$env(MODULESHOME)/modulefiles/.retired_error

source \$env(MODULESHOME)/modulefiles/xipe/.module_usage-2014.12.07

# modulefile variables
set topdir /packages/\$osprefix/xipe/2014.12.07
set py_version 2.7.12

# module dependencies
module load python/\$py_version
prereq python/\$py_version

prepend-path PATH               \$topdir/bin

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

setenv A2C2_TAGS "microbial,metagenomes"
setenv A2C2_DESCRIPTION "Xipe is a statistical comparison program written by Beltran Rodriguez-Muller at San Deigo State University . Xipe provides a non-parametric statistical analysis of the distribution of samples to determine which samples are statistically significantly different.  Xipe is designed to compare two different populations, and identify the differences between those samples. It is not designed, nor is it really appropriate, to use it with more than two samples. For that, you should use a multivariate statistical analysis like PCA, CDA, or something similar."
setenv A2C2_URL "https://edwards.sdsu.edu/cgi-bin/xipe.cgi"
setenv A2C2_NOTES "single py file, models a binary install"

setenv A2C2_INSTALL_DATE "2017-09-13"
setenv A2C2_INSTALLER "primusdj"
setenv A2C2_BUILDPATH "/packages/6x/build/xipe/2014.12.07"

setenv A2C2_MODIFY_DATE "2017-09-13"
setenv A2C2_MODIFIER "primusdj"

setenv A2C2_VERIFY_DATE "2017-09-13"
setenv A2C2_VERIFIER "primusdj"

source \$env(MODULESHOME)/modulefiles/.unset_a2c2

# vim: ft=tcl

EOF

##########################
# make it 7x ready also:
#############

cp /packages/6x/build/xipe/2014.12.07/*.s* /packages/7x/build/xipe/2014.12.07
cp /packages/6x/build/xipe/2014.12.07/tartartar /packages/7x/build/xipe/2014.12.07
