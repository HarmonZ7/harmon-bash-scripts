#!/bin/bash

set -euo pipefail

USERNAME="$1"

#ensure a username is provided
if [[ -z "$USERNAME" ]]
then
    echo "Proper usage: $0 <username>" >&2
    exit 1
fi

#ensure script is ran as root
if [[ $EUID -ne 0 ]]
then
    echo "This script must be run as root (or sudo)." >&2
    exit 2
fi

#make sure user exists
if ! dscl . -read /Users/"$USERNAME" &>/dev/null
then
    echo "User '$USERNAME' does not exist." >&2
    exit 3
fi

#confirm deletion
read -p "Are you sure you want to delete user: '$USERNAME' and their home directory? (yes/no): " CONFIRM
if [[ "$CONFIRM" != "yes" ]]
then
    echo "User deletion cancelled."
    exit 0
fi

#code for deleting user, remove from any groups, their record, directory, and user

#removing from groups
if dscl . -read /Groups/dev_group &>/dev/null
then 
    sudo dscl . -delete /Groups/dev_group GroupMembership "$USERNAME" || true
fi

#deleting user records
echo "Deleting user '$USERNAME'..."
sudo dscl . -delete /Users/"$USERNAME"

#deleting home directory
if [[ -d "/Users/$USERNAME" ]]
then
    echo "Removing home directory /Users/$USERNAME..."
    sudo rm -rf "/Users/$USERNAME"
fi

#verify the deletion
if ! dscl . -read /Users/"$USERNAME" &>/dev/null
then
    echo "User '$USERNAME' successfully deleted."
else
    echo "Error: User '$USERNAME' still exists." >&2
    exit 4
fi

echo "====== /etc/passwd requirement (lines matching $USERNAME) ======"
dscl . -read /Users/$USERNAME | grep -E "RealName|UniqueID|UserShell|NFSHomeDirectory"
echo
echo "User '$USERNAME' successfully created."

exit 0