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

cat $DIR/app/node-webkit-latest-linux-x64/nw $ZIP > $DIR/app/getting-started.x64
chmod +x $DIR/app/getting-started.x64

cat $DIR/app/node-webkit-latest-linux-ia32/nw $ZIP > $DIR/app/getting-started.ia32
chmod +x $DIR/app/getting-started.ia32

# Clean-up
rm $ZIP
