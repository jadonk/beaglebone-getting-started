#!/bin/sh
set -x
set -e
TEMPDIR="/tmp/$(basename $0).$$.tmp"
mkdir $TEMPDIR
cd $TEMPDIR

do_extract()
{
	mpkg=$1
	pkg=$2
	zcat /Volumes/FTDIUSBSerialDriver_v2_2_16/$mpkg/Contents/Packages/$pkg/Contents/Archive.pax.gz | cpio -i
}

do_package()
{
	mpkg=$1
	pkg=$2
	find FTDIUSBSerialDriver.kext/ | cpio -o | gzip > /Volumes/FTDIUSBSerialDriver_v2_2_16/$mpkg/Contents/Packages/$pkg/Contents/Archive.pax.gz
	rm -rf FTDIUSBSerialDriver.kext
}

do_patch()
{
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

do_extract FTDIUSBSerialDriver_10_3.mpkg ftdiusbserialdriver.pkg
do_patch
do_package FTDIUSBSerialDriver_10_3.mpkg ftdiusbserialdriver.pkg

do_extract FTDIUSBSerialDriver_10_4_10_5_10_6.mpkg ftdiusbserialdriver.pkg
do_patch
do_package FTDIUSBSerialDriver_10_4_10_5_10_6.mpkg ftdiusbserialdriver.pkg

do_extract FTDIUSBSerialDriver_10_4_10_5_10_6.mpkg ftdiusbserialdriver-1.pkg
do_patch
do_package FTDIUSBSerialDriver_10_4_10_5_10_6.mpkg ftdiusbserialdriver-1.pkg

rmdir $TEMPDIR
