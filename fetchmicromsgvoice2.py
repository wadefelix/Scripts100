#! /usr/bin/env python
# -*- coding:utf-8 -*-
# ftp fetch MicroMsg amr files to local


from ftplib import FTP
import os
import datetime
import time

localdir = r'~/micromsg'

ftp=FTP()
ftp.connect('192.168.1.105','2121')

ftp.login()
ftp.cwd('tencent/MicroMsg')

voicedirnames = []

def get_file_list(line):
        voicedirname = get_voicedirname(line)
        if voicedirname is not None:
            print voicedirname
            voicedirnames.append(voicedirname)
def get_voicedirname(line):
        info = line.split()
        if info[0][0] == 'd' and len(info[-1]) == 32:
            return info[-1]
        else:
            return None

ftp.dir(get_file_list)


# -rw-r--r-- 1 owner group       668032 Jan 14 16:19 1452759557133_0f13343d.jpg
# 04261951msg_121951042616ea710c10030103.amr
# ÃëÐ¡Ê±·ÖÖÓÔÂÈÕÁ½Î»Äê


for voicedirname in voicedirnames:
    #if not os.path.exists(os.path.join(localdir, voicedirname )): 
    os.mkdir(os.path.join(localdir, voicedirname ))
    ftp.cwd(voicedirname)
    for dirname in ftp.nlst():
        if dirname == 'voice2':
            ftp.cwd('voice2')
            for dirname2 in ftp.nlst():
                ftp.cwd(dirname2)
                for dirname3 in ftp.nlst():
                    ftp.cwd(dirname3)
                    #print os.path.join(voicedirname, dirname, dirname2, dirname3)
                    for dirname4 in ftp.nlst():
                        finfo = dirname4.split('.')
                        if finfo[-1] == 'amr' :
                            print os.path.join(voicedirname, dirname, dirname2, dirname3 ,dirname4)
                            newname = dirname4[10:12] + dirname4[6:10] + dirname4[2:6] + dirname4[:2] + dirname4[12:] 
                            localfile = os.path.join(localdir, voicedirname ,newname)
                            file_handler = open(localfile, 'wb')
                            ftp.retrbinary('RETR {}'.format(dirname4), file_handler.write)
                            file_handler.close()
                    ftp.cwd('..')
                ftp.cwd('..')
            ftp.cwd('..')
    ftp.cwd('..')

ftp.quit()



