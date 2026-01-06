#!/bin/bash

#safety code for catching common errors
set -euo pipefail

fileSize() {
    local file="$1"

    if [[ -f "$file" ]]
    then
        stat -f%z "$file"
    else
        echo "0"
    fi
}

#archiving and compressing /etc with gzip
echo "Archiving /etc with gzip..."
sudo tar -czf etc_backup_gzip.tar.gz /etc 2>/dev/null

#archiving and compressing /etc with bzip2
echo "Archiving /etc with bzip2..."
sudo tar -cjf etc_backup_bzip2.tar.bz2 /etc 2>/dev/null

#get file sizes
gzip_size=$(fileSize "etc_backup_gzip.tar.gz")
bzip2_size=$(fileSize "etc_backup_bzip2.tar.bz2")

#print archive size's in a more human readable format
echo "gzip archive size: $(du -h etc_backup_gzip.tar.gz | awk '{print $1}')"
echo "bzip2 archive size: $(du -h etc_backup_bzip2.tar.bz2 | awk '{print $1}')"

#finding the difference between sizes
if (( gzip_size > bzip2_size ))
then
    diff=$((gzip_size - bzip2_size))
    echo "bzip2 is smaller by $diff bytes."
elif (( bzip2_size > gzip_size ))
then
    diff=$((bzip2_size - gzip_size))
    echo "gzip is smaller by $diff bytes."
else
    echo "Both archives are the same size."
fi

exit 0