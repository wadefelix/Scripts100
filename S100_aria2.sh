#!/bin/sh
### BEGIN INIT INFO
# Provides:          Aria2
# Required-Start:    $network $local_fs $remote_fs
# Required-Stop::    $network $local_fs $remote_fs
# Should-Start:      $all
# Should-Stop:       $all
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Aria2 - Download Manager
# Description:       Aria2 - Download Manager
### END INIT INFO

NAME=aria2c
USER=root
ARIA2C=/opt/bin/$NAME
PIDFILE=/var/run/$NAME.pid
#CONF=/home/$USER/.aria2/aria2.conf
CONF=/mnt/disk1/temp/aria2.conf
ARGS="--conf-path=${CONF}"
#LOGFILE=/mnt/disk1/temp/startaria2.log
LOGFILE=/dev/null

test -f $ARIA2C || exit 0

case "$1" in
start)  
        echo "Starting aria2c" > $LOGFILE 
        start-stop-daemon -S -q -b -m -p $PIDFILE -c $USER -a $ARIA2C -- $ARGS
        grep State /proc/$(cat ${PIDFILE})/status >> $LOGFILE 
        echo "aria2 started,result:$?" >> $LOGFILE 
        exit 0
        ;;
stop)   echo "Stopping aria2c"
        start-stop-daemon -K -q -p $PIDFILE
        rm $PIDFILE
        echo $?
        ;;
restart|reload|force-reload)
        echo "Restarting aria2c"
        start-stop-daemon -K -R 5 -q -p $PIDFILE
        rm $PIDFILE
        start-stop-daemon -S -q -b -m -p $PIDFILE -c $USER -a $ARIA2C -- $ARGS
        exit $?
        ;;
status)
        #status_of_proc -p $PIDFILE $ARIA2C aria2c && exit 0 || exit $?
        grep "State" /proc/$(cat ${PIDFILE})/status
        exit 0
        ;;
*)      echo "Usage: /etc/init.d/aria2c {start|stop|restart|reload|force-reload|status}"
        exit 2
        ;;
esac
exit 0
