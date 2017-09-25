##########################
# variables
#############
status
	6x - complete
	7x - complete

software:
	- 

dependencies:
	-

information source:
	- http://huttenhower.sph.harvard.edu/metaphlan2

downloads:
	- hg clone https://bitbucket.org/biobakery/metaphlan2
	- https://bitbucket.org/biobakery/metaphlan2/get/default.tar.gz
instructions:
	- 


Scripts:


##########################
# replace variables
#############
metaphlan     "is the modules name  (lower case only)"
2.6.0     "is the modules version x.x.x prefered"
https://bitbucket.org/biobakery/metaphlan2     "is the download url, this can vary"
hg     "the type of remote repo 'git' or 'tar'"
metaphlan2 "directory name of post extraction, or clone"

# NOTE must varify the variables.source is properly configured

##########################
# init the build directories
#############
mkdir -p "/packages/6x/build/metaphlan/2.6.0"
mkdir -p "/packages/7x/build/metaphlan/2.6.0"

cd "/packages/6x/build/metaphlan/2.6.0"

##########################
# variables.source
#############

#cat <<EOF > variables.source
#!/bin/bash

OSPREFIX="6x"

source /packages/\$OSPREFIX/build/header.source

module purge

# REQUIRED for file structure
MODULE="metaphlan"
VERSION="2.6.0"
BUILD_DIR="/packages/\$OSPREFIX/build/\$MODULE/\$VERSION"
INSTALL_DIR="/packages/\$OSPREFIX/\$MODULE/\$VERSION"

# program flow controls:
# BUILD_TYPE="binary | make | virtualenv | hybrid | other"
REMOTE_REPO_TYPE="hg"
  # download.sh

# Getting the source files:
DOWNLOAD_URL="https://bitbucket.org/biobakery/metaphlan2"
GIT_BRANCH=""
GIT_VERSION_TAG=""
TAR_SRC_FILE=""
TAR_HASH_CHECK=""
TAR_SOURCE_FILE="\$BUILD_DIR/\$TAR_SRC_FILE"
  # download.sh

# directory name where the source files will be extracted, cloned, or copied to
SRC_DIR_NAME="metaphlan2"
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
    echo-yellow "Clone remote repo....."
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
# build process ( virtualenv )
#############

#cat <<EOF > build.sh
#!/bin/bash

source variables.source

echo-yellow "File structure tasks and setup....."
if [ ! -d "\$SOURCE_DIR" ]; then
  # extract or clone source
  /bin/bash "\$BUILD_DIR/download.sh"
  # rm -rf "\$SOURCE_DIR"
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
  mkdir -p "\$PL_VIRTUALENV_DIR"
fi

echo-yellow "Load module dependencies....."
module load bowtie2/2.2.5
module load python/"\$PYTHON_VERSION"
# module load perl/"\$PERL_VERSION"

echo-yellow "Modulefile requirements (before)....."
env > "\$BUILD_DIR/_env_before.out"

echo-yellow "Install build dependencies....."
pip install virtualenv 2>&1 | tee "\$BUILD_DIR/_build_dep_virtualenv.out"
pipe_error_check

echo-yellow "Setup and activate virtualenv....."
virtualenv "\$PY_VIRTUALENV_DIR/venv"
source "\$PY_VIRTUALENV_DIR/venv/bin/activate"

echo-yellow "Modulefile requirements (after and diff)....."
env > "\$BUILD_DIR/_env_after.out"
colordiff "\$BUILD_DIR/_env_before.out" "\$BUILD_DIR/_env_after.out" > "\$BUILD_DIR/_env_diff.out"

echo-yellow "With pip software setup....."
# seperate commands to track issues:
pip install argparse 2>&1 | tee "\$BUILD_DIR/_pip_dep_argparse.out"
pipe_error_check

# already installed
# pip install tempfile 2>&1 | tee "\$BUILD_DIR/_pip_dep_tempfile.out"
# pipe_error_check

pip install numpy 2>&1 | tee "\$BUILD_DIR/_pip_dep_numpy.out"
pipe_error_check

pip install matplotlib 2>&1 | tee "\$BUILD_DIR/_pip_dep_matplotlib.out"
pipe_error_check

pip install scipy 2>&1 | tee "\$BUILD_DIR/_pip_dep_scipy.out"
pipe_error_check

# installed with matplotlib
# pip install pylab 2>&1 | tee "\$BUILD_DIR/_pip_dep_pylab.out"
# pipe_error_check

pip install "biom-format" 2>&1 | tee "\$BUILD_DIR/_pip_dep_biom-format.out"
pipe_error_check

pip install h5py 2>&1 | tee "\$BUILD_DIR/_pip_dep_h5py.out"
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
	- .module_usage-2.6.0
	- 2.6.0

