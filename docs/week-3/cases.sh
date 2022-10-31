#!/bin/bash

filename=$1

case $filename in
    *.txt | *.md)
        echo "$filename is a text file"
        ;;
    *.sh | *.py | *.r | *.R)
        echo "$filename is a script"
        ;;
    *)
        echo "I don't know what $filename is"
        ;;
esac
