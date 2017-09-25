#!/bin/bash

cat <<EOF > header.source
#!/bin/bash

RESETCOLOR="\033[m"
SETYELLOW="\033[1;33m"
SETRED="\033[1;31m"


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

unset resetcolor
resetcolor ()
{
    echo -n -e "$RESETCOLOR"
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
EOF
