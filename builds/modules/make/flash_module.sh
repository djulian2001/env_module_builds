##########################
# variables
#############
status
	6x - 
	7x - 

software:
	- 

dependencies:
	-

information source:
	- https://ccb.jhu.edu/software/FLASH/

downloads:
	- https://downloads.sourceforge.net/project/flashpage/FLASH-1.2.11.tar.gz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fflashpage%2Ffiles%2F&ts=1504821236&use_mirror=newcontinuum
	- https://sourceforge.net/projects/flashpage/files/FLASH-1.2.11.tar.gz/download
instructions:
	- 


Scripts:


##########################
# replace variables
#############
flash "is the modules name  (lower case only)"
1.2.11 "is the modules version x.x.x prefered"
https://sourceforge.net/projects/flashpage/files/FLASH-1.2.11.tar.gz/download "is the download url, this can vary"


##########################
# init the build directories
#############
mkdir -p "/packages/6x/build/flash/1.2.11"
mkdir -p "/packages/7x/build/flash/1.2.11"

cd "/packages/6x/build/flash/1.2.11"

##########################
# variables.source
#############

# cat <<EOF > variables.source
#!/bin/bash

OSPREFIX="6x"

source /packages/\$OSPREFIX/build/header.source

module purge

DOWNLOAD_URL="https://sourceforge.net/projects/flashpage/files/FLASH-1.2.11.tar.gz/download"
#GIT_VERSION_TAG=""

MODULE="flash"
VERSION="1.2.11"
SRC_FILE="FLASH-1.2.11.tar.gz"
SRC_DIR="FLASH-1.2.11"
HASH_CHECK="e4d355023a766afaaab2d62f912b605c"

BUILD_DIR="/packages/\$OSPREFIX/build/\$MODULE/\$VERSION"
SOURCE_FILE="\$BUILD_DIR/\$SRC_FILE"
SOURCE_DIR="\$BUILD_DIR/\$SRC_DIR"
INSTALL_DIR="/packages/\$OSPREFIX/\$MODULE/\$VERSION"

EOF

##########################
# download process
#############

# vi download.sh
#cat <<EOF >> download.sh
#!/bin/bash

source variables.source

wget -c "\$DOWNLOAD_URL"
# if can check the source tar files do it
if [ ! -z "\$HASH_CHECK" ]; then
    md5sum -c <<<"\$HASH_CHECK  \$SOURCE_FILE" 2>&1 | tee _download_check.out
fi

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

mkdir "\$INSTALL_DIR/bin"

echo-yellow "Extract archive file or pull set in the download.sh....."
tar -xzf "\$SOURCE_FILE"

echo-yellow "Load the module dependencies....."
module load gcc/"\$OSPREFIX"

echo-yellow "Make build the software....."
cd "\$SOURCE_DIR"
make 2>&1 | tee "\$BUILD_DIR/_make.out"

pipe_error_check

echo-yellow "Copy to install the software....."
cp "\$SOURCE_DIR/flash" "\$INSTALL_DIR/bin"

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
	- .module_usage-1.2.11
	- 1.2.11

module_dir="/packages/sysadmin/environment_modules/modulefiles/flash"

mkdir -p /packages/sysadmin/environment_modules/modulefiles/flash
cd /packages/sysadmin/environment_modules/modulefiles/flash

# .modulerc
cat <<EOF > .modulerc
#%Module1.0
module-version flash/.norun default
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

# .module_usage-1.2.11
cat <<EOF >> .module_usage-1.2.11
#%Module1.0

if { [module-info mode load] } {

    puts stderr "##############################################"
    puts stderr "# How to use:"
    puts stderr "##############################################"
    puts stderr ""
    puts stderr "Software Help Menu:"
    puts stderr "  flash --help"
    puts stderr ""
    puts stderr ""
    puts stderr "Documentation References:"
    puts stderr "  https://ccb.jhu.edu/software/FLASH/"
    puts stderr ""
    puts stderr "##############################################"

}

# vim: ft=tcl

EOF





# 1.2.11
cat <<EOF >> 1.2.11
#%Module1.0
proc ModulesHelp { } {
  puts stderr "flash 1.2.11"
}
module-whatis "flash 1.2.11"

source \$env(MODULESHOME)/modulefiles/.osversion

#source \$env(MODULESHOME)/modulefiles/.5xonly

#source \$env(MODULESHOME)/modulefiles/.6xonly

#source \$env(MODULESHOME)/modulefiles/.7xonly

#source \$env(MODULESHOME)/modulefiles/.gui_warning 

#source \$env(MODULESHOME)/modulefiles/.deprecated_warning

#source \$env(MODULESHOME)/modulefiles/.experimental_warning

#source \$env(MODULESHOME)/modulefiles/.discouraged_warning

#source \$env(MODULESHOME)/modulefiles/.retired_error

source \$env(MODULESHOME)/modulefiles/flash/.module_usage-1.2.11

# module dependencies
module load gcc/\$osprefix
prereq gcc/\$osprefix

set topdir /packages/\$osprefix/flash/1.2.11

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

setenv A2C2_TAGS "DNA,"
setenv A2C2_DESCRIPTION "FLASH (Fast Length Adjustment of SHort reads) is a very fast and accurate software tool to merge paired-end reads from next-generation sequencing experiments. FLASH is designed to merge pairs of reads when the original DNA fragments are shorter than twice the length of reads."
setenv A2C2_URL "https://ccb.jhu.edu/software/FLASH/"
setenv A2C2_NOTES ""

setenv A2C2_INSTALL_DATE "2017-09-07"
setenv A2C2_INSTALLER "primusdj"
setenv A2C2_BUILDPATH "/packages/6x/build/flash/1.2.11"

setenv A2C2_MODIFY_DATE "2017-09-07"
setenv A2C2_MODIFIER "primusdj"

setenv A2C2_VERIFY_DATE "2017-09-07"
setenv A2C2_VERIFIER "primusdj"

source \$env(MODULESHOME)/modulefiles/.unset_a2c2

# vim: ft=tcl


EOF

