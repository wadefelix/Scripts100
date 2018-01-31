#!/bin/bash

### BEGIN INIT INFO
# Provides:          randomhostname
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Changing hostname to random value
# Description:       Changing hostname to random value
### END INIT INFO

# put it in /etc/init.d/
# sudo update-rc.d randomhostname.sh defaults


do_start () {
    service network-manager stop

    old=$(cat /etc/hostname)
    [ -z "$old" ] && HOSTNAME="$(hostname)"
    
    # appending MAC
    # NIC=$(ls /sys/class/net/ | awk '{if($1 !~ /docker[0-9]*/ && $1 !~ /^lo$/) {print $1;exit 0;}}')
    # NIC=$(lshw -class network | grep 'logical name:' | awk -F: '{print $2}')
    # [ -f /sys/class/net/$NIC/address ] && new="ubuntu-$(cat /sys/class/net/$NIC/address | sed 's/://g')"
    # MAC=$(lshw -class network | grep 'serial:' | awk '{print $2}' | sed 's/://g')
    new="ubuntu-$(lshw -class network | grep 'serial:' | awk '{print $2}' | sed 's/://g')"
    [ -z "$new" ] && new=$(tr -dc 'A-Z0-9' < /dev/urandom | head -c12)

    sed -i "s/$old/$new/g" /etc/hosts
    sed -i "s/$old/$new/g" /etc/hostname
    hostname "$new"

    service network-manager start

    exit 0
}

do_status () {
	HOSTNAME=$(hostname)
	if [ "$HOSTNAME" ] ; then
		return 0
	else
		return 4
	fi
}

case "$1" in
  start|"")
	do_start
	;;
  restart|reload|force-reload)
	echo "Error: argument '$1' not supported" >&2
	exit 3
	;;
  stop)
	# No-op
	;;
  status)
	do_status
	exit $?
	;;
  *)
	echo "Usage: randomhostname.sh [start|stop]" >&2
	exit 3
	;;
esac

:
