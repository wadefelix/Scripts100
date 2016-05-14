@echo off
REM https://github.com/kn007/silk-v3-decoder/blob/master/converter.sh
REM C:\Users\Wei\Downloads\silk2mp3\silk_v3_decoder.exe .\msg_002017042616ea710c19fe6104.amr msg.pcm -Fs_API 44100
REM C:\Users\Wei\Downloads\silk2mp3\lame.exe -ar -s 24 msg.pcm msg.mp3

setlocal enabledelayedexpansion

for /r D:\\renxiaoan\\micromsg %%i in (*.amr) do (
set fullfilename=%%i
C:\Users\Wei\Downloads\silk2mp3\silk_v3_decoder.exe !fullfilename! msg.pcm -Fs_API 44100
C:\Users\Wei\Downloads\silk2mp3\lame.exe -ar -s 24 msg.pcm !fullfilename:.amr=.mp3!
)




