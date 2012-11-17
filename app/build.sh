#!/bin/sh
set -x
set -e
ZIP=/tmp/$(basename $0).$RANDOM.zip
cd $(dirname $0)/..
DIR=`pwd`

cd $DIR
zip $ZIP -r autorun.inf Docs Drivers info.txt LICENSE.txt README.htm

# Add package.json
cd $DIR/app
zip $ZIP package.json

cp $ZIP $DIR/app/beaglebone-getting-started.app/Contents/Resources/app.nw

cat $DIR/app/node-webkit-latest-linux-x64/nw $ZIP > $DIR/app/beaglebone-getting-started.x64
chmod +x $DIR/app/beaglebone-getting-started.x64

cat $DIR/app/node-webkit-latest-linux-ia32/nw $ZIP > $DIR/app/beaglebone-getting-started.ia32
chmod +x $DIR/app/beaglebone-getting-started.ia32

# Clean-up
rm $ZIP
