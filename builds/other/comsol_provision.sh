#! /bin/sh

echo "Yeah We are provisioning!"
# sudo yum update -y
# getting penncnv  the stuff to work
sudo yum install -y environment-modules
sudo yum install -y perl-ExtUtils-Embed.x86_64


sudo -u vagrant mkdir penncnv
sudo -u vagrant wget -P ./penncnv https://github.com/WGLab/PennCNV/archive/v1.0.3.tar.gz
cd penncnv
sudo -u vagrant tar -zxvf v1.0.3.tar.gz
cd PennCNV-1.0.3/kext
sudo -u vagrant make


# copy files into the module file...
cp -R PennCNV-1.0.3/ copy_test/
# on the compute node...
cp -R /packages/6x/build/penncnv/PennCNV-1.0.3/ /packages/6x/PennCNV/1.0.3/


wget echo "Yeah We are provisioning!"
mkdir stampy
wget -P ./stampy http://www.well.ox.ac.uk/bioinformatics/Software/Stampy-latest.tgz
cd stampy
tar -xvf Stampy-latest.tgz
cd stampy-1.0.30

sudo yum groupinstall "Development tools"
sudo yum install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel

cd /opt
sudo wget --no-check-certificate https://www.python.org/ftp/python/2.7.6/Python-2.7.6.tar.xz
sudo tar xf Python-2.7.6.tar.xz
cd Python-2.7.6
sudo ./configure --prefix=/usr/local
sudo make && sudo make altinstall

cd ~/stampy/stampy-1.0.30
make python=/usr/local/bin/python2.7


wget echo "Yeah We are provisioning comsol/5.2.1!"

# This requires a iso install...
/vagrant/COMSOL52a_dvd.iso
08:00:27:98:ca:98
ecn-10.wpcarey.ad.asu.edu

