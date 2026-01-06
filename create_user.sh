#!/bin/bash
#usage: ./create_user.sh username password

#safety code to help catch errors
set -euo pipefail

#ensure the user is running as the root
if [[ $EUID -ne 0 ]]
then
    echo "This script must be run as root (or sudo)." >&2
    exit 2
fi

#ensures atleast a username was provided
if [[ $# -lt 1 ]]
then
    echo "Usage: $0 username [password]" >&2
    exit 1
fi

#assigned username and password variables
USERNAME="$1"
PASSWORD="${2:-}"


if [[ -z "$USERNAME" ]]
then
    echo "$USERNAME is an invalid username." >&2
    exit 5
fi

#ensure dev_group exists and creates it if not
if ! dscl . -read /Groups/dev_group &>/dev/null
then
    echo "Group dev_group does not exist... creating now..."
    dscl . -create /Groups/dev_group
else
    echo "Group dev_group already exists."
fi 

#add the user and assign it to the dev_group
if id -u "$USERNAME" >/dev/null 2>&1
then
    echo "User $USERNAME already exists." >&2
    exit 3
fi

#prompting the user to create a password if it wasn't an argument
if [[ -z "$PASSWORD" ]]
then
    echo "Please enter password for $USERNAME:"
    read -s PASS1
    echo
    echo "Confirm password: "
    read -s PASS2
    echo
    if [[ "$PASS1" != "$PASS2" ]]
    then
        echo "Passwords do not match." >&2
        dscl . -delete /Users/$USERNAME || true
        rm -rf /Users/$USERNAME
        exit 4
    fi
    PASSWORD="$PASS1"
fi

#creating the user
echo "Creating user $USERNAME"
sysadminctl -addUser "$USERNAME" -password "$PASSWORD" -home /Users/"$USERNAME" -shell /bin/bash
createhomedir -c -u "$USERNAME" > /dev/null 2>&1
dscl . -append /Groups/dev_group GroupMembership "$USERNAME"
echo "Granting secure token to $USERNAME..."
sysadminctl -secureTokenOn "$USERNAME" -password "$PASSWORD" interactive

#force password change on first login
pwpolicy -u "$USERNAME" -setpolicy "newPasswordRequired=1"

echo "Password set, user will be prompted to change it on first login."

#verifies user creation by checking /etc/passwd
echo "====== /etc/passwd requirement (lines matching $USERNAME) ======"
dscl . -read /Users/$USERNAME | grep -E "RealName|UniqueID|UserShell|NFSHomeDirectory"
echo
echo "User '$USERNAME' successfully created."
exit 0