#!/bin/bash

#
# packlibs.sh - Shared Library Packaging Script (Arch Linux)
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
    echo 'Usage: packlibs.sh [<name>]...'
    exit 1
fi



#
# MAIN SCRIPT
#

# The arguments passed to this script should specify the libraries to build, for
# example:
#
#     ./packlibs.sh exec
#
for libstr in "$@"
do
    lib_dir="${SCRIPTDIR}/${libstr}"
    export LOGDEST="${CURDIR}"
    export PKGDEST="${CURDIR}"

    if [[ ! -d "${lib_dir}" ]]
    then
        echo "Can't find library source package: ${libstr}."
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
    cd "${lib_dir}"
    makepkg --syncdeps --clean --cleanbuild --noconfirm --log --force

    if [[ $? -gt 0 ]]
    then
	echo -n "Build with makepkg failed for ${libstr}, "
	echo see $(ls "${LOGDEST}" | grep log | tr '\n' ' ' | sed -e 's/ / and /g') for output.
        continue
    fi
    
    cd "${CURDIR}"
    echo "Built lib${libstr}."
done

echo "Packaging complete."
