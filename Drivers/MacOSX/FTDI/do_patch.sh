#!/bin/sh
set -x
set -e
SRC=/Volumes/FTDIUSBSerialDriver_v2_2_18
HERE=$PWD
TEMPDIR="/tmp/$(basename $0).$$.tmp"
TEMPDIR2=/tmp/FTDIUSBSerialDriver_v2_2_18

do_copy()
{
	mpkg=$1
    mkdir -p $TEMPDIR2
    rm -r $TEMPDIR2/$mpkg || true
    cp -r $SRC/$mpkg $TEMPDIR2/$mpkg
}

do_extract()
{
	mpkg=$1
	pkg=$2
    rm -r $TEMPDIR/* || true
    mkdir -p $TEMPDIR
    cd $TEMPDIR
	gzcat $SRC/$mpkg/Contents/Packages/$pkg/Contents/Archive.pax.gz | cpio -i
}

do_package()
{
	mpkg=$1
	pkg=$2
    cd $TEMPDIR
	find FTDIUSBSerialDriver.kext/ | cpio -o | gzip > $TEMPDIR2/$mpkg/Contents/Packages/$pkg/Contents/Archive.pax.gz
	rm -rf FTDIUSBSerialDriver.kext
}

do_patch()
{
    cd $TEMPDIR
	cat <<PATCH | patch -Np1
--- old/FTDIUSBSerialDriver.kext/Contents/Info.plist	2012-02-07 22:31:34.000000000 -0500
+++ new/FTDIUSBSerialDriver.kext/Contents/Info.plist	2012-02-07 21:52:59.000000000 -0500
@@ -22,6 +22,40 @@
 	<string>2.2.16</string>
 	<key>IOKitPersonalities</key>
 	<dict>
+		<key>BeagleBone XDS100v2 JTAG</key>
+		<dict>
+			<key>CFBundleIdentifier</key>
+			<string>com.FTDI.driver.FTDIUSBSerialDriver</string>
+			<key>IOClass</key>
+			<string>FTDIUSBSerialDriver</string>
+			<key>IOProviderClass</key>
+			<string>IOUSBInterface</string>
+			<key>bConfigurationValue</key>
+			<integer>1</integer>
+			<key>bInterfaceNumber</key>
+			<integer>0</integer>
+			<key>idProduct</key>
+			<integer>42704</integer>
+			<key>idVendor</key>
+			<integer>1027</integer>
+		</dict>
+		<key>BeagleBone XDS100v2 Serial</key>
+		<dict>
+			<key>CFBundleIdentifier</key>
+			<string>com.FTDI.driver.FTDIUSBSerialDriver</string>
+			<key>IOClass</key>
+			<string>FTDIUSBSerialDriver</string>
+			<key>IOProviderClass</key>
+			<string>IOUSBInterface</string>
+			<key>bConfigurationValue</key>
+			<integer>1</integer>
+			<key>bInterfaceNumber</key>
+			<integer>1</integer>
+			<key>idProduct</key>
+			<integer>42704</integer>
+			<key>idVendor</key>
+			<integer>1027</integer>
+		</dict>
 		<key>485USBTB-4W</key>
 		<dict>
 			<key>CFBundleIdentifier</key>
PATCH
}

do_dmg ()
{
	mpkg=$1
    hdiutil create $HERE/FTDI_Ser.dmg -srcfolder $TEMPDIR2 -ov
}

do_copy FTDIUSBSerialDriver_10_4_10_5_10_6_10_7.mpkg

do_extract FTDIUSBSerialDriver_10_4_10_5_10_6_10_7.mpkg ftdiusbserialdriver.pkg
do_patch
do_package FTDIUSBSerialDriver_10_4_10_5_10_6_10_7.mpkg ftdiusbserialdriver.pkg

do_extract FTDIUSBSerialDriver_10_4_10_5_10_6_10_7.mpkg ftdiusbserialdriver-1.pkg
do_patch
do_package FTDIUSBSerialDriver_10_4_10_5_10_6_10_7.mpkg ftdiusbserialdriver-1.pkg

do_dmg 

rm -r $TEMPDIR || true
rm -r $TEMPDIR2 || true
rm -r FTDIUSBSerialDriver_10_4_10_5_10_6_10_7.mpkg || true
