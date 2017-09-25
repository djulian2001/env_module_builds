# /bin/bash

# check that this is actually ok. the symlink stuff could be someone elses work...
# PLINK v1.07 64-bit ( 10/Aug/2009 )
sudo wget https://www.cog-genomics.org/static/bin/plink/plink1_linux_x86_64.zip
unzip plink1_linux_x86_64.zip
mv plink1_linux_x86_64 1.07

source $env(MODULESHOME)/modulefiles/.osversion

set topdir /packages/$osprefix/plink/1.0.7
setenv A2C2_7X "1"


# PLINK v1.90b3.45 64-bit 13_Jan_2017 binary install...
mkdir plink/1.90
cd 1.90
sudo wget https://www.cog-genomics.org/static/bin/plink170113/plink_linux_x86_64.zip
unzip plink_linux_x86_64.zip


source $env(MODULESHOME)/modulefiles/.osversion

set topdir /packages/$osprefix/plink/1.0.7

set topdir /packages/$osprefix/plink/1.9.0


# this below needs to go away...
drwxr-xr-x 1 root root    1200 May 17  2016 ./
drwxr-xr-x 1 root root    8192 Feb  7 15:46 ../
drwxr-xr-x 1 root root       0 May 17  2016 1.07/
drwxr-xr-x 1 root root     176 May 17  2016 1.90/
lrwxrwxrwx 1 root root      90 May 17  2016 birdseye_merger.py -> /usr/lib/python2.6/site-packages/birdsuite-1.0-py2.5.egg/plink_pipeline/birdseye_merger.py
lrwxrwxrwx 1 root root      91 May 17  2016 birdseye_merger.pyc -> /usr/lib/python2.6/site-packages/birdsuite-1.0-py2.5.egg/plink_pipeline/birdseye_merger.pyc
lrwxrwxrwx 1 root root      90 May 17  2016 birdseye_to_cnv.py -> /usr/lib/python2.6/site-packages/birdsuite-1.0-py2.5.egg/plink_pipeline/birdseye_to_cnv.py
lrwxrwxrwx 1 root root      91 May 17  2016 birdseye_to_cnv.pyc -> /usr/lib/python2.6/site-packages/birdsuite-1.0-py2.5.egg/plink_pipeline/birdseye_to_cnv.pyc
lrwxrwxrwx 1 root root      93 May 17  2016 birdsuite_to_plink.py -> /usr/lib/python2.6/site-packages/birdsuite-1.0-py2.5.egg/plink_pipeline/birdsuite_to_plink.py
lrwxrwxrwx 1 root root      94 May 17  2016 birdsuite_to_plink.pyc -> /usr/lib/python2.6/site-packages/birdsuite-1.0-py2.5.egg/plink_pipeline/birdsuite_to_plink.pyc
lrwxrwxrwx 1 root root      89 May 17  2016 canary_to_gvar.py -> /usr/lib/python2.6/site-packages/birdsuite-1.0-py2.5.egg/plink_pipeline/canary_to_gvar.py
lrwxrwxrwx 1 root root      90 May 17  2016 canary_to_gvar.pyc -> /usr/lib/python2.6/site-packages/birdsuite-1.0-py2.5.egg/plink_pipeline/canary_to_gvar.pyc
-rw-r--r-x 1 root root   15365 May 17  2016 COPYING.txt*
lrwxrwxrwx 1 root root      85 May 17  2016 create_map.py -> /usr/lib/python2.6/site-packages/birdsuite-1.0-py2.5.egg/plink_pipeline/create_map.py
lrwxrwxrwx 1 root root      86 May 17  2016 create_map.pyc -> /usr/lib/python2.6/site-packages/birdsuite-1.0-py2.5.egg/plink_pipeline/create_map.pyc
lrwxrwxrwx 1 root root      95 May 17  2016 diploid_calls_filter.py -> /usr/lib/python2.6/site-packages/birdsuite-1.0-py2.5.egg/plink_pipeline/diploid_calls_filter.py
lrwxrwxrwx 1 root root      96 May 17  2016 diploid_calls_filter.pyc -> /usr/lib/python2.6/site-packages/birdsuite-1.0-py2.5.egg/plink_pipeline/diploid_calls_filter.pyc
lrwxrwxrwx 1 root root      88 May 17  2016 fam_to_gender.py -> /usr/lib/python2.6/site-packages/birdsuite-1.0-py2.5.egg/plink_pipeline/fam_to_gender.py
lrwxrwxrwx 1 root root      89 May 17  2016 fam_to_gender.pyc -> /usr/lib/python2.6/site-packages/birdsuite-1.0-py2.5.egg/plink_pipeline/fam_to_gender.pyc
lrwxrwxrwx 1 root root      87 May 17  2016 fawkes_merge.py -> /usr/lib/python2.6/site-packages/birdsuite-1.0-py2.5.egg/plink_pipeline/fawkes_merge.py
lrwxrwxrwx 1 root root      88 May 17  2016 fawkes_merge.pyc -> /usr/lib/python2.6/site-packages/birdsuite-1.0-py2.5.egg/plink_pipeline/fawkes_merge.pyc
lrwxrwxrwx 1 root root      92 May 17  2016 fawkes_to_diploid.py -> /usr/lib/python2.6/site-packages/birdsuite-1.0-py2.5.egg/plink_pipeline/fawkes_to_diploid.py
lrwxrwxrwx 1 root root      93 May 17  2016 fawkes_to_diploid.pyc -> /usr/lib/python2.6/site-packages/birdsuite-1.0-py2.5.egg/plink_pipeline/fawkes_to_diploid.pyc
lrwxrwxrwx 1 root root      89 May 17  2016 fawkes_to_gvar.py -> /usr/lib/python2.6/site-packages/birdsuite-1.0-py2.5.egg/plink_pipeline/fawkes_to_gvar.py
lrwxrwxrwx 1 root root      90 May 17  2016 fawkes_to_gvar.pyc -> /usr/lib/python2.6/site-packages/birdsuite-1.0-py2.5.egg/plink_pipeline/fawkes_to_gvar.pyc
-rwx---r-x 1 root root 1799865 May 17  2016 gPLINK.jar*
lrwxrwxrwx 1 root root      83 May 17  2016 __init__.py -> /usr/lib/python2.6/site-packages/birdsuite-1.0-py2.5.egg/plink_pipeline/__init__.py
lrwxrwxrwx 1 root root      84 May 17  2016 __init__.pyc -> /usr/lib/python2.6/site-packages/birdsuite-1.0-py2.5.egg/plink_pipeline/__init__.pyc
lrwxrwxrwx 1 root root      84 May 17  2016 make_tfam.py -> /usr/lib/python2.6/site-packages/birdsuite-1.0-py2.5.egg/plink_pipeline/make_tfam.py
lrwxrwxrwx 1 root root      85 May 17  2016 make_tfam.pyc -> /usr/lib/python2.6/site-packages/birdsuite-1.0-py2.5.egg/plink_pipeline/make_tfam.pyc
lrwxrwxrwx 1 root root      84 May 17  2016 make_tped.py -> /usr/lib/python2.6/site-packages/birdsuite-1.0-py2.5.egg/plink_pipeline/make_tped.py
lrwxrwxrwx 1 root root      85 May 17  2016 make_tped.pyc -> /usr/lib/python2.6/site-packages/birdsuite-1.0-py2.5.egg/plink_pipeline/make_tped.pyc
-rwxr-xr-x 1 root root 5831858 May 17  2016 plink*
lrwxrwxrwx 1 root root      93 May 17  2016 remove_common_cnvs.py -> /usr/lib/python2.6/site-packages/birdsuite-1.0-py2.5.egg/plink_pipeline/remove_common_cnvs.py
lrwxrwxrwx 1 root root      94 May 17  2016 remove_common_cnvs.pyc -> /usr/lib/python2.6/site-packages/birdsuite-1.0-py2.5.egg/plink_pipeline/remove_common_cnvs.pyc
-rw----r-x 1 root root      23 May 17  2016 test.map*
-rw-r--r-x 1 root root     138 May 17  2016 test.ped*
