
```bash
# 创建deb包, 在目录的父目录执行
dpkg-deb --build hello-deb

# 在托管deb包的服务器上生成软件名录，也可以生成后拷贝过去即可
# dpkg-scanpackages in in dpkg-dev package
dpkg-scanpackages . | gzip -c9  > Packages.gz


# 在电脑上添加源配置
echo "deb [trusted=yes] http://192.168.1.4/softwares/debian/ ./" > /etc/apt/sources.list.d/local.list
```

