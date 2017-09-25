#!/bin/bash
# -*- coding: utf-8 -*-
# Author: Pär Andersson (National Supercomputer Centre, Sweden)
# Version: 0.3 2007-07-30
#
# This will submit a batch script that starts screen on a node.
# Then ssh is used to connect to the node and attach the screen.
# The result is very similar to an interactive shell in PBS
# (qsub -I)

# Path to where all our associated scripts live
SCRIPTPATH=/packages/sysadmin/$CLUSTERNAME/scripts
# Batch Script that starts SCREEN
BS=$SCRIPTPATH/_interactive
# Interactive screen script
IS=$SCRIPTPATH/_interactive_screen

# Submit the job and get the job id
JOB=`sbatch -n 1 --time=24:00:00 -p serial --output=/dev/null --error=/dev/null $@ $BS 2>&1 | egrep -o -e "\b[0-9]+$"`

# Make sure the job is always canceled
trap "{ /usr/bin/scancel $JOB; exit; }" SIGABRT SIGHUP SIGINT SIGKILL SIGQUIT SIGTERM EXIT

echo "Waiting for JOBID $JOB to start"
while true;do
    sleep 5s

    # Check job status
    STATUS=`squeue -j $JOB -t PD,R -h -o %t`

    if [ "$STATUS" = "R" ];then
        # Job is running, break the while loop
        break
    elif [ "$STATUS" != "PD" ];then
        echo "Job is not Running or Pending. Aborting"
        scancel $JOB
        exit 1
    fi

    echo -n "."

done

# Determine the first node in the job:
NODE=`srun --jobid=$JOB -N1 hostname`

# SSH to the node and attach the screen
sleep 1s
ssh -X -t $NODE $IS slurm$JOB
# The trap will now cancel the job before exiting.

##############################################
# _interactive
#!/bin/bash
# -*- coding: utf-8 -*-
# Author: Pär Andersson  (National Supercomputer Centre, Sweden)
# Version: 0.2 2007-07-30
#
# Simple batch script that starts SCREEN.

exec screen -Dm -S slurm$SLURM_JOB_ID

##############################################
# _interactive_screen
#!/bin/sh
# -*- coding: utf-8 -*-
# Author: Pär Andersson  (National Supercomputer Centre, Sweden)
# Version: 0.3 2007-07-30
#

SCREENSESSION=$1

# If DISPLAY is set then set that in the screen, then create a new
# window with that environment and kill the old one.
if [ "$DISPLAY" != "" ];then
    screen -S $SCREENSESSION -X unsetenv DISPLAY
    screen -p0 -S $SCREENSESSION -X setenv DISPLAY $DISPLAY
    screen -p0 -S $SCREENSESSION -X screen
    screen -p0 -S $SCREENSESSION -X kill
fi

exec screen -S $SCREENSESSION -rd