module_dir="/packages/sysadmin/environment_modules/modulefiles/metaphlan"

mkdir -p /packages/sysadmin/environment_modules/modulefiles/metaphlan
cd /packages/sysadmin/environment_modules/modulefiles/metaphlan

# .modulerc
cat <<EOF > .modulerc
#%Module1.0
module-version metaphlan/.norun default
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

# .module_usage-2.6.0
cat <<EOF > .module_usage-2.6.0
#%Module1.0

if { [module-info mode load] } {

    puts stderr "##############################################"
    puts stderr "# How to use:"
    puts stderr "##############################################"
    puts stderr ""
    puts stderr "Software help menu:"
    puts stderr "  metaphlan2.py --help"
    puts stderr ""
    puts stderr "Installed Utilities:"
    puts stderr "  merge_metaphlan_tables.py"
    puts stderr "  metaphlan_hclust_heatmap.py --help"
    puts stderr "  bowtie2 --help"
    puts stderr "   + more"
    puts stderr ""
    puts stderr "Documentation References:"
    puts stderr "  https://bitbucket.org/biobakery/metaphlan2/"
    puts stderr ""
    puts stderr "Citation (goto reference for complete cite):"
    puts stderr "  Duy Tin Truong, Eric A Franzosa, Timothy L Tickle, Nicola Segata, et al."
    puts stderr "     Nature Methods 12, 902-903 (2015)"
    puts stderr "##############################################"

}

# vim: ft=tcl

EOF


VIRTUAL_ENV /packages/6x/metaphlan/2.6.0/lib.venv.py.d/2.7.12/venv
PATH        /packages/6x/metaphlan/2.6.0/lib.venv.py.d/2.7.12/venv/bin


# 2.6.0
cat <<EOF > 2.6.0
#%Module1.0
proc ModulesHelp { } {
  puts stderr "metaphlan 2.6.0"
}
module-whatis "metaphlan 2.6.0"

source \$env(MODULESHOME)/modulefiles/.osversion

#source \$env(MODULESHOME)/modulefiles/.5xonly

#source \$env(MODULESHOME)/modulefiles/.6xonly

#source \$env(MODULESHOME)/modulefiles/.7xonly

#source \$env(MODULESHOME)/modulefiles/.gui_warning 

#source \$env(MODULESHOME)/modulefiles/.deprecated_warning

#source \$env(MODULESHOME)/modulefiles/.experimental_warning

#source \$env(MODULESHOME)/modulefiles/.discouraged_warning

#source \$env(MODULESHOME)/modulefiles/.retired_error

source \$env(MODULESHOME)/modulefiles/metaphlan/.module_usage-2.6.0

set topdir /packages/\$osprefix/metaphlan/2.6.0
set py_version 2.7.12

# module dependencies
module load python/\$py_version
prereq python/\$py_version

module load bowtie2/2.2.5
prereq bowtie2/2.2.5

prepend-path PATH        \$topdir/bin
prepend-path PATH        \$topdir/bin/utils
prepend-path PATH        \$topdir/lib.venv.py.d/\$py_version/venv/bin

prepend-path VIRTUAL_ENV \$topdir/lib.venv.py.d/\$py_version/venv

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

setenv A2C2_TAGS "phylogenetic,analysis,genomes,bacterial,archaeal,viral,eukaryotic"
setenv A2C2_DESCRIPTION "MetaPhlAn is a computational tool for profiling the composition of microbial communities (Bacteria, Archaea, Eukaryotes and Viruses) from metagenomic shotgun sequencing data with species level resolution. From version 2.6.0, MetaPhlAn is also able to identify specific strains (in the not-so-frequent cases in which the sample contains a previously sequenced strains) and to track strains across samples for all species."
setenv A2C2_URL "https://bitbucket.org/biobakery/metaphlan2/"
setenv A2C2_NOTES "virtualenv install"

setenv A2C2_INSTALL_DATE "2017-09-11"
setenv A2C2_INSTALLER "primusdj"
setenv A2C2_BUILDPATH "/packages/6x/build/metaphlan/2.6.0"

setenv A2C2_MODIFY_DATE "2017-09-11"
setenv A2C2_MODIFIER "primusdj"

setenv A2C2_VERIFY_DATE "2017-09-11"
setenv A2C2_VERIFIER "primusdj"

source \$env(MODULESHOME)/modulefiles/.unset_a2c2

# vim: ft=tcl


EOF

##########################
# make it 7x ready also:
#############

cp /packages/6x/build/metaphlan/2.6.0/*.s* /packages/7x/build/metaphlan/2.6.0
cp /packages/6x/build/metaphlan/2.6.0/tartartar /packages/7x/build/metaphlan/2.6.0
