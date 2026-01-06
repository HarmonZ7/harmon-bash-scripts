#!/bin/bash

#mac version for presentation

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



#linux adaptation

#if command -v apt >/dev/null 2>&1
#then
#    echo "Updating packages..."
#    sudo apt update && sudo apt upgrade -y | tee "$LOGFILE"
#else
#    echo "Package manager not found. Install it and retry." >&2
#    exit 1
#fi

#echo "Update complete. Log saved to $LOGFILE"