#!/bin/sh
ZIP=/tmp/$(basename $0).$RANDOM.zip
cd $(dirname $0)/../

rm app/getting-started
zip $ZIP -r * -x app/*

# Add node-webkit plugins
cd app
zip $ZIP package.json nw.pak libffmpegsumo.so plugins/*
cd ..

cat app/nw-linux-x64 $ZIP > app/getting-started-x64
chmod +x app/getting-started-x64

cat app/nw-linux-x32 $ZIP > app/getting-started-x32
chmod +x app/getting-started-x32

rm $ZIP
