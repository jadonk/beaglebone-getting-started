#!/bin/sh
set -x
set -e
cd $(dirname $0)/..
DIR=`pwd`

rm $DIR/app/Linux/beaglebone-getting-started
rm $DIR/app/MacOSX/beaglebone-gettig-started.app/Contents/Resources/app.nw
rm $DIR/app/Windows/beaglebone-getting-started.exe
