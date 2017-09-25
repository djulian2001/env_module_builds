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
	- http://drive5.com/usearch/
    - https://www.drive5.com/usearch/manual/

downloads:
	- https://urldefense.proofpoint.com/v2/url?u=https-3A__drive5.com_cgi-2Dbin_upload3.py-3Flicense-3D2017090720114320861&d=DwICAg&c=l45AxH-kUV29SRQusp9vYR0n1GycN4_2jInuKy6zbqQ&r=y-nYrkq6oadEn8q_dlR0MenIszd6eJzoIhg2sZVKjgY&m=yw5Jmky_DXRamK7NnsrZx0WgAVJNbu00giLG1_nKGF8&s=DHd78b4xP3qFYYE3ln4dQ8MLwp0J0oQ--D-pqA-SH8A&e=
	- 
instructions:
	- https://www.drive5.com/usearch/manual/install.html

    - file should be named:
        usearch9.2.64_i86linux32

Scripts:

https://drive5.com/cgi-bin/upload3.py?license=2017090720114320861
##########################
# replace variables
#############
usearch "is the modules name  (lower case only)"
9.2.64 "is the modules version x.x.x prefered"
https://drive5.com/cgi-bin/upload3.py?license=2017090720114320861 "is the download url, this can vary"


##########################
# init the build directories
#############
mkdir -p "/packages/6x/build/usearch/9.2.64"
mkdir -p "/packages/7x/build/usearch/9.2.64"

cd "/packages/6x/build/usearch/9.2.64"

##########################
# variables.source
#############

# cat <<EOF > variables.source
#!/bin/bash

OSPREFIX="6x"

source /packages/\$OSPREFIX/build/header.source

module purge

DOWNLOAD_URL="https://drive5.com/cgi-bin/upload3.py?license=2017090720114320861"
#GIT_VERSION_TAG=""

MODULE="usearch"
VERSION="9.2.64"
SRC_FILE="upload3.py?license=2017090720114320861"
FINAL_BINARY_FILE="usearch"
SRC_DIR="bin"
# HASH_CHECK="hashashash"

BUILD_DIR="/packages/\$OSPREFIX/build/\$MODULE/\$VERSION"
SOURCE_FILE="\$BUILD_DIR/\$SRC_FILE"
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

echo-yellow "The following software was requested via email, the url was provided with the license."
echo-yellow "\$DOWNLOAD_URL"
echo-yellow "If this has to be rebuilt or upgraded, will have to request another site license"
echo-yellow "http://drive5.com/usearch/"
echo-yellow "This software CAN NOT be redistributed, 'Please note this is an individual use, non-transferrable license.'"

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

mkdir -p "\$SOURCE_DIR"
mkdir -p "\$INSTALL_DIR/bin"

echo-yellow "Binary software setup....."
cp "\$SOURCE_FILE" "\$SOURCE_DIR/\$FINAL_BINARY_FILE"
chown root:root -R "\$SOURCE_DIR"

cp "\$SOURCE_DIR/\$FINAL_BINARY_FILE" "\$INSTALL_DIR/bin"
chmod 0111 "\$INSTALL_DIR/bin/\$FINAL_BINARY_FILE"

EOF

##########################
# modulefile
#############
files:
	- .modulerc
	- .norun
	- .module_usage-9.2.64
	- 9.2.64

module_dir="/packages/sysadmin/environment_modules/modulefiles/usearch"

mkdir -p /packages/sysadmin/environment_modules/modulefiles/usearch
cd /packages/sysadmin/environment_modules/modulefiles/usearch

# .modulerc
cat <<EOF > .modulerc
#%Module1.0
module-version usearch/.norun default
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

# .module_usage-9.2.64
cat <<EOF >> .module_usage-9.2.64
#%Module1.0

if { [module-info mode load] } {

    puts stderr "##############################################"
    puts stderr "# How to use:"
    puts stderr "##############################################"
    puts stderr ""
    puts stderr "This is the 32bit FREE version of the software"
    puts stderr "  please respect the authors license request"
    puts stderr ""
    puts stderr "Software Help Menu:"
    puts stderr "  usearch --help"
    puts stderr ""
    puts stderr ""
    puts stderr "Documentation References:"
    puts stderr "  https://www.drive5.com/usearch/manual/"
    puts stderr ""
    puts stderr "##############################################"

}

# vim: ft=tcl

EOF





# 9.2.64
cat <<EOF >> 9.2.64
#%Module1.0
proc ModulesHelp { } {
  puts stderr "usearch 9.2.64"
}
module-whatis "usearch 9.2.64"

source \$env(MODULESHOME)/modulefiles/.osversion

#source \$env(MODULESHOME)/modulefiles/.5xonly

#source \$env(MODULESHOME)/modulefiles/.6xonly

#source \$env(MODULESHOME)/modulefiles/.7xonly

#source \$env(MODULESHOME)/modulefiles/.gui_warning 

#source \$env(MODULESHOME)/modulefiles/.deprecated_warning

#source \$env(MODULESHOME)/modulefiles/.experimental_warning

#source \$env(MODULESHOME)/modulefiles/.discouraged_warning

#source \$env(MODULESHOME)/modulefiles/.retired_error

source \$env(MODULESHOME)/modulefiles/usearch/.module_usage-9.2.64

set topdir /packages/\$osprefix/usearch/9.2.64

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

setenv A2C2_TAGS "blast,sequence"
setenv A2C2_DESCRIPTION "High-throughput search and clustering USEARCH is a unique sequence analysis tool with thousands of users world-wide. USEARCH offers search and clustering algorithms that are often orders of magnitude faster than BLAST."
setenv A2C2_URL "https://www.drive5.com/usearch/"
setenv A2C2_NOTES "license=2017090720114320861"

setenv A2C2_INSTALL_DATE "2017-09-07"
setenv A2C2_INSTALLER "primusdj"
setenv A2C2_BUILDPATH "/packages/6x/build/usearch/9.2.64"

setenv A2C2_MODIFY_DATE "2017-09-07"
setenv A2C2_MODIFIER "primusdj"

setenv A2C2_VERIFY_DATE "2017-09-07"
setenv A2C2_VERIFIER "primusdj"

source \$env(MODULESHOME)/modulefiles/.unset_a2c2

# vim: ft=tcl


EOF

