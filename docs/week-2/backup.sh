#!/bin/bash

function read_conf() {
    # Function will source conf.sh if
    # it exists. Its return status
    # depend on whether we succeeded
    [ -f conf.sh ] && source conf.sh
}

function report_conf_error() {
    echo "Couldn't open conf.sh!"
    exit 1  # Exiting 1 means we are not claiming success
}

# Get the environmment from conf.sh
read_conf || report_conf_error

# Now run the backup ######################
date=$( date +%F )
[ -d results-$date ] || mkdir results-$date
cp $( cat $important_file ) results-$date
tar -czf results-$date.tar.gz results-$date
rm -r results-$date
[ -d $backup ] || mkdir $backup
cp results-$date.tar.gz $backup
