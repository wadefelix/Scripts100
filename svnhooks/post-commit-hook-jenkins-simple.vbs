'REM https://wiki.jenkins-ci.org/display/JENKINS/Subversion+Plugin
jenkinsurl = WScript.Arguments.Item(0)

Set shell = WScript.CreateObject("WScript.Shell")

Set http = CreateObject("Microsoft.XMLHTTP")
http.open "GET", jenkinsurl, False
http.setRequestHeader "Content-Type", "text/plain;charset=UTF-8"
http.send

