;~ CustomColor = EE0099 ; 可以是任何 RGB 值，他将用于后面的透明设置
CustomColor = FFFFCC ; 可以是任何 RGB 值，他将用于后面的透明设置
Clipboard:="星雨朝霞"
Gui, Add, Text, x12 y20 w40 h20 , 输入：
Gui, Add, Button, x52 y10 w120 h30 gFromClipBoard, 从剪贴板粘贴(&P)
Gui, Add, Text, x212 y20 w40 h20 , 输出：
Gui, Add, Button, x252 y10 w140 h30 gToClipBoard, 复制到剪贴板(&C)
;~ Gui, Color,, 0xFFFFAA

Gui, Add, Edit, x12 y50 w180 h110 vFrom
;~  GuiControl +Background FF9977, To

;~ Gui, Color,,Default


GuiControl, -Background,From
Gui, Color, ,%CustomColor%

;~ GuiControl +background,From
Gui, Add, Edit, x212 y50 w190 h110 vTo

Gui, Add, GroupBox, x12 y170 w180 h50 , 操作
Gui, Add, Radio, x22 y190 w60 h20 gDecode, 解码(&D)
Gui, Add, Radio, x102 y190 w70 h20 gEncode vEncode, 编码(&E)
Gui, Add, GroupBox, x212 y170 w190 h50 , 编码方式
Gui, Add, Radio, x222 y190 w60 h20 , ANSI
Gui, Add, Radio, x312 y190 w80 h20 , UTF-8
Gui, Add, Button, x42 y220 w80 h30 gClean, 清空(&L)
Gui, Add, Button, x152 y220 w90 h30 gHistory, 查看历史(H)
Gui, Add, Button, x272 y220 w80 h30 gExit, 退出(&X)
;~ Gui, Font, underline
;~ Gui, Add, Text, cBlue gLaunchGoogle, Click here to launch Google.
;~ Gui, Font, norm
 
;~ To, Color, White
 
Gosub,FromClipBoard
GuiControl,, Encode, 1  ; 需要有v前缀引导的变量名

Gosub,Encode
 
; Generated using SmartGUI Creator 4.0
Gui, Show, w418 h265, Encode/Decode Tools - AHK实现 - 2010.12.25
Pause
Return
LaunchGoogle:
Run www.google.com
return

FromClipBoard:
GuiControl,,From,%Clipboard%
;~ MsgBox FromClipBoard
GuiControl,, Encode, 1  ; 需要有v前缀引导的变量名
Gosub,Encode
return
ToClipBoard:
GuiControlGet,board,,To
;~ ClipSaved := ClipboardAll 
Clipboard := board 
;~ MsgBox %board%
ToolTip,已复制
SetTimer, RemoveToolTip, 3000

return
Decode:
MsgBox Decode
return
Encode:
gui,submit,NoHide
;~ MsgBox %From%
;~ To:=% UrlEncode(Ansi2UTF8("中文论坛"))
;~ GuiControl,,To,% UrlEncode(Ansi2UTF8(From))
GuiControl,,To,% UrlEncode(From)

return


Clean:
GuiControl,,To,
GuiControl,,From,
return
History:
MsgBox History
return
Exit:
ExitApp
return
GuiClose:
ExitApp

RemoveToolTip:
SetTimer, RemoveToolTip, Off
ToolTip
return
UrlEncode(String)
{
   OldFormat := A_FormatInteger
   SetFormat, Integer, H

   Loop, Parse, String
   {
      if A_LoopField is alnum
      {
         Out .= A_LoopField
         continue
      }
      Hex := SubStr( Asc( A_LoopField ), 3 )
      Out .= "%" . ( StrLen( Hex ) = 1 ? "0" . Hex : Hex )
   }
   SetFormat, Integer, %OldFormat%
   return Out
}

IE_uriEncode(str)
{
   f = %A_FormatInteger%
   SetFormat, Integer, Hex
   If RegExMatch(str, "^\w+:/{0,2}", pr)
      StringTrimLeft, str, str, StrLen(pr)
   StringReplace, str, str, `%, `%25, All
   Loop
      If RegExMatch(str, "i)[^\w\.~%/:]", char)
         StringReplace, str, str, %char%, % "%" . SubStr(Asc(char),3), All
      Else Break
   SetFormat, Integer, %f%
   Return, pr . str
}

; ------------------下面是转换函数--------------------------
Ansi2UTF8(sString)
{
   Ansi2Unicode(sString, wString, 0) , Unicode2Ansi(wString, zString, 65001)
   Return zString
}

UTF82Ansi(zString)
{
   Ansi2Unicode(zString, wString, 65001) , Unicode2Ansi(wString, sString, 0)
   Return sString
}

Ansi2Unicode(ByRef sString, ByRef wString, CP = 0)
{
  nSize := DllCall("MultiByteToWideChar", "Uint", CP, "Uint", 0, "Uint", &sString, "int",  -1, "Uint", 0, "int",  0) 
  VarSetCapacity(wString, nSize * 2)
  DllCall("MultiByteToWideChar", "Uint", CP, "Uint", 0, "Uint", &sString, "int",  -1, "Uint", &wString, "int", nSize)
}

Unicode2Ansi(ByRef wString, ByRef sString, CP = 0)
{
  nSize := DllCall("WideCharToMultiByte", "Uint", CP, "Uint", 0, "Uint", &wString, "int",  -1, "Uint", 0, "int", 0, "Uint", 0, "Uint", 0) 
  VarSetCapacity(sString, nSize)
  DllCall("WideCharToMultiByte", "Uint", CP, "Uint", 0, "Uint", &wString, "int",  -1, "str",  sString, "int",  nSize, "Uint", 0, "Uint", 0)
}