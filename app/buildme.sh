#! /bin/bash


# 2 part application idea:
rcmodbuilder [input]  	# a python cli (click?!?)
	input:     			# not sure what this would look like at this point
		os_image 		- 6x or 7x
		package name 	- the external given name will be used to search for
							existing packages in the build directory
		module name 	- the internal name rc will use to within the module 
							system, will be used to search for existing packages
							in the build directory AND in the modules directories
		version 		- what version of software is being added to the module
							system.
		configfile		- used after the init command to allow other commands
							to have a state.

	commands:
		init 			- will initiate a new module based on the values passed
							into the command
		rollback		- will print to standard out all steps to rollback a 
							deployed module not sure if we will want this to be
							automated...
		build 			- the command that is run AFTER the software has passed
							the build tests, or whatever was given.  This might
							just take in a shell script to run.  OR you just

buildme.sh 
	no input

# The following are the

# an example of the location where the module-env files need to be...
/packages/sysadmin/environment_modules/modulefiles/penncnv
