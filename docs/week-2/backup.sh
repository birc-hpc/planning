#!/bin/bash

# Variable $1 is the first argument. If it isn't set,
# we will use the working directory (which we get from $PWD)
work_dir=${1:-${PWD}}

# Variable $2 is the second argument. If it isn't set,
# we use 'important.txt' as default.
important_file=${2:-important.txt}

# Variable $3 is the tird argument. If it isn't set,
# we use 'backup' as default.
backup=${3:-backup}


# Get the current date
date=$( date +%F )

# Collect files, zip them up, and save a backup
mkdir results-$date
cp $( cat $important_file ) results-$date
tar -czf results-$date.tar.gz results-$date
rm -r results-$date
mkdir -p $backup && cp results-$date.tar.gz $backup
