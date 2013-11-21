#!/bin/bash

# Update /etc/network/interfaces to add virtual Ethernet port
cat >>/etc/network/interfaces <<EOF

iface usb0 inet static
  address 192.168.7.2
  netmask 255.255.255.0
  network 192.168.7.0
  gateway 192.168.7.1
EOF

# Add terminal to virtual serial port
cat >/etc/init/gadget-serial.conf <<EOF
start on stopped rc RUNLEVEL=[2345]
stop on runlevel [!2345]

respawn
exec /sbin/getty 115200 ttyGS0
EOF

# Write script to start gadget driver
cat >/usr/sbin/g-multi-load.sh <<'EOF'
#!/bin/bash
if [ "`lsmod | grep g_multi`" != "" ]; then exit 0; fi
mac_addr=/proc/device-tree/ocp/ethernet@4a100000/slave@4a100300/mac-address
eeprom=/sys/bus/i2c/devices/0-0050/eeprom

DEV_ADDR=$(perl -e 'print join(":",unpack("(H2)*",<>))' ${mac_addr})
VERSION=$(perl -e '@x=unpack("A12A4",<>); print $x[1]' ${eeprom})
SERIAL_NUMBER=$(perl -e '@x=unpack("A16A12",<>); print $x[1]' ${eeprom})
ISBLACK=$(perl -e '@x=unpack("A20A4",<>); print $x[1]' ${eeprom})

BLACK=""
if [ "${ISBLACK}" = "BBBK" ] ; then
	BLACK="Black"
fi
if [ "${ISBLACK}" = "BNLT" ] ; then
	BLACK="Black"
fi

modprobe g_multi file=/dev/mmcblk0p1 cdrom=0 stall=0 removable=1 nofua=1 iSerialNumber=${SERIAL_NUMBER} iManufacturer=Circuitco iProduct=BeagleBone${BLACK} host_addr=${DEV_ADDR}

# Enable the network interface
sleep 1
ifup usb0
EOF
chmod +x /usr/sbin/g-multi-load.sh

# Add script to rc.local
perl -i -pe 's!^exit 0!/usr/sbin/g-multi-load.sh\nexit 0!' /etc/rc.local

# Install DHCP server
sudo apt-get -y update
sudo apt-get -y install isc-dhcp-server

# Configure DHCP server
cat >/etc/ltsp/dhcp.conf <<EOF
ddns-update-style none;
subnet 192.168.7.0 netmask 255.255.255.252 {
  range 192.168.7.1 192.168.7.1;
}
EOF
perl -i -pe 's/INTERFACES=".*"/INTERFACES="usb0"/' /etc/default/isc-dhcp-server

# Start up services
/usr/sbin/g-multi-load.sh
service isc-dhcp-server start
