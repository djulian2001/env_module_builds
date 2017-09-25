##########################
# variables
#############
status
	6x - 
	7x - 

software:
	- minpath

dependencies:
	- 

information source:
	- http://omics.informatics.indiana.edu/MinPath/readme.txt

downloads:
	- http://omics.informatics.indiana.edu/mg/get.php?justdoit=yes&software=minpath1.2.tar.gz
	- 
instructions:
	- 

citation:


Scripts:


##########################
# replace variables
#############
minpath     "is the modules name  (lower case only)"
1.2.0     "is the modules version x.x.x prefered"
http://omics.informatics.indiana.edu/mg/get.php?justdoit=yes&software=minpath1.2.tar.gz     "is the download url, this can vary"
tar     "the type of remote repo 'git' or 'tar'"
MinPath "directory name of post extraction, or clone"

# NOTE must varify the variables.source is properly configured

##########################
# init the build directories
#############
mkdir -p "/packages/6x/build/minpath/1.2.0"
mkdir -p "/packages/7x/build/minpath/1.2.0"

cd "/packages/6x/build/minpath/1.2.0"

##########################
# variables.source
#############

#cat <<EOF > variables.source
#!/bin/bash

OSPREFIX="6x"

source /packages/\$OSPREFIX/build/header.source

module purge

# REQUIRED for file structure
MODULE="minpath"
VERSION="1.2.0"
BUILD_DIR="/packages/\$OSPREFIX/build/\$MODULE/\$VERSION"
INSTALL_DIR="/packages/\$OSPREFIX/\$MODULE/\$VERSION"

# program flow controls:
# BUILD_TYPE="binary | make | virtualenv | hybrid | other"
REMOTE_REPO_TYPE="tar"      
  # download.sh

# Getting the source files:
# git, tar
DOWNLOAD_URL="http://omics.informatics.indiana.edu/mg/get.php?justdoit=yes&software=minpath1.2.tar.gz"
GIT_BRANCH=""
GIT_VERSION_TAG=""
TAR_SRC_FILE="get.php?justdoit=yes&software=minpath1.2.tar.gz"
TAR_HASH_CHECK=""
TAR_SOURCE_FILE="\$BUILD_DIR/\$TAR_SRC_FILE"
  # download.sh

# directory name where the source files will be extracted, cloned, or copied to
SRC_DIR_NAME="MinPath"
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
mkdir -p "\$INSTALL_DIR/bin/data"
mkdir -p "\$INSTALL_DIR/bin/examples"
mkdir -p "\$INSTALL_DIR/bin/glpk-4.6"

# extract or clone source
/bin/bash "\$BUILD_DIR/download.sh"

# to run minpath have to set MinPath env variable
chown root:root -R "\$SOURCE_DIR"
chmod 0644 "\$INSTALL_DIR/bin/readme"

echo-yellow "DEPENDENCY BUILD REQUIRED....."

echo-yellow "Load the module dependencies....."
module load make/4.1
module load gcc/"\$OSPREFIX"
module load python/"\$PYTHON_VERSION"

gcc --version 2>&1 | tee "\$BUILD_DIR/_gcc.out"

cd "\$SOURCE_DIR/glpk-4.6"

echo-yellow "DEPENDENCY PRE make clean and other clean up....."
make clean 2>&1 | tee "\$BUILD_DIR/_make_clean_pre.out"

pipe_error_check

echo-yellow "DEPENDENCY configure the software....."
./configure \
	--prefix="\$INSTALL_DIR/bin/glpk-4.6" 2>&1 | tee "\$BUILD_DIR/_glpk_configure.out"

pipe_error_check

echo-yellow "DEPENDENCY make test or check the configuration....."
make check 2>&1 | tee "\$BUILD_DIR/_glpk_make_check.out"

pipe_error_check

echo-yellow "DEPENDENCY make build the software....."
make 2>&1 | tee "\$BUILD_DIR/_glpk_make.out"

pipe_error_check

echo-yellow "Install executable file to \$INSTALL_DIR/bin....."
rsync -av --progress "\$SOURCE_DIR/data" "\$INSTALL_DIR/bin"
rsync -av --progress "\$SOURCE_DIR/examples" "\$INSTALL_DIR/bin"
rsync -av --progress "\$SOURCE_DIR/MinPath1.2.py" "\$INSTALL_DIR/bin/MinPath1.2.py"
rsync -av --progress "\$SOURCE_DIR/readme" "\$INSTALL_DIR/bin/readme"

