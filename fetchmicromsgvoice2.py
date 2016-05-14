# ftp fetch MicroMsg amr files to local


from ftplib import FTP
import os
localdir = r'D:\renxiaoan\micromsg'

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

for voicedirname in voicedirnames:
    os.mkdir(os.path.join(localdir, voicedirname ))
    ftp.cwd(voicedirname)
    for dirname in ftp.nlst():
        if dirname == 'voice2':
            ftp.cwd('voice2')
            for dirname2 in ftp.nlst():
                ftp.cwd(dirname2)
                for dirname3 in ftp.nlst():
                    ftp.cwd(dirname3)
                    for dirname4 in ftp.nlst():
                        finfo = dirname4.split('.')
                        if finfo[-1] == 'amr' :
                            print os.path.join(voicedirname, dirname, dirname2, dirname3 ,dirname4)
                            localfile = os.path.join(localdir, voicedirname ,dirname4)
                            file_handler = open(localfile, 'wb')
                            ftp.retrbinary('RETR {}'.format(dirname4), file_handler.write)
                            file_handler.close()
                    ftp.cwd('..')
                ftp.cwd('..')
            ftp.cwd('..')
    ftp.cwd('..')

ftp.quit()



