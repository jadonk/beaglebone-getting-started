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
rm -f $DIR/app/beaglebone-getting-started.app.zip
cp $ZIP $DIR/app/beaglebone-getting-started.app/Contents/Resources/app.nw
zip $DIR/app/beaglebone-getting-started.app.zip -r $DIR/app/beaglebone-getting-started.app

# Make Linux 32-bit app
cat $DIR/app/node-webkit-latest-linux-ia32/nw $ZIP > $DIR/app/beaglebone-getting-started.ia32
chmod +x $DIR/app/beaglebone-getting-started.ia32

# Make Windows .exe
cat $DIR/app/node-webkit-latest-win-ia32/nw.exe $ZIP > $DIR/app/beaglebone-getting-started.exe

# Clean-up
rm -f $ZIP
