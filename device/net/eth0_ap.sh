#!/system/bin/sh

busybox ifconfig wlan0 192.168.43.1 netmask 255.255.255.0

iptables -t filter -F
iptables -t nat -F
iptables -t nat -A POSTROUTING -s 192.168.43.0/255.255.255.0 -o eth0 -j MASQUERADE
busybox ifconfig wlan1  down
busybox route add -net 224.0.0.0 netmask 224.0.0.0 dev wlan0