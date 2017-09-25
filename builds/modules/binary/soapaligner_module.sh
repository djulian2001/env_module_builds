##########################
# variables
#############
status
	6x - complete
	7x - complete

software:
	- soapaligner


dependencies:
	- none

information source:
	- http://soap.genomics.org.cn/soapaligner.html

downloads:
	- http://soap.genomics.org.cn/down/soap2.21release.tar.gz
	- MD5: 563b8b7235463b68413f9e841aa40779
instructions:
	- module load soapaligner/2.21


Scripts:


##########################
# variables
#############
soapaligner "is the modules name  (lower case only)"
2.21 "is the modules version x.x.x prefered"
http://soap.genomics.org.cn/down/soap2.21release.tar.gz "is the download url, this can vary"


##########################
# init the build directories
#############
mkdir -p "/packages/6x/build/soapaligner/2.21"
mkdir -p "/packages/7x/build/soapaligner/2.21"


##########################
# download process
#############

# vi download.sh <EOF
cat <<EOF > download.sh
#!/bin/bash

OSPREFIX="6x"
source /packages/\$OSPREFIX/build/header.source

download_url="http://soap.genomics.org.cn/down/soap2.21release.tar.gz"
wget -c "\$download_url"

md5sum -c <<<"563b8b7235463b68413f9e841aa40779  soap2.21release.tar.gz" 2>&1 | tee _download_check.out

pipe_error_check

EOF




##########################
# build process
#############


vi build.sh <EOF
cat <<EOF > build.sh
#!/bin/bash

OSPREFIX="6x"

source /packages/\$OSPREFIX/build/header.source

module purge

MODULE="soapaligner"
VERSION="2.21"
BUILD_DIR="/packages/\$OSPREFIX/build/\$MODULE/\$VERSION"
SOURCE_FILE="\$BUILD_DIR/soap2.21release.tar.gz"
SOURCE_DIR="\$BUILD_DIR/soap2.21release"
INSTALL_DIR="/packages/\$OSPREFIX/\$MODULE/\$VERSION"

echo-yellow "File structure tasks and setup....."
if [ -d "\$SOURCE_DIR" ]; then
  rm -rf "\$SOURCE_DIR"
fi

if [ -d "\$INSTALL_DIR" ]; then
    # mkdir -p "\$INSTALL_DIR/bin"
	rm -rf "\$INSTALL_DIR"
fi

mkdir -p "\$INSTALL_DIR/bin"
mkdir -p "\$INSTALL_DIR/man/man1"

echo-yellow "Extract archive file or pull set in the download.sh....."
tar -xzf "\$SOURCE_FILE"

echo-yellow "Binary software setup....."
chown root:root -R "\$SOURCE_DIR"
# copy binary files

/bin/cp "\$SOURCE_DIR/2bwt-builder" "\$INSTALL_DIR/bin"
/bin/cp "\$SOURCE_DIR/soap" "\$INSTALL_DIR/bin"

echo-yellow "Manual pages setup....."
cp "\$SOURCE_DIR/soap.man" "\$INSTALL_DIR/man"
cp "\$SOURCE_DIR/NOTE" "\$INSTALL_DIR"

# the actual man page
cp "\$SOURCE_DIR/soap.1" "\$INSTALL_DIR/man/man1"
gzip "\$INSTALL_DIR/man/man1/soap.1"

EOF


##########################
# modulefile
#############
files:
	- .modulerc
	- .norun
	- .module_usage-2.21
	- 2.21

module_dir="/packages/sysadmin/environment_modules/modulefiles/soapaligner"

mkdir -p /packages/sysadmin/environment_modules/modulefiles/soapaligner
cd /packages/sysadmin/environment_modules/modulefiles/soapaligner

# .modulerc
cat <<EOF > .modulerc
#%Module1.0
module-version soapaligner/.norun default
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

# .module_usage-2.21
cat <<EOF >> .module_usage-2.21
#%Module1.0

if { [module-info mode load] } {

    puts stderr "##############################################"
    puts stderr "# How to use:"
    puts stderr "##############################################"
    puts stderr ""
    puts stderr "Software and help menu:"
    puts stderr "  soap -h"
    puts stderr "  2bwt-builder"
    puts stderr ""
    puts stderr "Other files:"
    puts stderr " cat /packages/\$osprefix/soapaligner/2.21/NOTE"
    puts stderr ""
    puts stderr ""
    puts stderr "Documentation References:"
    puts stderr " man soap"
    puts stderr " http://soap.genomics.org.cn/soapaligner.html"
    puts stderr ""
    puts stderr "##############################################"

}

# vim: ft=tcl

EOF


# 2.21
cat <<EOF >> 2.21
#%Module1.0
proc ModulesHelp { } {
  puts stderr "soapaligner 2.21"
}
module-whatis "soapaligner 2.21"

source \$env(MODULESHOME)/modulefiles/.osversion

#source \$env(MODULESHOME)/modulefiles/.5xonly

#source \$env(MODULESHOME)/modulefiles/.6xonly

#source \$env(MODULESHOME)/modulefiles/.7xonly

#source \$env(MODULESHOME)/modulefiles/.gui_warning 

#source \$env(MODULESHOME)/modulefiles/.deprecated_warning

#source \$env(MODULESHOME)/modulefiles/.experimental_warning

#source \$env(MODULESHOME)/modulefiles/.discouraged_warning

#source \$env(MODULESHOME)/modulefiles/.retired_error

source \$env(MODULESHOME)/modulefiles/soapaligner/.module_usage-2.21

set topdir /packages/\$osprefix/soapaligner/2.21

prepend-path PATH                \$topdir/bin

prepend-path MANPATH             \$topdir/man

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

setenv A2C2_TAGS "SOAP,algorithms,illumina,solexa"
setenv A2C2_DESCRIPTION "SOAPaligner/soap2 is a member of the SOAP (Short Oligonucleotide Analysis Package). It is an updated version of SOAP software for short oligonucleotide alignment. The new program features in super fast and accurate alignment for huge amounts of short reads generated by Illumina/Solexa Genome Analyzer."
setenv A2C2_URL "http://soap.genomics.org.cn/soapaligner.html"
setenv A2C2_NOTES "binary install"

setenv A2C2_INSTALL_DATE "2017-09-06"
setenv A2C2_INSTALLER "primusdj"
setenv A2C2_BUILDPATH "/packages/6x/build/soapaligner/2.21"

setenv A2C2_MODIFY_DATE "2017-09-06"
setenv A2C2_MODIFIER "primusdj"

setenv A2C2_VERIFY_DATE "2017-09-06"
setenv A2C2_VERIFIER "primusdj"

source \$env(MODULESHOME)/modulefiles/.unset_a2c2

# vim: ft=tcl


EOF