echo-yellow "DEPENDENCY make install the software....."
make install 2>&1 | tee "\$BUILD_DIR/_glpk_make_install.out"

pipe_error_check

echo-yellow "DEPENDENCY make clean and other clean up....."
make clean 2>&1 | tee "\$BUILD_DIR/_make_clean_post.out"

pipe_error_check

module purge

EOF


##########################
# modulefile
#############
files:
	- .modulerc
	- .norun
	- .module_usage-1.2.0
	- 1.2.0

module_dir="/packages/sysadmin/environment_modules/modulefiles/minpath"

mkdir -p /packages/sysadmin/environment_modules/modulefiles/minpath
cd /packages/sysadmin/environment_modules/modulefiles/minpath

# .modulerc
cat <<EOF > .modulerc
#%Module1.0
module-version minpath/.norun default
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

# .module_usage-1.2.0
cat <<EOF >> .module_usage-1.2.0
#%Module1.0

if { [module-info mode load] } {

    puts stderr "##############################################"
    puts stderr "# How to use:"
    puts stderr "##############################################"
    puts stderr "Software Help Menu:"
    puts stderr "  MinPath1.2.py --help"
    puts stderr ""
    puts stderr "Documentation References:"
    puts stderr "  http://omics.informatics.indiana.edu/MinPath/readme.txt"
    puts stderr "##############################################"

}

# vim: ft=tcl

EOF





# 1.2.0
cat <<EOF > 1.2.0
#%Module1.0
proc ModulesHelp { } {
  puts stderr "minpath 1.2.0"
}
module-whatis "minpath 1.2.0"

source \$env(MODULESHOME)/modulefiles/.osversion

#source \$env(MODULESHOME)/modulefiles/.5xonly

#source \$env(MODULESHOME)/modulefiles/.6xonly

#source \$env(MODULESHOME)/modulefiles/.7xonly

#source \$env(MODULESHOME)/modulefiles/.gui_warning 

#source \$env(MODULESHOME)/modulefiles/.deprecated_warning

#source \$env(MODULESHOME)/modulefiles/.experimental_warning

#source \$env(MODULESHOME)/modulefiles/.discouraged_warning

#source \$env(MODULESHOME)/modulefiles/.retired_error

source \$env(MODULESHOME)/modulefiles/minpath/.module_usage-1.2.0

set topdir /packages/\$osprefix/minpath/1.2.0
set py_version 2.7.12

# module dependencies
module load python/\$py_version
prereq python/\$py_version

module load gcc/\$osprefix
prereq gcc/\$osprefix

prepend-path PATH     \$topdir/bin

setenv MinPath        \$topdir/bin

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

setenv A2C2_TAGS "parsimony,metagenomes,genomes"
setenv A2C2_DESCRIPTION "MinPath (Minimal set of Pathways) is a parsimony approach for biological pathway reconstructions using protein family predictions, achieving a more conservative, yet more faithful, estimation of the biological pathways for a query dataset."
setenv A2C2_URL "http://omics.informatics.indiana.edu/MinPath/"
setenv A2C2_NOTES ""

setenv A2C2_INSTALL_DATE "2017-09-12"
setenv A2C2_INSTALLER "primusdj"
setenv A2C2_BUILDPATH "/packages/6x/build/minpath/1.2.0"

setenv A2C2_MODIFY_DATE "2017-09-12"
setenv A2C2_MODIFIER "primusdj"

setenv A2C2_VERIFY_DATE "2017-09-12"
setenv A2C2_VERIFIER "primusdj"

source \$env(MODULESHOME)/modulefiles/.unset_a2c2

# vim: ft=tcl

EOF

##########################
# make it 7x ready also:
#############

cp /packages/6x/build/minpath/1.2.0/*.s* /packages/7x/build/minpath/1.2.0
cp "/packages/6x/build/minpath/1.2.0/get.php?justdoit=yes&software=minpath1.2.tar.gz" /packages/7x/build/minpath/1.2.0
