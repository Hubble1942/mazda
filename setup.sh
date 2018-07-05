#!/bin/bash

function ensure {
    hash $1 2>/dev/null || { sudo apt-get -y install $2 $3 $4 $5; }
}

# install some packages if they're not already there
ensure hg mercurial

# get this scripts location
ROOT_DIR=$( cd "$( dirname "$0" )" && pwd )


# enable * matches dot-files as well
shopt -s dotglob

cp -asf $ROOT_DIR/home/* ~/
