#NoTrayIcon
#include <MsgBoxConstants.au3>
#include <TrayConstants.au3>

#cs
启动PuTTY中一个名为xgfw的配置
#ce

Opt("TrayMenuMode", 3) ; The default tray menu items will not be shown and items are not checked when selected. These are options 1 and 2 for TrayMenuMode.
Opt("TrayOnEventMode", 1) ; Enable TrayOnEventMode.

Global $puttypid = False
Global $startstopid = Null
Global $disphideid = Null

Global Const $strStartXGFW = "Start XGFW"
Global Const $strStopXGFW = "Stop XGFW"
Global Const $strDispPutty = "Display PuTTY"
Global Const $strHidePutty = "Hide PuTTY"
Global Const $strPuttyTitle = "[CLASS:PuTTY]"

Main()

Func Main()
	$startstopid = TrayCreateItem($strStartXGFW)
    TrayItemSetOnEvent($startstopid, "StartPutty")

	$disphideid = TrayCreateItem($strHidePutty)
    TrayItemSetOnEvent($disphideid, "HidePutty")

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
    WEnd
EndFunc   ;==>Example

Func About()
    ; Display a message box about the program
    MsgBox($MB_SYSTEMMODAL, "", "XGFW PuTTY daemon")
EndFunc   ;==>About

Func ExitScript()
	StopPutty()
    Exit
EndFunc   ;==>ExitScript

Func DummyCommand()
EndFunc


Func StartPutty()
	If Not $puttypid Then
        ; $puttypid = Run("putty.exe", "", @SW_HIDE)
		; $puttypid = ShellExecute ("putty.exe", " -ssh -load xgfw", @SW_MINIMIZE )
		$puttypid = Run("putty.exe -load xgfw", "", @SW_HIDE)

		TrayItemSetText($startstopid, $strStopXGFW)
		TrayItemSetOnEvent($startstopid, "StopPutty")

		Local $hWnd = WinWait($strPuttyTitle)
		;MsgBox($MB_SYSTEMMODAL, "Title", "$hWnd=" & $hWnd)
		;ControlDisable ($hWnd, "", controlID )

		HidePutty()
	EndIf
EndFunc

Func StopPutty()
    If $puttypid then
        ProcessClose ($puttypid)
        $puttypid = False

		TrayItemSetText($startstopid, $strStartXGFW)
		TrayItemSetOnEvent($startstopid, "StartPutty")
    Endif
 EndFunc

 Func DispPutty()
    If $puttypid then
        Local $hWnd = WinGetHandle($strPuttyTitle)
        WinSetState($hWnd, "", @SW_SHOW)

		TrayItemSetText($disphideid, $strHidePutty)
		TrayItemSetOnEvent($disphideid, "HidePutty")
    Endif
 EndFunc

 Func HidePutty()
    If $puttypid then
	    Local $hWnd = WinGetHandle($strPuttyTitle)
        WinSetState($hWnd, "", @SW_HIDE)

		TrayItemSetText($disphideid, $strDispPutty)
		TrayItemSetOnEvent($disphideid, "DispPutty")
    Endif
 EndFunc



