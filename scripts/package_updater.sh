#!/bin/bash
# Name: package_updater.sh
#
# Description: Linux and Mac versions. Updates homebrew and/or installed packages and saves results to a log file.
#
# Usage: ./package_updater.sh
#
# Requirements: None
#
# Exit Codes:
#   - 0: success
#   - 1: Fail if homebrew/package manager is not installed.


#safety code to catch errors
set -euo pipefail

LOGFILE="update.log"

if command -v brew >/dev/null 2>&1
then
    echo "Updating Homebrew and installed packages"
    { brew update && brew upgrade; } | tee "$LOGFILE"
    echo "All packages updated successfully. Log saved to $LOGFILE"
else
    echo "Homebrew not found. Install it and retry." >&2
    exit 1
fi



#linux version

#if command -v apt >/dev/null 2>&1
#then
#    echo "Updating packages..."
#    sudo apt update && sudo apt upgrade -y | tee "$LOGFILE"
#else
#    echo "Package manager not found. Install it and retry." >&2
#    exit 1
#fi

#echo "Update complete. Log saved to $LOGFILE"