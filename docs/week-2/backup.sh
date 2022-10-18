#!/bin/bash

# Get the current date
date=$( date +%F )

# Collect files, zip them up, and save a backup
mkdir results-$date
cp $( cat important.txt ) results-$date
tar -czf results-$date.tar.gz results-$date
rm -r results-$date
cp results-$date.tar.gz backup
