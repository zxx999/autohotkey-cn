/*
AutoHotkey 版本: 1.1.2.1
操作系统:    WIN_XP
作者:        星雨朝霞
网站:        http://www.AutoHotkey.com
脚本说明：   POST登录论坛
脚本版本：   v1.0
*/

Gui, Add, GroupBox, x7 y2 w389 h39 , 登录论坛:
Gui, Add, Text, x17 y16 w23 h15 , ID: 
Gui, Add, Edit, x41 y15 w75 h18 vusers 
Gui, Add, Text, x123 y18 w23 h15 , PW:
Gui, Add, Edit, x143 y15 w75 h18 vpasss Password


Gui, Add, DropDownList,AltSubmit x221 y14 w75 vLis gList,安全提问||母亲的名字|爷爷的名字|父亲出生的城市|您其中一位老师的名字|您个人计算机的型号|您最喜欢的餐馆名称|驾驶执照的最后四位数字
Gui, Add, Edit, x300 y15 w60 h18 vEdit3
GuiControl,Disable ,Edit3
Gui, Add, Button, x360 y13 w35 h22 glogin, 登录

Gui, Add, Text, x400 y1 w152 h60 vText1, Text
Gui, Add, ListView, x8 y48 w458 h199 Counter, 时间|用户名|内容
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
gosub,getpm
return

List:
Gui,Submit,Nohide
if Lis=1
{
   GuiControl,,Edit3,
   GuiControl,Disable ,Edit3
}else{
   GuiControl,Enable ,Edit3
   GuiControl, Focus,Edit3
}
return

login:
Gui,Submit,Nohide
Lis:=Lis-1
if (Lis=0)
   Lis=

XMLHTTP:=
if users and passs{
   username :=UrlEncode2(users)
   passwords :=UrlEncode2(passs)
   SB_SetText("正在获取本次操作 hash 令牌...",2)
   login:= byteToStr(WinHttp("http://ahk.5d6d.com/logging.php?action=login"),"gb2312")
   
   if RegExMatch(login,"formhash=(.{8})",formhash) { ;获取登录令牌成功
         SB_SetText("正在登录论坛...",2)
         ;定义提交登录数据
         postdata =formhash=%formhash1%&referer=http://ahk.5d6d.com/bbs.php&loginfield=username&username=%username%&password=%passwords%&questionid=%Lis%&answer=%Edit3%
         
         post := byteToStr(WinHttp("http://ahk.5d6d.com/logging.php?action=login&loginsubmit=yes&floatlogin=yes&inajax=1","POST",postdata),"gb2312")

         if RegExMatch(post,"CDATA\[(.*?)\]",Welcomeback) { ;欢迎您回来
            SB_SetText(Welcomeback1,2)
          
            ;获取短信息
            gosub,getpm
         }else if RegExMatch(post,"<h1>(.*?)</h1>",Welcomeback){ ;登录失败，您还可以尝试 N<4 次
            SB_SetText(Welcomeback1,2)
             gosub,getpm
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
LV_Delete()
   SB_SetText("正在获取短消息...",2)
   bbspm :=byteToStr(WinHttp("http://ahk.5d6d.com/pm.php"),"gb2312")
   Clipboard:=bbspm
   ;~ FileAppend,%bbspm%,tt.txt
   ;对正则不懂!乱写了!!
   if RegExMatch(bbspm,"(积分: \d+)[\W\w]+(威望: \d+)[\W\w]+(金钱: \d+)[\W\w]+(贡献: \d+)",Integral) {
      GuiControl,,Text1,%Integral1%`n%Integral2%`n%Integral3%`n%Integral4%
      ;匹配时间(不会使用正则!这是乱写的!这里很蛋疼...)
      RegExMatch(bbspm, "i)right.>(.*)</span>[\W\w]+?k.>(.+)</a>[\W\w]+?w.>(.*?)</a>(?CFunc1)") 
         Func1(t) {
            LV_Add(LV_GetCount(),t1,t2,t3)
            return 1
         }
   SB_SetText("获取短消息完成...",2)
   }else
      SB_SetText("登录失败.....",2)
   
return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
WinHttp(Httpurl,Httpmode="GET",Httppostdata=""){
   StringUpper Httpmode,Httpmode
   ;~ XMLHTTP := ComObjCreate("WinHttp.WinHttpRequest.5.1")
   ret:=IsObject(XMLHTTP)
   if ! ret
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
; 转换编码
UrlEncode2(String) {
  OldFormat := A_FormatInteger
  SetFormat, Integer, H
  Loop, Parse, String
    {
      If A_LoopField is Alnum
        {
          Out .= A_LoopField
          Continue
        }
      StrPutVar(A_LoopField, var, "cp0")
      ChrGBKCode := NumGet(var, 0, "UInt")
      Hex := SubStr(ChrGBKCode, 3 )
      StringMid,ch2,ChrGBKCode,3,2
      StringMid,ch1,ChrGBKCode,5,2
      If  (StrLen( Hex) = 4)
        {
          Out .= "%" . ch1 . "%" . ch2
        }
      Else
          Out .= "%" . ( StrLen( Hex ) = 1 ? "0" . Hex : Hex )
    }
  SetFormat, Integer, %OldFormat%
  Return Out
}
StrPutVar(string, ByRef var, encoding) {
    ; Ensure capacity.
    VarSetCapacity( var, StrPut(string, encoding)
        ; StrPut returns char count, but VarSetCapacity needs bytes.
        * ((encoding="utf-16"||encoding="cp1200") ? 2 : 1) )
    ; Copy or convert the string.
    return StrPut(string, &var, encoding)
}