#!/bin/sh
### BEGIN INIT INFO
# Provides:          sshsocks
# Required-Start:    $network $local_fs $remote_fs
# Required-Stop::    $network $local_fs $remote_fs
# Should-Start:      $all
# Should-Stop:       $all
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: SSH Socks5
# Description:       SSH Socks5
### END INIT INFO

NAME=sshsocks
USER=root
EXEFILE=/bin/ssh
PIDFILE=/var/run/$NAME.pid
KEYFILE="/.ssh/id_rsa"
SERVER="example.com"
USERNAME="username"
SSHPORT=22
SOCKS5PORT=9999
ARGS=" -gqTnN -D ${SOCKS5PORT} -p ${SSHPORT} -i ${KEYFILE} -o ServerAliveInterval=240 ${USERNAME}@${SERVER}"

test -f $EXEFILE || exit 0

case "$1" in
start)  echo "Starting $NAME"
        start-stop-daemon -S -q -b -m -p $PIDFILE -c $USER -a $EXEFILE -- $ARGS
        echo $?
        ;;
stop)   echo "Stopping $NAME"
        start-stop-daemon -K -q -p $PIDFILE
        rm $PIDFILE
        echo $?
        ;;
restart|reload|force-reload)
        echo "Restarting $NAME"
        start-stop-daemon -K -q -p $PIDFILE
        rm $PIDFILE
        start-stop-daemon -S -q -b -m -p $PIDFILE -c $USER -a $EXEFILE -- $ARGS
        echo $?
        ;;
status)
        grep "State" /proc/$(cat ${PIDFILE})/status
        exit 0
        ;;
*)      echo "Usage: /etc/init.d/$NAME {start|stop|restart|reload|force-reload|status}"
        exit 2
        ;;
esac
exit 0
