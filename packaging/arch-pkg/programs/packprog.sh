#!/bin/bash

#
# packprog.sh - Program Packaging Script (Arch Linux)
#
# This source-code is part of Windows XP stuff for XFCE:
# <<https://www.oddmatics.uk>>
#
# Author(s): Rory Fewell <roryf@oddmatics.uk>
#

#
# CONSTANTS
#
CURDIR=`realpath -s "./"`
SCRIPTDIR=`dirname "$0"`



#
# PRE-FLIGHT CHECKS
#
makepkg --version 1>/dev/null 2>&1

if [[ $? -gt 0 ]]
then
    echo "makepkg not found! Make sure this is Arch Linux!"
    exit 1
fi



#
# ARGUMENTS
#
if [[ $# -eq 0 ]]
then
    echo 'Usage: packprog.sh [<name>]...'
    exit 1
fi



#
# MAIN SCRIPT
#

# The arguments passed to this script should specify the program to build, for
# example:
#
#     ./packprog.sh shell/start windows/paint
#
for progstr in "$@"
do
    prog_safename=$(sed 's/^[^\/]*\///' <<< "${progstr}")
    prog_dir="${SCRIPTDIR}/${prog_safename}"
    export LOGDEST="${CURDIR}"
    export PKGDEST="${CURDIR}"

    if [[ ! -d "${prog_dir}" ]]
    then
        echo "Can't find program source package: ${progstr}."
        exit 1
    fi

    ls "${LOGDEST}/"*.log* 1>/dev/null 2>&1

    if [[ $? -eq 0 ]]
    then
        rm -f "${LOGDEST}/"*.log*

        if [[ $? -gt 0 ]]
        then
            echo "Failed to delete logs, skipping build."
            continue
        fi
    fi

    # Enter the source package directory and execute makepkg, which automatically 
    # installs dependencies and builds the package
    #
    cd "${prog_dir}"
    makepkg --syncdeps --clean --cleanbuild --noconfirm --log --force

    if [[ $? -gt 0 ]]
    then
	echo -n "Build with makepkg failed for ${progstr}, "
	echo see $(ls "${LOGDEST}" | grep log | tr '\n' ' ' | sed -e 's/ / and /g') for output.
        continue
    fi
    
    cd "${CURDIR}"
    echo "Built ${progstr}."
done

echo "Packaging complete."
