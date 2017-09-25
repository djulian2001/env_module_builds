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
	- http://www.drive5.com/uclust/downloads1_2_22q.html

downloads:
	- http://www.drive5.com/uclust/uclustq1.2.22_i86linux64
	- 
instructions:
	- 
uclustq1.2.22_i86linux64

Scripts:


##########################
# replace variables
#############
uclust "is the modules name  (lower case only)"
1.2.22 "is the modules version x.x.x prefered"
http://www.drive5.com/uclust/uclustq1.2.22_i86linux64 "is the download url, this can vary"
http://www.drive5.com/uclust/uclustq1.2.22_i86linux64

http://www.drive5.com/uclust/uclustq1.2.22_i86linux32
##########################
# init the build directories
#############
mkdir -p "/packages/6x/build/uclust/1.2.22"
mkdir -p "/packages/7x/build/uclust/1.2.22"

cd "/packages/6x/build/uclust/1.2.22"

##########################
# variables.source
#############

# cat <<EOF > variables.source
#!/bin/bash

OSPREFIX="6x"

source /packages/\$OSPREFIX/build/header.source

module purge

DOWNLOAD_URL="http://www.drive5.com/uclust/uclustq1.2.22_i86linux64"

MODULE="uclust"
VERSION="1.2.22"
FINAL_BINARY_FILE="uclust"
SRC_FILE="uclustq1.2.22_i86linux64"
SRC_DIR="bin"

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
chmod 0551 "\$INSTALL_DIR/bin/\$FINAL_BINARY_FILE"

EOF

##########################
# modulefile
#############
files:
	- .modulerc
	- .norun
	- .module_usage-1.2.22
	- 1.2.22

module_dir="/packages/sysadmin/environment_modules/modulefiles/uclust"

mkdir -p /packages/sysadmin/environment_modules/modulefiles/uclust
cd /packages/sysadmin/environment_modules/modulefiles/uclust

# .modulerc
cat <<EOF > .modulerc
#%Module1.0
module-version uclust/.norun default
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

# .module_usage-1.2.22
cat <<EOF >> .module_usage-1.2.22
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





# 1.2.22
cat <<EOF >> 1.2.22
#%Module1.0
proc ModulesHelp { } {
  puts stderr "uclust 1.2.22"
}
module-whatis "uclust 1.2.22"

source \$env(MODULESHOME)/modulefiles/.osversion

#source \$env(MODULESHOME)/modulefiles/.5xonly

#source \$env(MODULESHOME)/modulefiles/.6xonly

#source \$env(MODULESHOME)/modulefiles/.7xonly

#source \$env(MODULESHOME)/modulefiles/.gui_warning 

#source \$env(MODULESHOME)/modulefiles/.deprecated_warning

#source \$env(MODULESHOME)/modulefiles/.experimental_warning

#source \$env(MODULESHOME)/modulefiles/.discouraged_warning

#source \$env(MODULESHOME)/modulefiles/.retired_error

set topdir /packages/\$osprefix/uclust/1.2.22

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

setenv A2C2_TAGS "binary"
setenv A2C2_DESCRIPTION "A binary dependency for pynast(y)."
setenv A2C2_URL "http://www.drive5.com/uclust/downloads1_2_22q.html"
setenv A2C2_NOTES ""

setenv A2C2_INSTALL_DATE "2017-09-08"
setenv A2C2_INSTALLER "primusdj"
setenv A2C2_BUILDPATH "/packages/\$osprefix/build/uclust/1.2.22"

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
/packages/6x/build/uclust/1.2.22
cp "/packages/6x/build/uclust/1.2.22/*.s*" "/packages/7x/build/uclust/yyyyy"
