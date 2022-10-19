#!/bin/bash

# Function for showing usage
function usage() {
    echo "Usage: $0
          -h              display help
          -d directory    set working directory
          -i file         file containing files to backup
          -b directory    where to backup
    "
    exit
}

# Function for showing help (shorter usage)
help() {
    echo "Tool for backing up important files.

Will create a tarbal with important files, with a date stamp,
and copy it to a directory of your choice.
    
    -d directory
    Set in which directory to run
    
    -i file
    Specify in which file we can get the list of what
    to back up.
    
    -b directory
    Specify in which directory we should place the backup
    "
    exit
}

# Parsing options
while getopts hd:i:b: flag; do # get one option at a time
    case $flag in
        h) # -h flag
            help  # Display help message and exit
            ;;

        d) # -d flag
            dir=$OPTARG
            ;;

        i) # -i flag
            important_file=$OPTARG 
            ;;

        b) # -b flag
            backup=$OPTARG
            ;;

        ?) # anything else
            usage  # is an error, so show usage and stop
            ;;
    esac # end of case
done

# Set variables to default if they are not set by now
dir=${dir:-$PWD}
important_file=${important_file:-${dir}/important.txt}
backup=${backup:-${dir}/backup}

# Now run the backup ######################

# Get the current date
date=$( date +%F )

# Go to the directory we should work in
cd $dir 2> /dev/null || echo "Cannot go to $dir" && exit

# Collect files, zip them up, and save a backup
[ -d results-$date ] || mkdir results-$date
cp $( cat $important_file ) results-$date
tar -czf results-$date.tar.gz results-$date
rm -r results-$date
[ -d $backup ] || mkdir $backup
cp results-$date.tar.gz $backup
