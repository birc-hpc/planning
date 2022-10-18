#!/bin/bash

mkdir results-$( date +%F )
cp $( cat important.txt ) results-$( date +%F )
tar -czf results-$( date +%F ).tar.gz results-$( date +%F )
rm -r results-$( date +%F )
cp results-$( date +%F ).tar.gz backup
