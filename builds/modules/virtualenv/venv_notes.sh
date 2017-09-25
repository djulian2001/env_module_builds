#!/bin/bash
#Process for leveraging perls virutalenv:

#1) make sure that the App::Virtualenv is installed into the perl module loaded....

vi bootstrap_perl.sh <EOF
#!/bin/bash

module load perl/x.x.x

cpan -i App::Virtualenv

EOF


#2) In the build directory create the build.sh file

vi build.sh <EOF
#!/bin/bash

source /packages/6x/build/header.source

module purge

osprefix="6x"
module="module"
version="version"
perl_version="version"
# build variables
build_dir="/packages/$osprefix/build/$module/$version"
source_file="$build_dir/meme_4.11.4_1.tar.gz"
source_dir="$build_dir/meme_4.11.4"
# install variables
install_dir="/packages/$osprefix/$module/$version"
perl_virtualenv_dir="$install_dir/lib.venv.pl.d/$perl_version"

if [ -d "$source_dir" ]; then
  rm -rf "$source_dir"
fi

if [ -d "$perl_virtualenv_dir" ]; then
  rm -rf "$perl_virtualenv_dir"
fi

if [ ! -d "$install_dir" ]; then
  mkdir -p "$install_dir"
fi

mkdir -p "$perl_virtualenv_dir"

echo-yellow "Setup perl Virtualenv....."
module load perl/$perl_version
perl -MApp::Virtualenv -erun -- "$perl_virtualenv_dir"

# sets the enviornment so modules will be installed into the 
source "$perl_virtualenv_dir/bin/activate"

echo-yellow "Install perl module dependencies....."
perl_out_dir="$build_dir/_perl_deps.out.d"
mkdir 
echo-yellow "install Module::Object"
cpan -i Module::Object 2>&1 | tee "$build_dir/ "
# OR
# whatever the software distributed to setup the perl scripts with... 

echo-yellow "Cleaning up the enviornment....."
# perl env clean
deactivate
module purge

EOF

NOTE: a better way to test module install, isolate the issues:
	perl_out_dir="$build_dir/_perl_deps.d"
	mkdir "$perl_out_dir"
	echo-yellow "Install HTML::Template dependency....."
	cpan -i  HTML::Template 2>&1 | tee $perl_out_dir/_HTML_Template.out
	pipe_error_check

	echo-yellow "Install HTML::TreeBuilder dependency....."
	cpan -i  HTML::TreeBuilder 2>&1 | tee $perl_out_dir/_HTML_TreeBuilder.out
	pipe_error_check

	echo-yellow "Install XML::Parser dependency....."
	cpan -i  XML::Parser 2>&1 | tee $perl_out_dir/_XML_Parser.out
	pipe_error_check

	echo-yellow "Install XML::Parser::Expat dependency....."
	cpan -i  XML::Parser::Expat 2>&1 | tee $perl_out_dir/_XML_Parser_Expat.out
	pipe_error_check

	echo-yellow "Install XML::Simple dependency....."
	cpan -i  XML::Simple 2>&1 | tee $perl_out_dir/_XML_Simple.out
	pipe_error_check

	echo-yellow "Install XML::Compile::SOAP11 dependency....."
	cpan -i  XML::Compile::SOAP11 2>&1 | tee $perl_out_dir/_XML_Compile_SOAP11.out
	pipe_error_check

	echo-yellow "Install XML::Compile::WSDL11 dependency....."
	cpan -i  XML::Compile::WSDL11 2>&1 | tee $perl_out_dir/_XML_Compile_WSDL11.out
	pipe_error_check

	echo-yellow "Install XML::Compile::Transport::SOAPHTTP dependency....."
	cpan -i  XML::Compile::Transport::SOAPHTTP 2>&1 | tee $perl_out_dir/_XML_Compile_Transport_SOAPHTTP.out
	pipe_error_check

	echo-yellow "Install XML::LibXML::SAX dependency....."
	cpan -i  XML::LibXML::SAX 2>&1 | tee $perl_out_dir/_XML_LibXML_SAX.out
	pipe_error_check

	echo-yellow "Install Log::Log4perl dependency....."
	cpan -i  Log::Log4perl 2>&1 | tee $perl_out_dir/_Log_Log4perl.out
	pipe_error_check

	echo-yellow "Install Math::CDF dependency....."
	cpan -i  Math::CDF 2>&1 | tee $perl_out_dir/_Math_CDF.out
	pipe_error_check


#3) Now to build the module file....
first we need to get a dump of the enviornments before / after
using the intel 2015.3 as our base example

<EOF
module load perl/version

env > /packages/6x/build/meme/4.11.4/_env_before.out

