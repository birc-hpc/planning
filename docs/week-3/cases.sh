#!/bin/bash

filetypes="textfiles scripts unknown"

for filename in *
do
    case $filename in
        *.txt | *.md) textfiles="$textfiles $filename" ;;
        *.sh | *.py | *.r | *.R) scripts="$scripts $filename" ;;
        *) unknown="$unknown $filename" ;;
    esac
done

for filetype in $filetypes
do
    echo ${filetype}
    # Get the var name from $filetype, e.g. scripts, then
    # get the values in that var, e.g. $scripts.
    files_of_type=${!filetype}
    for filename in files_of_type; do
        echo " - $filename"
    done
    echo # newline
done