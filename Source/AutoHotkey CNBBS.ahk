/*
AutoHotkey 版本: 1.1.2.1
操作系统:    WIN_XP
作者:        星雨朝霞
网站:        http://www.AutoHotkey.com
脚本说明：   POST登录论坛
脚本版本：   v1.0
*/

Gui, Add, GroupBox, x7 y2 w295 h39 , 登录论坛:
Gui, Add, Text, x17 y16 w23 h15 , ID:
Gui, Add, Edit, x41 y15 w97 h18 vusers
Gui, Add, Text, x140 y18 w23 h15 , PW:
Gui, Add, Edit, x159 y15 w97 h18 vpasss Password
Gui, Add, Button, x257 y12 w42 h22 glogin, 登录
Gui, Add, Text, x310 y10 w152 h30 vText1, Text
Gui, Add, ListView, x8 y46 w458 h199 Counter, 时间|用户名|内容
Gui, Add, Edit, x8 y251 w385 h100 , Edit

Gui, Add, Button, x395 y253 w72 h26 gsup, 更新短消息
Gui, Add, Button, x396 y325 w72 h26 , 发送(&S)
Gui, Add, StatusBar
SB_SetParts(60)
SB_SetText("状态: ",1)

SB_SetIcon("Shell32.dll", 21)

LV_ModifyCol(1,100)
LV_ModifyCol(2,100)
LV_ModifyCol(3,230)

;~ Loop,5
   ;~ LV_Add(A_Index,LV_GetCount())

Gui, Show, w477 h377, Untitled GUI
return

GuiClose:
ExitApp

sup:

return

login:
GuiControlGet, user,,users
GuiControlGet, pass,,passs
if user and pass{
   username :=UrlEncode(user)
   passwords :=UrlEncode(pass)
   SB_SetText("正在获取本次操作 hash 令牌...",2)
   login:= byteToStr(WinHttp("http://ahk.5d6d.com/logging.php?action=login"),"gb2312")

   if RegExMatch(login,"formhash=(.{8})",formhash) { ;获取登录令牌成功

         WinHttp("http://ahk.5d6d.com/logging.php?action=logout&amp;formhash="formhash1)
         SB_SetText("正在登录论坛...",2)
         ;定义提交登录数据
         postdata =formhash=%formhash1%&referer=http`%3A`%2F`%2Fahk.5d6d.com`%2Fbbs.php&loginfield=username&username=%username%&password=%passwords%&questionid=0&answer=
         post := byteToStr(WinHttp("http://ahk.5d6d.com/logging.php?action=login&loginsubmit=yes&inajax=1","POST",postdata),"gb2312")
         if RegExMatch(post,"CDATA\[(.*?)\]",Welcomeback) { ;欢迎您回来
            SB_SetText(Welcomeback1,2)
          
            ;获取短信息
            gosub,getpm
         }else if RegExMatch(post,"alert\('(.*?)'\)",failed){ ;登录失败，您还可以尝试 N<4 次
            SB_SetText(failed1,2)
         }else{
            SB_SetText("登录失败...",2)
         }

   } else if RegExMatch(login,"<p>(.*?)</p>",formhash){ ;论坛暂时禁止此IP
            SB_SetText(formhash1,2)
   }else{
            SB_SetText("不知道...",2)
         }
}else{
   MsgBox,16,提示,帐号或密码不能为空
}
return

getpm:
   SB_SetText("正在获取短消息...",2)
   bbspm :=byteToStr(WinHttp("http://ahk.5d6d.com/pm.php"),"gb2312")
   ;~ FileAppend,%bbspm%,tt.txt
   ;对正则不懂!乱写了!!
   if RegExMatch(bbspm,"(积分: \d+)[\W\w]+(威望: \d+)[\W\w]+(金钱: \d+)[\W\w]+(贡献: \d+)",Integral) {
      GuiControl,,Text1,%Integral1%    %Integral2%`n%Integral3%    %Integral4%
      ;匹配时间(不会使用正则!这是乱写的!这里很蛋疼...)
      RegExMatch(bbspm, "i)right.>(.*)</span>[\W\w]+?k.>(.+)</a>[\W\w]+?w.>(.*?)</a>(?CFunc1)") 
         Func1(t) {
            LV_Add(LV_GetCount(),t1,t2,t3)
            return 1
         }

   }
   SB_SetText("获取短消息完成...",2)
return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
WinHttp(Httpurl,Httpmode="GET",Httppostdata=""){
   StringUpper Httpmode,Httpmode
   ;~ XMLHTTP := ComObjCreate("WinHttp.WinHttpRequest.5.1")
   XMLHTTP := ComObjCreate("Microsoft.XMLHTTP")
   XMLHTTP.open(Httpmode,Httpurl,false)
   XMLHTTP.setRequestHeader("User-Agent", "Mozilla/5.0 (Windows NT 5.1; rv:5.0) Gecko/20100101 Firefox/5.0")
   if Httpmode=POST 
      XMLHTTP.setRequestHeader("Content-Type", "application/x-www-form-urlencoded")
   XMLHTTP.send(Httppostdata)
   ;~ return XMLHTTP.responseText
   return XMLHTTP.ResponseBody
}



;将原始数据流以指定的编码的形式读出
byteToStr(body, charset){
	Stream := ComObjCreate("Adodb.Stream")
	Stream.Type := 1
	Stream.Mode := 3
	Stream.Open()
	Stream.Write(body)
	Stream.Position := 0
	Stream.Type := 2
	Stream.Charset := charset
	str := Stream.ReadText()
	Stream.Close()
	return str
}

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