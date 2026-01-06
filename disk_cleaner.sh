#!/bin/bash

#safety code to catch common errors
set -euo pipefail

#storing our available disk space in initial space
initial_space=$(df -h | awk 'NR==2 {print $4}')

echo "Initial free disk space: $initial_space"

#function to delete contents of a directory
cleanDir() {
    dir="$1"
    echo "Cleaning directory: $dir"

    #making sure directory exists
    if [[ -d "$dir" ]]
    then
        rm -rf "${dir:?}/"*
        echo "Cleaned: $dir"
    else
        echo "Directory not found: $dir"
    fi

}

#these are the directories to be deleted
dirs_to_clean=("/var/log" "$HOME/.cache" "$HOME/.Trash")

#loop through all directories and delete them using our function
for dir in "${dirs_to_clean[@]}"
do
    cleanDir "$dir"
done

#finding our disk space after cleaning
final_space=$(df -h / | awk 'NR==2 {print $4}')

echo "Final free disk space: $final_space"

if [[ "$initial_space" = "$final_space" ]]
then
    echo "No significant disk space was freed"
else
    echo "Cleaning completed. Disk space increased."
fi

exit 0
