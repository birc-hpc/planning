#!/bin/bash

file_globs=""
[ -f *.txt ] && file_globs="*.txt ${file_globs}"
[ -f *.md ] && file_globs="*.md ${file_globs}"

if me_files=$(grep -l $(whoami) $file_globs);
then
    echo "I am mentioned in: ${me_files}"
else
    echo "No one cares about me!"
fi

