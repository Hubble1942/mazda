#!/bin/bash

# get this scripts location
ROOT_DIR=$( cd "$( dirname "$0" )" && pwd )

#ln -s -f $ROOT_DIR/home/.bashrc ~/.bashrc

# enable * matches dot-files as well
shopt -s dotglob
for FILE_PATH in $ROOT_DIR/home/*; do
    FILE_NAME=$(basename "$FILE_PATH")
    ln -s -f $FILE_PATH ~/$FILE_NAME
done
