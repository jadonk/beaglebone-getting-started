#!/bin/sh
set -x
set -e
cd $(dirname $0)/..
DIR=`pwd`

rm $DIR/app/Linux/nw
rm $DIR/app/Windows/nw.exe
