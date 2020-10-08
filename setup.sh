#!/bin/bash

# get this scripts location
ROOT_DIR=$( cd "$( dirname "$0" )" && pwd )

# enable * matches dot-files as well
shopt -s dotglob

cp -asf $ROOT_DIR/home/* ~/