source "$perl_virtualenv_dir/bin/activate"

env > /packages/6x/build/meme/4.11.4/_env_after.out

colordiff _env_before.out _env_after.out > _env_diff.out

EOF
# examples from intel/2015.3 modulefile
prepend-path    CPATH               /packages/$osprefix/intel/2015.3/composer_xe_2015.3.187/mkl/include

prepend-path    LD_LIBRARY_PATH     /packages/$osprefix/intel/2015.3/composer_xe_2015.3.187/debugger/libipt/intel64/lib

# for meme
prepend-path	PERL5LIB			/packages/6x/meme/4.11.4/lib.venv.pl.d/5.26.0/lib/perl5
prepend-path 	PERL_MB_OPT			--install_base "/packages/6x/meme/4.11.4/lib.venv.pl.d/5.26.0"
prepend-path 	PATH 				/packages/6x/meme/4.11.4/lib.venv.pl.d/5.26.0/bin
prepend-path 	PERL_LOCAL_LIB_ROOT	/packages/6x/meme/4.11.4/lib.venv.pl.d/5.26.0
prepend-path 	PERL_MM_OPT 		INSTALL_BASE=/packages/6x/meme/4.11.4/lib.venv.pl.d/5.26.0
prepend-path 	PS1					(5.26.0) [\u@\h:\w]\$
prepend-path 	PERL_VIRTUAL_ENV	/packages/6x/meme/4.11.4/lib.venv.pl.d/5.26.0


prepend-path   _OLD_PERL_VIRTUAL_PATH	$PATH

prepend-path 	_OLD_PERL_VIRTUAL_PATH /packages/6x/perl/5.26.0:/packages/6x/perl/5.26.0/bin:/usr/lib64/qt-3.3/bin:/packages/scripts:/usr/kerberos/sbin:/usr/kerberos/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/opt/ibutils/bin:/packages/sysadmin/saguaro/scripts/:/opt/dell/toolkit/bin:/packages/6x/perl5lib/bin:/opt/puppetlabs/bin:/opt/dell/srvadmin/bin:/opt/dell/srvadmin/sbin:/packages/6x/build/mocat2/2.0/mocat2-git/dev/public/src:/root/bin:/packages/6x/build/mocat2/2.0/mocat2-git/dev/public/src

PATH=/packages/6x/perl/5.26.0:/packages/6x/perl/5.26.0/bin:/usr/lib64/qt-3.3/bin:/packages/scripts:/usr/kerberos/sbin:/usr/kerberos/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/opt/ibutils/bin:/packages/sysadmin/saguaro/scripts/:/opt/dell/toolkit/bin:/packages/6x/perl5lib/bin:/opt/puppetlabs/bin:/opt/dell/srvadmin/bin:/opt/dell/srvadmin/sbin:/packages/6x/build/mocat2/2.0/mocat2-git/dev/public/src:/root/bin:/packages/6x/build/mocat2/2.0/mocat2-git/dev/public/src



PATH=
/packages/6x/perl/5.26.0
:/packages/6x/perl/5.26.0/bin
:/usr/lib64/qt-3.3/bin
:/packages/scripts
:/usr/kerberos/sbin
:/usr/kerberos/bin
:/usr/local/sbin
:/usr/local/bin
:/sbin
:/bin
:/usr/sbin
:/usr/bin
:/opt/ibutils/bin
:/packages/sysadmin/saguaro/scripts/
:/opt/dell/toolkit/bin
:/packages/6x/perl5lib/bin
:/opt/puppetlabs/bin
:/opt/dell/srvadmin/bin
:/opt/dell/srvadmin/sbin
:/packages/6x/build/mocat2/2.0/mocat2-git/dev/public/src
:/root/bin
:/packages/6x/build/mocat2/2.0/mocat2-git/dev/public/src


:/packages/6x/perl/5.26.0
:/packages/6x/perl/5.26.0/bin
:/usr/lib64/qt-3.3/bin
:/packages/scripts
:/usr/kerberos/sbin
:/usr/kerberos/bin
:/usr/local/sbin
:/usr/local/bin
:/sbin
:/bin
:/usr/sbin
:/usr/bin
:/opt/ibutils/bin:/packages/sysadmin/saguaro/scripts/:/opt/dell/toolkit/bin:/packages/6x/perl5lib/bin:/opt/puppetlabs/bin:/opt/dell/srvadmin/bin:/opt/dell/srvadmin/sbin:/packages/6x/build/mocat2/2.0/mocat2-git/dev/public/src:/root/bin:/packages/6x/build/mocat2/2.0/mocat2-git/dev/public/src





