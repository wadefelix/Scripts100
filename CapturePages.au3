#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.1
 Author:         RenWei

 Script Function:
	不可打印无法破解的pdf文档，只能通过这种一页一页抓屏方式存成图片吧
注：win8.1有个较为恼人的bug - 带键盘把屏幕竖起来的话，键盘似乎会失效，也不确定是win8.1的bug还是adobe acrobat reader的bug，反正就是不能用键盘了，而且用autoit发送按键消息也不行。
    foxit也不行，这就是windows的遗憾了。
	若使用surface等高分屏显示设备，请把windows的显示缩放取消，否则截屏无法正常使用，当然，高分屏下截的图的分辨率更高哦。
#ce ----------------------------------------------------------------------------

Opt("MustDeclareVars", 1) ;0=no, 1=require pre-declaration
Opt("WinTitleMatchMode", 2) ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase

#include <ScreenCapture.au3>

DIM $outputdir = @ScriptDir & "\captured\"

; 文档共246页，其中的44-46三页页面横版
Dim $capturePages = 246

Dim $WindowTitle = "Adobe Acrobat Reader"


WinWaitActive($WindowTitle)

;Sleep(2000)
;Send("^L") ; 全屏
;Send("^0") ; ctrl+0 适合页面
; 旋转，用系统的旋转吧
; Send("+^-") ; 旋转
Sleep(30000) ; 等待，若之前发送的快捷键没有生效，此时的较长等待阶段可以手动设置

For $ind = $capturePages
    WinWaitActive($WindowTitle)
    ; Capture full screen
    ; _ScreenCapture_Capture($outputdir & "\CapturedImage" &  StringFormat("%03i", $ind) &".jpg")
	; 竖屏截页面 surface pro 3
    ;_ScreenCapture_Capture($outputdir & "\CapturedImage" &  StringFormat("%03i", $ind) &".jpg", 0, 148, -1, 1862+148)
	; 横屏截横向页面 surface pro 3
    _ScreenCapture_Capture($outputdir & "\CapturedImage" &  StringFormat("%03i", $ind) &".jpg", 148, 0, 1862+148 , -1)
	Send("{PGDN}") ; pade down
    Sleep(500)
Next
