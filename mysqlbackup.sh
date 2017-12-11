#!/bin/bash


cd ~/mysqlbackup
echo "You are in backup dir"
mv *.sql.gz pre/

for db in db1 db2 db3
do
File=${db}-backup-`date +'%Y-%m-%d-%H-%M-%S'`.sql.gz
mysqldump -uuser -ppassword ${db} | gzip > $File
done

echo "mysql backup completed."
