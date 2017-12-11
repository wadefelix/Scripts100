#!/bin/sh

# Usage
# 添加本地源的方法
#   echo 'deb http://192.168.0.2/ubuntu-local/xenial /' | sudo tee /etc/apt/source.list.d/local.list


# step 1: 收集下载软件包
# cp /var/cache/apt/*.deb ubuntu-local/
# or
# dpkg -l | awk '/^ii/ {print $2}' | while read package
# do
#   apt-get download $package
# done


# step 2:
# sudo chown -R user:pswd ubuntu-local/
# sudo chmod ug+rw,o+r *

# step 3:
for d in ~/ubuntu-local/xenial ~/ubuntu-local/wily
do
  cd $d
  dpkg-scanpackages . /dev/null 2>>$d/mkpackage.error |gzip > Packages.gz -r
done

# distribute by apache
# ln -s ~/ubuntu-local /var/www/html/ubuntu-local

# 删除重复的包
for d in ~/ubuntu-local/xenial ~/ubuntu-local/wily
do
  if [ -f $d/mkpackage.error ]; then
    egrep  "\(filename .*\) is repeat" $d/mkpackage.error | awk '{print $6}' | sed 's/)//' | while read filename
    do
      mv $d/$filename $d/deleted/
    done
    mv $d/mkpackage.error $d/deleted/
  fi
done


