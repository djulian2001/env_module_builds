##########################
# variables
#############
status
  6x - process
  7x - 

software:
  - SOAPdenovo

dependencies:
  -

information source:
  - 

downloads:
  - https://github.com/aquaskyline/SOAPdenovo2
  - 
instructions:
  - 


Scripts:


##########################
# variables
#############
soapdenovo "is modules name  (lower case only)"
2.4.1 "is the modules version x.x.x prefered"
https://github.com/aquaskyline/SOAPdenovo2.git "is the download url, this can vary"

##########################
# download process
#############

vi download.sh <EOF
#cat <<EOF > download.sh
#!/bin/bash

download_url="https://github.com/aquaskyline/SOAPdenovo2.git"
# wget -c "\$download_url"
git clone -b r241 "\$download_url" .

EOF

##########################
# build process
#############


vi build.sh <EOF
#cat <<EOF > build.sh
#!/bin/bash

OSPREFIX="6x"

source "/packages/\$OSPREFIX/build/header.source"

module purge

MODULE="soapdenovo"
VERSION="2.4.1"
BUILD_DIR="/packages/\$OSPREFIX/build/\$MODULE/\$VERSION"
SOURCE_DIR="\$BUILD_DIR/soap241"
INSTALL_DIR="/packages/\$OSPREFIX/\$MODULE/\$VERSION"

echo-yellow "File structure tasks and setup....."
if [ -d "\$SOURCE_DIR" ]; then
  rm -rf "\$SOURCE_DIR"
fi

if [ ! -d "\$INSTALL_DIR" ]; then
  mkdir -p "\$INSTALL_DIR"
fi

echo-yellow "Extract archive file or clone set in the download.sh....."
source "\$BUILD_DIR/download.sh"

cd "\$SOURCE_DIR"

echo-yellow "Make build the software....."
make 2>&1 | tee "\$BUILD_DIR/_make.out"

pipe_error_check

echo-yellow "Copy files over install the software....."
/bin/cp -rf "$SOURCE_DIR/SOAPdenovo-127mer" "$INSTALL_DIR"
/bin/cp -rf "$SOURCE_DIR/SOAPdenovo-63mer" "$INSTALL_DIR"
/bin/cp -rf "$SOURCE_DIR/SOAPdenovo-fusion" "$INSTALL_DIR"

# echo-yellow "Make clean and other clean up....."
# make clean 2>&1 | tee "\$BUILD_DIR/_make_clean.out"

# pipe_error_check

module purge

EOF


##########################
# modulefile
#############
files:
  - .modulerc
  - .norun
  - .module_usage-2.4.1
  - 2.4.1

module_dir="/packages/sysadmin/environment_modules/modulefiles/soapdenovo"

mkdir -p /packages/sysadmin/environment_modules/modulefiles/soapdenovo
cd /packages/sysadmin/environment_modules/modulefiles/soapdenovo

# .modulerc
cat <<EOF > .modulerc
#%Module1.0
module-version soapdenovo/.norun default
EOF

# .norun
cat <<EOF >> .norun

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

source $env(MODULESHOME)/modulefiles/.unset_a2c2

# vim: ft=tcl

EOF

# .module_usage-2.4.1
cat <<EOF >> .module_usage-2.4.1
#%Module1.0

if { [module-info mode load] } {

    puts stderr "##############################################"
    puts stderr "# How to use:"
    puts stderr "##############################################"
    puts stderr ""
    puts stderr "Software:"
    puts stderr "  SOAPdenovo-127mer"
    puts stderr "  SOAPdenovo-63mer"
    puts stderr "  SOAPdenovo-fusion"
    puts stderr ""
    puts stderr ""
    puts stderr ""
    puts stderr ""
    puts stderr ""
    puts stderr "Documentation References:"
    puts stderr "  http://soap.genomics.org.cn/soapdenovo.html"
    puts stderr ""
    puts stderr "##############################################"

}
EOF

# vim: ft=tcl




# 2.4.1
cat <<EOF >> 2.4.1
#%Module1.0
proc ModulesHelp { } {
  puts stderr "soapdenovo 2.4.1"
}
module-whatis "soapdenovo 2.4.1"

source \$env(MODULESHOME)/modulefiles/.osversion

#source \$env(MODULESHOME)/modulefiles/.5xonly

#source \$env(MODULESHOME)/modulefiles/.6xonly

#source \$env(MODULESHOME)/modulefiles/.7xonly

#source \$env(MODULESHOME)/modulefiles/.gui_warning 

#source \$env(MODULESHOME)/modulefiles/.deprecated_warning

#source \$env(MODULESHOME)/modulefiles/.experimental_warning

#source \$env(MODULESHOME)/modulefiles/.discouraged_warning

#source \$env(MODULESHOME)/modulefiles/.retired_error

source \$env(MODULESHOME)/modulefiles/soapdenovo/.module_usage-2.4.1


set topdir /packages/\$osprefix/soapdenovo/2.4.1

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

setenv A2C2_TAGS "plant,animal,genomes"
setenv A2C2_DESCRIPTION "SOAPdenovo is a novel short-read assembly method that can build a de novo draft assembly for the human-sized genomes. The program is specially designed to assemble Illumina GA short reads."
setenv A2C2_URL "http://soap.genomics.org.cn/soapdenovo.html"
setenv A2C2_NOTES ""

setenv A2C2_INSTALL_DATE "2017-07-24"
setenv A2C2_INSTALLER "primusdj"
setenv A2C2_BUILDPATH "/packages/6x/build/soapdenovo/2.4.1"

setenv A2C2_MODIFY_DATE "2017-07-28"
setenv A2C2_MODIFIER "primusdj"

setenv A2C2_VERIFY_DATE "2017-07-28"
setenv A2C2_VERIFIER "primusdj"

source \$env(MODULESHOME)/modulefiles/.unset_a2c2

# vim: ft=tcl


EOF

