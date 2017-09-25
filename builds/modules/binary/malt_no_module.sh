#!/bin/bash

# set env variables
source /packages/6x/build/header.source

2>&1 | tee $BUILDDIR/_test_out
pipe_error_check

/packages/6x/malt/0.3.8
/packages/7x/malt/0.3.8

/packages/6x/build/malt/0.3.8/malt

/packages/6x/malt/0.3.8/bin






#%Module1.0

if { [module-info mode load] && [regexp {ocotillo|saguaro} [uname nodename]] } {

	puts stderr "##############################################"
	puts stderr "# How to use:"
	puts stderr "##############################################"
	puts stderr ""
	puts stderr "MALT MAX MEMORY SET TO 24GIG"
	puts stderr "request 24gigs in the following way:"
	puts stderr ""
	puts stderr "interactive -N 1 -n 8"
	puts stderr "OR with sbatch options:"
	puts stderr "#SBATCH -N 1"
	puts stderr "#SBATCH -n 8"
	puts stderr ""
	puts stderr "MALT executables:"
	puts stderr "malt-run"
	puts stderr "malt-build"
	puts stderr ""
	puts stderr "##############################################"

}

# vim: ft=tcl


: '
This will install MALT on your computer.
OK [o, Enter], Cancel [c]
o
A previous installation has been detected. Do you wish to update that installation?
Yes, update the existing installation [1, Enter]
No, install into a different directory [2]
^C[root@s54-1:/packages/6x/build/malt/0.3.8]# vi build.sh 
[root@s54-1:/packages/6x/build/malt/0.3.8]# bash build.sh 
Starting Installer ...
This will install MALT on your computer.
OK [o, Enter], Cancel [c]
o
Please read the following License Agreement. You must accept the terms of this agreement before continuing with the installation.

MALT - MEGAN ALignment Tool

Copyright (c) 2016, Daniel H. Huson

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.

For more info on this program, see
<http://www-ab3.informatik.uni-tuebingen.de/software/malt/>.

I accept the agreement
Yes [1], No [2]
1
Where should MALT be installed?
[/opt/malt]
/packages/6x/malt/0.3.8
The directory:

/packages/6x/build/malt/0.3.8/malt

already exists. Would you like to install to that directory anyway?
Yes [y, Enter], No [n]
y
Which components should be installed?
1: Manual
2: malt-build
3: malt-run
Please enter a comma-separated list of the selected values or [Enter] for the default selection:
[1,2,3]
1,2,3
Create symlinks?
Yes [y, Enter], No [n]
n
Extracting files ...
                                                                           
Check for updates how often?
Check for updates:
On every start [1]
Daily [2]
Weekly [3]
Monthly [4]
Never [5, Enter]
5
Set maximum allowed memory usage for MALT
Set max memory usage (in gigabytes) [1-1024]
[64]
24
Setup has finished installing MALT on your computer.
Finishing installation ...
'