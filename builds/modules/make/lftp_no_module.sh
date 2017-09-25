#!/bin/bash
status
	6x - complete
	7x - complete

software:
	lftp

source:
	http://lftp.yar.ru/get.html

download:
	http://lftp.yar.ru/ftp/lftp-4.7.8.tar.gz
	http://lftp.yar.ru/ftp/lftp-4.7.8.tar.gz.asc
instructions:
	none...
	$source_dir/INSTALL


Scripts:

vi download.sh <EOF
#cat <<EOF >> download.sh
#!/bin/bash

wget -c http://lftp.yar.ru/ftp/lftp-4.7.8.tar.gz

EOF

vi build.sh <EOF
#cat <<EOF >> build.sh
#!/bin/bash

source /packages/6x/build/header.source

module purge

osprefix="6x"
module="lftp"
version="4.7.8"
build_dir="/packages/$osprefix/build/$module/$version"
source_file="$build_dir/lftp-4.7.8.tar.gz"
source_dir="$build_dir/lftp-4.7.8"
install_dir = "/packages/$osprefix/$module/$version"

echo-yellow "File structure tasks and setup....."
if [ -d "$source_dir" ]; then
  rm -rf "$source_dir"
fi

if [ ! -d "$install_dir" ]; then
	mkdir -p "$install_dir"
fi

echo-yellow "Load the module dependencies....."
module load gcc/"$osprefix"

echo-yellow "Extract archive file or pull set in the download.sh....."
tar -xzf "$source_file"

echo-yellow "Configure the software....."
cd "$source_dir"
./configure \
	--prefix="$install_dir" 2>&1 | tee "$build_dir/_configure.out"

pipe_error_check

echo-yellow "Make test or check the configuration....."
make check 2>&1 | tee "$build_dir/_make_check.out"
# this hung on a ./ftp_list test, not sure why

pipe_error_check

echo-yellow "Make build the software....."
make 2>&1 | tee "$build_dir/_make.out"

pipe_error_check

echo-yellow "Make install the software....."
make install 2>&1 | tee "$build_dir/_make_install.out"

pipe_error_check

echo-yellow "Optionally, Make install check the software....."
make installcheck 2>&1 | tee "$build_dir/_make_installcheck.out"

pipe_error_check

echo-yellow "Make clean and other clean up....."
make clean 2>&1 | tee "$build_dir/_make_clean.out"

pipe_error_check

module purge

EOF







# Learn how to gpg file checking, etc....
# Future linux research how to do the following:
# wget -c http://lftp.yar.ru/ftp/lftp-4.7.8.tar.gz.asc

# public_key="http://lav.yar.ru/lav@yars.free.net-gpg-public-key"


# tar -xzf lftp-4.7.8.tar.gz.asc # this didn't work

# not sure how to 'verify' these files
# gpg --verify lftp-4.7.8.tar.gz.asc lftp-4.7.8.tar.gz
# gpg --check-sigs lftp-4.7.8.tar.gz.asc lftp-4.7.8.tar.gz

# gpg --list-public-keys

# ( gpg --list-keys F2A99A18 > /dev/null 2>&1 || gpg --recv-keys F2A99A18 ) &&
#  wget -nc http://ftp.yars.free.net/pub/source/lftp/lftp-3.7.14.tar.bz2.asc &&
#   gpg --verify lftp-3.7.14.tar.bz2.asc && rm lftp-3.7.14.tar.bz2.asc
