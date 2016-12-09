REM http://www.mantisbt.org/bugs/view.php?id=7076
REM Post-commit hook for MantisBT integration

SET REPOS=%1
SET REV=%2
SET DETAILS_FILE=C:\xampp\tmp\svnfile_%REV%
SET LOG_FILE=C:\xampp\tmp\svnfile_%REV%_log.html
SET AUTH_FILE=C:\xampp\tmp\svnfile_%REV%_auth
SET SVN_FILE=C:\xampp\tmp\svnfile_%REV%_svn
  
"C:\Program Files\VisualSVN Server\bin\svnlook.exe" author -r %REV% %REPOS% > %AUTH_FILE%

echo updated by svn post-commit > %DETAILS_FILE%
echo ^<b^>SVN Revision:^</b^> %REV% >> %DETAILS_FILE%
FOR /F %%A IN (%AUTH_FILE%) DO echo ^<b^>SVN Author:^</b^> %%A >> %DETAILS_FILE%
echo ^<b^>SVN Log:^</b^> >> %DETAILS_FILE%

rem 
rem extrem komische Sachen mit iconv, sobald es über Eingabeumleitung läuft
rem anders tut es wirklich nicht!
rem 
"C:\Program Files\VisualSVN Server\bin\svnlook.exe" log -r %REV% %REPOS% >> %DETAILS_FILE%
rem iconv -f 850 -t iso-8859-1 %SVN_FILE% >> %DETAILS_FILE%
rem type %SVN_FILE% >> %DETAILS_FILE%

echo ^<b^>SVN Changed:^</b^> >> %DETAILS_FILE%
"C:\Program Files\VisualSVN Server\bin\svnlook.exe" changed -r %REV% %REPOS% >> %DETAILS_FILE%

REM  取消输出diff
rem echo ^<hr^> >> %DETAILS_FILE%
rem "C:\Program Files\VisualSVN Server\bin\svnlook.exe" diff --no-diff-deleted --no-diff-added -r %REV% %REPOS%   >> %DETAILS_FILE%

C:\xampp\php\php.exe C:\xampp\htdocs\mantisbt\scripts\checkin.php < %DETAILS_FILE% > %LOG_FILE%
DEL %DETAILS_FILE%
DEL %LOG_FILE%
DEL %AUTH_FILE%
DEL %SVN_FILE%
