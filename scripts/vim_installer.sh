#!/bin/bash
# Name: vim_installer.sh
#
# Description: Installs vim, if not installed already

# Usage: ./vim_installer.sh
#
# Requirements: None
#
# Exit Codes:
#   - 0: success
#   - 1: Fail if Vim is already installed.

#safety code to fail script if common errors occur
set -euo pipefail

#checking if vim is installed already
if command -v vim >/dev/null 2>&1
then
    echo "Vim is already installed. Closing script..."
    exit 1
else
    echo "Vim not found. Installing with Homebrew..."
    #checking if homebrew is already installed
    if ! command -v brew >/dev/null 2>&1
    then
        echo "Homebrew not found. Please install homebrew and retry."
    fi
    #installing vim
    brew install vim
    echo "Successfully installed vim"
fi

exit 0