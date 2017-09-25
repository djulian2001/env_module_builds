# /bin/bash

# install the software for a ticket IR149381
sudo wget --output-document=/tmp/ambiore-1.00.tar.gz http://www.phrap.org/software_dir/hwang_dir/ambiore-1.00.tar.gz

sudo -u vagrant tar -zxvf /tmp/ambiore-1.00.tar.gz -C /home/vagrant
-x, --extract, --get			extaction of content from file
-f, --file=ARCHIVE				use archive file or device ARCHIVE
-z, --gzip, --gunzip, --ungzip  filter the archive through gzip


wget http://www.phrap.org/software_dir/hwang_dir/ambiore-1.00.tar.gz
tar -zxvf ambiore-1.00.tar.gz

mkdir /packages/6x/ambiore
cp --recursive 1.0.0/ /packages/6x/ambiore

cd /packages/sysadmin/environment_modules/modulefiles
mkdir ambiore

# make the modulefile agnostic of the os.
source $env(MODULESHOME)/modulefiles/.osversion

set topdir /packages/$osprefix/ambiore/1.0.0