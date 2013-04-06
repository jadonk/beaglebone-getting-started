#!/bin/sh
set -x
set -e
ZIP=/tmp/$(basename $0).$RANDOM.zip
cd $(dirname $0)/..
DIR=`pwd`

cd $DIR
zip $ZIP -r autorun.inf Docs Drivers info.txt LICENSE.txt START.htm

# Add package.json
cd $DIR/app
zip $ZIP -r package.json

# Make Mac app
rm -f $DIR/app/MacOSX/beaglebone-getting-started.app.zip
cp $ZIP $DIR/app/MacOSX/beaglebone-getting-started.app/Contents/Resources/app.nw

# Make Linux 32-bit app
cat $DIR/app/Linux/nw $ZIP > $DIR/app/Linux/beaglebone-getting-started
chmod +x $DIR/app/Linux/beaglebone-getting-started

# Make Windows .exe
cat $DIR/app/Windows/nw.exe $ZIP > $DIR/app/Windows/beaglebone-getting-started.exe

# Clean-up
rm -f $ZIP
