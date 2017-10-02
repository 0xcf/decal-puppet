#!/bin/bash

set -euo pipefail

echo -n "Username: "
read user

# Set the hostname
hostname "$user"
bash -c "echo \"$user\" > /etc/hostname"

# Set up settings so that the instance has the correct hostname and knows how
# to find the puppet server
bash -c "cat >> /etc/dhcp/dhclient.conf" << EOL
supersede host-name "$user.decal.xcf.sh";
append domain-search "decal.xcf.sh";
supersede domain-name "decal.xcf.sh";
EOL

# Kill and restart dhclient to apply the new config
pkill -f /sbin/dhclient
nohup /sbin/dhclient -4 -v -pf /run/dhclient.eth0.pid -lf /var/lib/dhcp/dhclient.eth0.leases -I -df /var/lib/dhcp/dhclient6.eth0.leases eth0 &
nohup /sbin/dhclient -v -6 -nw -pf /run/dhclient-6.eth0.pid -lf /var/lib/dhcp/dhclient-6.eth0.leases -I -df /var/lib/dhcp/dhclient-6.eth0.leases eth0 &

# Run puppet
apt install puppet -y
puppet agent -t
