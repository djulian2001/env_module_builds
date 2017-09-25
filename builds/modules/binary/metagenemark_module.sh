##########################
# variables
#############
status
	6x - complete
	7x - complete

software:
	- binary install

dependencies:
	- none

information source:
    Research Computing
    Arizona State University
    USA
    rchelp@asu.edu
	- http://topaz.gatech.edu/Genemark/license_download.cgi

downloads:
	- http://topaz.gatech.edu/GeneMark/tmp/GMtool_WAxWj/MetaGeneMark_linux_64.tar.gz
	- http://topaz.gatech.edu/GeneMark/tmp/GMtool_WAxWj/gm_key_64.gz
instructions:
	- 


Scripts:


##########################
# init variables
#############
metagenemark "is modules name  (lower case only)"
3.38 "is the modules version x.x.x prefered"
http://topaz.gatech.edu/GeneMark/tmp/GMtool_WAxWj/MetaGeneMark_linux_64.tar.gz "is the download url, this can vary"


##########################
# init the build directories
#############
mkdir -p "/packages/6x/build/metagenemark/3.38"
mkdir -p "/packages/7x/build/metagenemark/3.38"


##########################
# download process
#############

# vi download.sh <EOF
cat <<EOF >> download.sh
#!/bin/bash

download_url="http://topaz.gatech.edu/GeneMark/tmp/GMtool_WAxWj/MetaGeneMark_linux_64.tar.gz"
wget -c "\$download_url"
wget -c http://topaz.gatech.edu/GeneMark/tmp/GMtool_WAxWj/gm_key_64.gz

EOF

##########################
# build process
#############


vi build.sh <EOF
#cat <<EOF > build.sh
#!/bin/bash

OSPREFIX="6x"

source /packages/\$OSPREFIX/build/header.source

module purge

MODULE="metagenemark"
VERSION="3.38"
BUILD_DIR="/packages/\$OSPREFIX/build/\$MODULE/\$VERSION"
SOURCE_FILE="\$BUILD_DIR/MetaGeneMark_linux_64.tar.gz"
SOURCE_DIR="\$BUILD_DIR/MetaGeneMark_linux_64"
INSTALL_DIR="/packages/\$OSPREFIX/\$MODULE/\$VERSION"

echo-yellow "File structure tasks and setup....."
if [ -d "\$SOURCE_DIR" ]; then
  rm -rf "\$SOURCE_DIR"
fi

if [ ! -d "\$INSTALL_DIR" ]; then
	mkdir -p "\$INSTALL_DIR"
fi

echo-yellow "Extract archive file or pull set in the download.sh....."
tar -xzf "\$SOURCE_FILE"

# gunzip gm_key_64.gz

echo-yellow "Binary Install, set permissions, and copy....."
cd "\$SOURCE_DIR/mgm"
chown root:root -R "\$SOURCE_DIR"
/bin/cp -R "\$SOURCE_DIR/mgm/." "\$INSTALL_DIR"
/bin/cp "\$BUILD_DIR/gm_key_64" "\$INSTALL_DIR"

EOF


##########################
# modulefile
#############
files:
	- .modulerc
	- .norun
	- .module_usage-3.38
	- 3.38

module_dir="/packages/sysadmin/environment_modules/modulefiles/metagenemark"

mkdir -p /packages/sysadmin/environment_modules/modulefiles/metagenemark
cd /packages/sysadmin/environment_modules/modulefiles/metagenemark

# .modulerc
cat <<EOF > .modulerc
#%Module1.0
module-version metagenemark/.norun default
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

source \$env(MODULESHOME)/modulefiles/.unset_a2c2

# vim: ft=tcl

EOF

# .module_usage-3.38
cat <<EOF >> .module_usage-3.38
#%Module1.0

if { [module-info mode load] } {

    puts stderr "##############################################"
    puts stderr "# How to use:"
    puts stderr "##############################################"
    puts stderr ""
    puts stderr "Software Help Menu:"
    puts stderr "  gmhmmp"
    puts stderr ""
    puts stderr ""
    puts stderr "Other Files:"
    puts stderr "  gm_key_64"
    puts stderr "  MetaGeneMark_v1.mod"
    puts stderr ""
    puts stderr ""
    puts stderr "Documentation References:"
    puts stderr "  README.MetaGeneMark"
    puts stderr ""
    puts stderr "##############################################"

}
EOF

# vim: ft=tcl




# 3.38
cat <<EOF >> 3.38
#%Module1.0
proc ModulesHelp { } {
  puts stderr "metagenemark 3.38"
}
module-whatis "metagenemark 3.38"

source \$env(MODULESHOME)/modulefiles/.osversion

#source \$env(MODULESHOME)/modulefiles/.5xonly

#source \$env(MODULESHOME)/modulefiles/.6xonly

#source \$env(MODULESHOME)/modulefiles/.7xonly

#source \$env(MODULESHOME)/modulefiles/.gui_warning 

#source \$env(MODULESHOME)/modulefiles/.deprecated_warning

#source \$env(MODULESHOME)/modulefiles/.experimental_warning

#source \$env(MODULESHOME)/modulefiles/.discouraged_warning

#source \$env(MODULESHOME)/modulefiles/.retired_error

source \$env(MODULESHOME)/modulefiles/metagenemark/.module_usage-3.38

set topdir /packages/\$osprefix/metagenemark/3.38

prepend-path PATH               \$topdir

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

setenv A2C2_TAGS "gene,prediction,metagenomes"
setenv A2C2_DESCRIPTION "A family of gene prediction programs developed at Georgia Institute of Technology , Atlanta, Georgia, USA."
setenv A2C2_URL "http://topaz.gatech.edu/Genemark/index.html"
setenv A2C2_NOTES "binary install"

setenv A2C2_INSTALL_DATE "2017-09-05"
setenv A2C2_INSTALLER "primusdj"
setenv A2C2_BUILDPATH "/packages/6x/build/metagenemark/3.38"

setenv A2C2_MODIFY_DATE "2017-09-05"
setenv A2C2_MODIFIER "primusdj"

setenv A2C2_VERIFY_DATE "2017-09-05"
setenv A2C2_VERIFIER "primusdj"

source \$env(MODULESHOME)/modulefiles/.unset_a2c2

# vim: ft=tcl


EOF

