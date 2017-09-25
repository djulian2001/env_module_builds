[vagrant@ecn-10 ~]$ history
sudo -i
mkdir perl5
wget -P ./perl5 http://www.cpan.org/src/5.0/perl-5.14.2.tar.gz
tar -zxvf ./perl5/perl-5.14.2.tar.gz  -C perl5
mkdir packages
mkdir packages/perl5

./Configure -des -Dusethreads-Dprefix=~/packages/perl5/5.14.2  -Accflags='-fPIC' -Dotherlibdirs=~/packages/perl5/5.14.2

perl -MExtUtils::Installed -e'print join("\n", new ExtUtils::Installed->modules)' > ~/module.list

yum search ExtUtils
sudo yum install perl-ExtUtils-MakeMaker.x86_64

./Configure -des -Dusethreads-Dprefix=~/packages/perl5/5.14.2  -Accflags='-fPIC' -Dotherlibdirs=~/packages/perl5/5.14.2
make
sudo make install

tar -zxvf ./penncnv/v1.0.3.tar.gz -C penncnv
cd penncnv/
cd packages/
ls -la perl5/
cd
cd penncnv/
sudo tar -xzvf v1.0.3.tar.gz 
cd PennCNV-1.0.3/
cd kext/
cd
cd penncnv/
cd PennCNV-1.0.3/
./detect_cnv.pl 
perl --version
vim detect_cnv.pl 
env
cd
cd perl5/
cd perl-5.14.2
perl --version
sudo ./Configure -des -Dusethreads-Dprefix=~/packages/perl5/5.14.2  -Accflags='-fPIC' -Dotherlibdirs=~/packages/perl5/5.14.2
make
make install
sudo make install
cd
cd penncnv/
cd PennCNV-1.0.3/
./detect_cnv.pl 
history | grep Ex
cd kext/
make
sudo make
echo $?
./detect_cnv.pl 
cd ..
./detect_cnv.pl 


env
/usr/bin/env perl
/usr/bin/env perl --version
perl --version
which perl
which /usr/bin/env perl
head clean_cnv.pl 
