#!/bin/bash

files=$(find . -maxdepth 1 -type f)
mentions=$(grep $(whoami) $files | wc -l)

if (( mentions > 10 ))
then
    echo "I should be making that influencer big bucks!"
elif (( mentions > 5 ))
then
    echo "Ok, at least I'm more popular than Dan Søndergaard"
elif (( mentions > 0 ))
then
    echo "At least my mother cares..."
else
    echo "No one cares about me!"
fi

