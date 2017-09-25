#!/bin/bash

#set -u #Do not let us use undeclared variables
#set -e #Break on errors

A2C2SCRIPT="yes"    # This lets us find out if this header has been sourced already

STRIKETHROUGH="\033[0;09;40m"
INVERSE="\033[0;07;40m"
UNDERLINE="\033[0;04m"
SETRED="\033[1;31m"
SETGREEN="\033[1;32m"
SETBLUE="\033[1;34m"
SETYELLOW="\033[1;33m"
RESETCOLOR="\033[m"

unset inverse
inverse()
{
    echo -n -e "$INVERSE"
}

unset setgreen
setgreen ()
{
    echo -n -e "$SETGREEN"
}

unset setred
setred ()
{
    echo -n -e "$SETRED"
}

unset setyellow
setyellow ()
{
    echo -n -e "$SETYELLOW"
}

unset setblue
setblue()
{
    echo -n -e "$SETBLUE"
}

unset resetcolor
resetcolor ()
{
    echo -n -e "$RESETCOLOR"
}

unset strikethrough
strikethrough()
{
    echo -n -e "$STRIKETHROUGH"
}

unset underline
underline ()
{
    echo -n -e "$UNDERLINE" 
}

echo-green ()
{
    setgreen
    echo -e "$@"
    resetcolor
}

echo-red ()
{
    setred
    echo -e "$@"
    resetcolor
}

echo-yellow ()
{
    setyellow
    echo -e "$@"
    resetcolor
}

echo-blue ()
{
    setblue
    echo -e "$@"
    resetcolor
}

echo-underline()
{
    underline
    echo -e "$@"
    resetcolor
}

echo-inverse()
{
    inverse
    echo -e "$@"
    resetcolor
}

check_for_errors ()
{
    if [ $? -ne 0 ] ; then
        echo-red "\nError found, aborting\n"
        exit 1
    else
        echo-green "\nNo errors reported\n"
    fi
}

error_check ()
{
    if [ $? -ne 0 ] ; then
        echo-red "\nError found, aborting\n"
        exit 1
    else
        echo-green "\nNo errors reported\n"
    fi
}

pipe_error_check()
{
    ERROR_RETURN=${PIPESTATUS[0]}

    if [ $ERROR_RETURN -ne 0 ] ; then
        echo-red "\nError code $ERROR_RETURN\n"
        exit 1
    else
        echo-green "\nNo errors reported\n"
    fi
}

rpmq ()
{
    rpm -q $1 | grep -v "package $1 is not installed"
}

rpminstall ()
{
    PACKAGENAME="$(echo $1 | sed 's/\.rpm$//g')"
    echo-yellow -n "\nRPM: "
    echo-green "$PACKAGENAME"

    if [ ! "$(rpmq $PACKAGENAME)" ] ; then
        echo ""
        rpm -Uvh $BASEPATH/packages/$PACKAGENAME.rpm

        if [ $? -ne 0 ] ; then
            echo-red "\nError installing $PACKAGENAME\n"
        fi
    else
        echo "Already installed"
    fi

}

rpmforceinstall ()
{
    PACKAGENAME="$(echo $1 | sed 's/\.rpm$//g')"
    echo-green "\n$PACKAGENAME"

    if [ ! "$(rpmq $PACKAGENAME)" ] ; then
        rpm -Uvh --force --nodeps $BASEPATH/packages/$PACKAGENAME.rpm

        if [ $? -ne 0 ] ; then
            echo-red "\nError installing $PACKAGENAME\n"
        fi
    else
        echo "Already installed"
    fi

}

rpmuninstall ()
{
    PACKAGENAME="$(echo $1 | sed 's/\.rpm$//g')"
    echo-red "\nREMOVING $PACKAGENAME\n"

    if [ "$(rpmq $PACKAGENAME)" ] ; then
        rpm -ev $PACKAGENAME

        if [ $? -ne 0 ] ; then
            echo-red "\nError uninstalling $PACKAGENAME\n"
        fi
    else
        echo-yellow "\tPackage $PACKAGENAME not on system\n"
    fi

}

rpmforceuninstall ()
{
    PACKAGENAME="$(echo $1 | sed 's/\.rpm$//g')"
    echo-red "\nREMOVING $PACKAGENAME\n"

    if [ "$(rpmq $PACKAGENAME)" ] ; then
        rpm -ev --nodeps $PACKAGENAME

        if [ $? -ne 0 ] ; then
            echo-red "\nError uninstalling $PACKAGENAME\n"
        fi
    else
        echo-yellow "\tPackage $PACKAGENAME not on system\n"
    fi

}

yuminstall ()
{
    echo-yellow -n "\nYUM-INSTALL: "
    echo-green "$1"

    if [ ! "$(rpmq $1)" ] ; then
        echo ""
        yum -y install $@

        if [ $? -ne 0 ] ; then
            echo-red "\nError installing $1\n"
        fi
    else
        echo "Already installed"    
    fi
    echo ""

}

yumremove ()
{
    echo-red "\nREMOVING $1"

    if [ "$(rpmq $1)" ] ; then
        yum -y remove $1

        if [ $? -ne 0 ] ; then
            echo-red "\nError uninstalling $1\n"
        fi
    else
        echo-yellow "\tPackage $1 not on system\n"
    fi
}

yumupdate ()
{
    echo-yellow -n "\nYUM-UPDATE: "
    echo-green "$1"

    if [ "$(rpmq $1)" ] ; then
        echo ""
        yum -y update $@

        if [ $? -ne 0 ] ; then
            echo-red "\nError updating $1\n"
        fi
    else
        echo-yellow "Package not on system, cannot update\n"
    fi
    echo ""

}

yumforceupdate()
{
    echo-yellow -n "\nYUM-UPDATE: "
    echo-green "$1"

    yum -y update $@

    if [ $? -ne 0 ] ; then
        echo-red "\nError updating $1\n"
    fi
    echo ""
}

# Don't let us run on splinter
if [ "$(hostname -s)" = "splinter" ] ; then
    echo-red "\nDo not try to build on splinter\n"
    exit 1
fi

# Don't let us run this on a system that isn't running Centos 6.x

if [ $OSMAJORVER -ne 6 ] ; then
    echo-red "\nThis system is running:\n"
    echo-red "$(cat /etc/redhat-release)\n"
    echo-red "This script only runs on 6.x versions\n"
    exit 1
fi


