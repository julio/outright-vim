#!/bin/bash
DIRECTORY=$(cd `dirname $0` && pwd)
if [ ! -e ~/.vimrc ]
then
  ln -s $DIRECTORY/vimrc ~/.vimrc
fi
