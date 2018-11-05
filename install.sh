#!/bin/bash
FILENAME=$1
DEST=$HOME/$FILENAME
cp $DEST $DEST.old
rm $DEST
ln -s $PWD/$FILENAME $DEST
echo Installed $FILENAME to $DEST
