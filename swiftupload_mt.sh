#!/bin/bash
#set -x	#开启调试模式
# Usage:
# History:
# http://www.annhe.net/article-2895.html

export ST_AUTH='https://auth.sinas3.com/v1.0'
#AccessKey
export ST_USER='x'
#SecretKey
export ST_KEY='x'

bucket='bucketname'
inputfile='filelist.txt'


thread=$1	#设置线程数，在这里所谓的线程，其实就是几乎同时放入后台（使用&）执行的进程。
if [ "$1"x == ""x ]; then
	thread=1
fi
 
tmp_fifofile=/tmp/$$.fifo		#脚本运行的当前进程ID号作为文件名
mkfifo $tmp_fifofile			#新建一个随机fifo管道文件
exec 6<>$tmp_fifofile			#定义文件描述符6指向这个fifo管道文件
rm $tmp_fifofile			#清空管道内容
 
#定义一个函数做为线程（子进程）
function func()
{
	  swift upload $1 $2
      if [ $? -eq 0 ]; then
        # echo $2 >>../success.txt
      else
        # echo $2 >>../failed.txt
        echo "upload $1 failed"
      fi
}
 
# for循环 往 fifo管道文件中写入$thread个空行
for ((i=0;i<$thread;i++));do
	echo 
done >&6

LAST="xx.jpg"
START=1

# 从文件中读取行
while read line; do
  if [ "0" == "$START" ]; then
      if [ "$line" == "$LAST" ]; then
        START=1
        echo "start"
      fi
  else
	read -u6		#从文件描述符6中读取行（实际指向fifo管道)
	{
		func $bucket $line
		echo >&6	#再次往fifo管道文件中写入一个空行
	} &
# {} 这部分语句被放入后台作为一个子进程执行，所以不必每次等待3秒后执行
#下一个,这部分的func几乎是同时完成的，当fifo中thread个空行读完后 while循环
# 继续等待 read 中读取fifo数据，当后台的thread个子进程等待3秒后，按次序
# 排队往fifo输入空行，这样fifo中又有了数据，while循环继续执行
  fi
done < $inputfile		#从ip.txt中读取数据

wait			#等到后台的进程都执行完毕
exec 6>&-		##删除文件描述符6

exit 0
