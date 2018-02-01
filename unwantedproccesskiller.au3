#NoTrayIcon
#include <MsgBoxConstants.au3>
#include <TrayConstants.au3>
#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         Ren Wei

 Script Function:
	杀掉不想要的进程，比如广告进程啥的

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here


Opt("TrayMenuMode", 3) ; The default tray menu items will not be shown and items are not checked when selected. These are options 1 and 2 for TrayMenuMode.
Opt("TrayOnEventMode", 1) ; Enable TrayOnEventMode.

Global $pauseStr = "暂停"
Global $pauseStatus = False
Global $pauseitemid = Null
Global $unwantedProcessNames[] = ["wpscenter.exe", "QyProxy.exe", "QyKernel.exe"]

Main()

Func Main()
	$pauseitemid = TrayCreateItem($pauseStr)
    TrayItemSetOnEvent($pauseitemid, "PauseScript")

    TrayCreateItem("") ; Create a separator line.

    TrayCreateItem("About")
    TrayItemSetOnEvent(-1, "About")
    TrayCreateItem("") ; Create a separator line.

    TrayCreateItem("Exit")
    TrayItemSetOnEvent(-1, "ExitScript")

    TraySetOnEvent($TRAY_EVENT_PRIMARYDOUBLE, "About")

    TraySetState($TRAY_ICONSTATE_SHOW) ; Show the tray menu.

    While 1
        Sleep(100) ; An idle loop.
		KillUnwanted()
    WEnd
EndFunc   ;==>Example

Func About()
    ; Display a message box about the program
    MsgBox($MB_SYSTEMMODAL, "", "unwanted processes killer")
EndFunc   ;==>About

Func ExitScript()
    Exit
EndFunc   ;==>ExitScript

Func DummyCommand()
EndFunc

Func PauseScript()
   Global $pauseStatus
   Global $pauseitemid
   $pauseStatus = Not $pauseStatus
   TrayItemSetState ( $pauseitemid, $pauseStatus ? $TRAY_CHECKED : $TRAY_UNCHECKED )
EndFunc

Func KillUnwanted()
   Global $unwantedProcessNames
   Global $pauseStatus
   If $pauseStatus Then
	  Return
   EndIf
   For $pn In $unwantedProcessNames
	  $pid = ProcessExists($pn)
	  If $pid Then
		 ProcessClose($pid)
	  EndIf
   Next
EndFunc