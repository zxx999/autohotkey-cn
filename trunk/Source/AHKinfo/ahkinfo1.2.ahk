
;定义标题,在多处用到的!还是定义个变量比较好!后期修改时只改这里就行了
AHKInfo_Title=AHKInfo 1.2

;********************************************  
;					创建菜单
;********************************************  
OptionsMenu_Text1=总在最前`tWin+Shift+T
Menu, OptionsMenu, Add, %OptionsMenu_Text1% ,GuiMenu 
_MenuIsCheck( "OptionsMenu", OptionsMenu_Text1, "AlwaysOnTop")
if (ErrorLevel=-1) ;没有记录时将默认置顶
	Menu,OptionsMenu,Check, %OptionsMenu_Text1%
Hotkey,#+t,GuiOnTop
Menu, OptionsMenu, Add, 

OptionsMenu_Text2=复制时带 ahk_***`tWin+Shift+C
Menu, OptionsMenu, Add, %OptionsMenu_Text2% ,GuiMenu 
_MenuIsCheck( "OptionsMenu", OptionsMenu_Text2, "Copy.ahk_***")
Hotkey, #+C, Copy_ahk_T
Menu, OptionsMenu, Add, 

OptionsMenu_Text3=自动捕捉`tWin+Shift+F
Menu, OptionsMenu, Add, %OptionsMenu_Text3% ,GuiMenu 
_MenuIsCheck( "OptionsMenu", OptionsMenu_Text3, "AutoCapture")
Hotkey,#+f,AutoCapture
;++++++++++++++++++++++++++++++++++
Menu, MyMenuBar, Add, 选项(&O), :OptionsMenu
;-----------------------------------------------
Menu, aboutMenu, Add, 清除工具属性记录 ,GuiMenu 
Menu, aboutMenu, Add
Menu, aboutMenu, Add, AHK中文论坛`t(&L) ,GuiMenu 
Menu, aboutMenu, Add, AHK中文社区`t(&S) ,GuiMenu 
Menu, aboutMenu, Add, AHK英文论坛`t(&E) ,GuiMenu 
Menu, aboutMenu, Add, 关于`t(&A) ,GuiMenu 
Menu, MyMenuBar, Add, 帮助(&H), :aboutMenu
;-----------------------------------------------
Gui, 1:Menu, MyMenuBar
;===============================================
;			创建窗口控件
;===============================================
Gui, 1:Add, GroupBox, x5 y5 w232 h40 , 窗口信息
Gui, 1:Add, Text, x12 y22 w42 h22 , 标题:
Gui, 1:Add, Edit, x50 y19 w180 h19 ReadOnly -Wrap  vTitle
Gui, 1:Add, Picture, x243 y10 w32 h32 gSetico vPic
Gui, 1:Add, Tab2,-Wrap AltSubmit x2 y50 w275 h358  vTab1, 窗口|控件|可见文本|全部文本|鼠标
;==========================================================
Gui, 1:Tab, 1  ;以下创建的控件属于第一个标签页
Gui, 1:Add, ListView,NoSort -Multi gListView_DoubleClick vListView1  x8 y75 w263 h325 , 属性|值
;列表控件1中的项目,貌似这样写的代码比较少
ListView1_Text=窗口标题|窗口类|窗口ID|坐标|大小|窗口点击|样式|扩展样式|进程PID|进程名|进程路径
StringSplit,ListView1_Text_A,ListView1_Text,|
Loop,%ListView1_Text_A0% 
	LV_Add("",ListView1_Text_A%A_index%,"             ")
;......................................
;下面注释掉的这些是普通方法添加项目,
;~ LV_Add("","窗口标题","             ")
;~ LV_Add("","ahk_Class ","")
;~ LV_Add("","ahk_ID ","")
;~ LV_Add("","ahk_Exe ","")
;~ LV_Add("","ahk_Pid ","")
;~ LV_Add("","坐标","")
;~ LV_Add("","大小","")
;~ LV_Add("","样式","")
;~ LV_Add("","扩展样式","")
;~ LV_Add("","进程路径","")
;......................................
;调整所有列的宽度以适应行的内容
LV_ModifyCol() 
;==========================================================
Gui, 1:Tab, 2 ;以下创建的控件属于第2个标签页
Gui, 1:Add, ListView,NoSort -Multi gListView_DoubleClick vListView2 x8 y75 w263 h325 , 属性|值
ListView2_Text=类别名|文本|实例编号|句柄|坐标|大小|点击坐标|样式|扩展样式
StringSplit,ListView2_Text_A,ListView2_Text,|
Loop,%ListView2_Text_A0% 
	LV_Add("",ListView2_Text_A%A_index%,"             ")
LV_ModifyCol()
;==========================================================
Gui, 1:Tab, 3 ;以下创建的控件属于第3个标签页
Gui, 1:Add, Edit,HScroll ReadOnly x8 y75 w263 h325 vVisible_text
;==========================================================
Gui, 1:Tab, 4 ;以下创建的控件属于第4个标签页
Gui, 1:Add, Edit,HScroll ReadOnly x8 y75 w263 h325 vHidden_text,
;==========================================================
Gui, 1:Tab, 5 ;以下创建的控件属于第5个标签页
Gui, 1:Add, ListView,NoSort -Multi gListView_DoubleClick vListView3 x8 y75 w263 h325 , 属性|值
ListView3_Text=坐标|颜色
StringSplit,ListView3_Text_A,ListView3_Text,|
Loop,%ListView3_Text_A0% 
	LV_Add("",ListView3_Text_A%A_index%,"             ")
LV_ModifyCol()
;==========================================================
Gui, 1:+HwndAHKID
Gui, 1:Show,x5 y50 w279 h410, %AHKInfo_Title%
;===========开始定义===================
Full_ico=%A_Temp%\Full.ico
Null_ico=%A_Temp%\Null.ico
Cross_CUR=%A_Temp%\Cross.CUR
;-----------------------------
;改为屏幕模式
CoordMode,Mouse,Screen
CoordMode,Pixel,Screen
;窗口是否置顶
IsCheck:=IsMenuItemChecked( 0, 0, AHKID )
if (IsCheck=1)
	WinSet,AlwaysOnTop,On,ahk_id %AHKID%
;捕捉功能
IsCheck:=IsMenuItemChecked( 0, 4, AHKID )
if (IsCheck=0) {
	SetTimer,GetPos,Off
}else{
	SetTimer,GetPos,On
	WinSetTitle,ahk_id %AHKID%,,(自动)%AHKInfo_Title%
}
	
gosub,icoStart
GuiControl,,Pic,%Full_ico%
;----------------热键-------------------
;一键捕捉 ;沿用旧版本ahkinfo的热键
Hotkey,~MButton,GetPos ;鼠标中键
Hotkey,~#ctrl,GetPos ;LWin+Ctrl
Hotkey,~^LWin,GetPos ;Ctrl+LWin
;定义窗口的热键
Hotkey,IfWinActive,ahk_id %AHKID%
Hotkey,Esc,GuiClose ;按Esc退出
return

;===========================
icoStart: ;判断与释放图标文件
IfNotExist,%Full_ico%
	FileInstall,Full.ico,%Full_ico%,1
IfNotExist,%Null_ico%
	FileInstall,Null.ico,%Null_ico%,1
IfNotExist,%Cross_CUR%
	FileInstall,Cross.CUR,%Cross_CUR%,1
return
;============================

GuiClose:
FileDelete,%Full_ico%
FileDelete,%Null_ico%
FileDelete,%Cross_CUR%
ExitApp


GuiMenu: ;菜单事件
ThisMenuItemPos:=A_ThisMenuItemPos-1
ItemPos=%A_ThisMenu%%ThisMenuItemPos%
 ;~ **********************
 ;~ * 以下是帮助菜单内容 *
 ;~ **********************
if (ItemPos = "aboutMenu0") { ;清除工具的属性记录
	MsgBox, 4132, 询问, 是否要清除AHKInfo的属性记录?
	IfMsgBox,Yes 
		RegDelete,HKCU,Software\AutoHotKey

}else if (ItemPos = "aboutMenu2") { ;AHK中文论坛
	Run,http://ahk.5d6d.com/?fromuid=4531
}else if (ItemPos = "aboutMenu3") { ;中文社区
	Run,http://cn.autohotkey.com/
}else if (ItemPos = "aboutMenu4") { ;英文社区
	Run,http://www.autohotkey.com/
}else if (ItemPos = "aboutMenu5") { ;关于
	MsgBox, 262208, 关于 %AHKInfo_Title%, 作者:星雨朝霞`nQQ:  458926486
 ;~ **********************
 ;~ * 以下是选项菜单内容 *
 ;~ **********************

}else if (ItemPos = "OptionsMenu0"){ ;切换置顶
	Menu,%A_ThisMenu%,ToggleCheck,%A_ThisMenuItem%
	IsCheck:=IsMenuItemChecked( 0, 0, AHKID )
	_RegW("AlwaysOnTop",IsCheck)
	if (IsCheck=1)
		WinSet,AlwaysOnTop,On,ahk_id %AHKID%
	else
		WinSet,AlwaysOnTop,Off,ahk_id %AHKID%

}else if (ItemPos = "OptionsMenu2"){ ;切换复制时带上 ahk_*** 
	Menu,%A_ThisMenu%,ToggleCheck,%A_ThisMenuItem%
	IsCheck:=IsMenuItemChecked( 0, 2, AHKID )
	_RegW("Copy.ahk_***",IsCheck)
}else if (ItemPos = "OptionsMenu4"){ ;自动捕捉 AutoCapture
	Menu,%A_ThisMenu%,ToggleCheck,%A_ThisMenuItem%
	IsCheck:=IsMenuItemChecked( 0, 4, AHKID )
	if (IsCheck=0) {
		SetTimer,GetPos,Off
		GuiControl,,Pic,%A_Temp%\Full.ico
		WinSetTitle,ahk_id %AHKID%,,%AHKInfo_Title%
	}else{
		SetTimer,GetPos,On
		WinSetTitle,ahk_id %AHKID%,,(自动)%AHKInfo_Title%
	}
	_RegW("AutoCapture",IsCheck)
}else
	MsgBox,%ItemPos%
return

GuiOnTop: ;窗口置顶
;为了能选中菜单项又能触发它的事件!我只想到这种貌似有效又简单的方法
WinMenuSelectItem,ahk_id %AHKID%,,1&,1&
return

Copy_ahk_T: ;切换复制时带上 ahk_*** 
WinMenuSelectItem,ahk_id %AHKID%,,1&,3&
return

AutoCapture: 	;自动捕捉 AutoCapture
WinMenuSelectItem,ahk_id %AHKID%,,1&,5&
return



ListView_DoubleClick:	;双击列表复制
if (A_GuiControlEvent="DoubleClick"){ ;只有是双击时才触发
	Gui, 1:ListView,%A_GuiControl% ;切换下面的列表命令对应的列表控件,A_GuiControl包含了当前点击的控件关联变量名
	LV_GetText(LV_Text,A_EventInfo ,2) ;获取选中的项目第二列的内容,A_EventInfo包含了当前选中的行数
	if (LV_Text!=""){ ;如果内容不为空
		ahk_x= ;定义一个变量,(我也不知道要不要这样)
		if (A_GuiControl="ListView1"){ ;如果是指定的控件
			;检查是否选中 复制时带 ahk_
			IsCheck:=IsMenuItemChecked( 0, 2, AHKID ) ;所检查的菜单位置: 第一个菜单第三个项目
			if (IsCheck=1){ ;如果菜单项是选中状态
				if (A_EventInfo=2) ;
					ahk_x:="ahk_class "
				if (A_EventInfo=3)
					ahk_x:="ahk_id "
				if (A_EventInfo=9)
					ahk_x:="ahk_pid "
				if (A_EventInfo=10)
					ahk_x:="ahk_exe "
			}
		}
		Clipboard=%ahk_x%%LV_Text%
		_ToolTip("Clipboard= " Clipboard)
	}
}
return



;图标控件点击事件
Setico:
gosub,icoStart
;设置为空图标
GuiControl,,Pic,%Null_ico%
;设置鼠标指针为十字标
CursorHandle := DllCall( "LoadCursorFromFile", Str,Cross_CUR )
DllCall( "SetSystemCursor", Uint,CursorHandle, Int,32512 )
SetTimer,GetPos,On
;等待左键弹起
KeyWait,LButton
SetTimer,GetPos,Off
Gui, 2:Destroy
;还原鼠标指针
DllCall( "SystemParametersInfo", UInt,0x57, UInt,0, UInt,0, UInt,0 )
;图标设置为原样
GuiControl,,Pic,%Full_ico%
return

GetPos:
MouseGetPos,OutX,OutY,OutWin3,OutCtrl1	;取鼠标下信息
if (OutWin3!=AHKID){ ;不获取自身..
;==============设置窗口列表的数据===================
;~ OutWin1=		;标题
;~ OutWin2=		;类名
;~ OutWin3=		;句柄
;~ OutWin4=		;窗口坐标
;~ OutWin5=		;窗口大小
;~ OutWin6=		;窗口点击
;~ OutWin7=		;窗口样式
;~ OutWin8=		;窗口扩展样式
;~ OutWin9=		;进程PID
;~ OutWin10=		;进程名
;~ OutWin11=		;进程路径
;===========================================
	Gui, 1:ListView,ListView1	;切换到窗口列表以设置数据
	GuiControlGet,TABVar,,TAB1
	WinGetTitle,OutWin1,ahk_id %OutWin3%	;取鼠标下窗口标题
	GuiControl,,Title,%OutWin1%
	WinGetClass,OutWin2,ahk_id %OutWin3%	;取鼠标下窗口类名
	WinGetPos,WinX,WinY,WinW,WinH,ahk_id %OutWin3% ;取鼠标下窗口坐标/大小
	OutWin4=%WinX%,%WinY%
	OutWin5=%WinW%,%WinH%
	OutWin6_X:=OutX-WinX
	OutWin6_Y:=OutY-WinY
	OutWin6=x%OutWin6_X% y%OutWin6_Y%
	WinGet,OutWin7, Style,ahk_id %OutWin3%	;窗口样式
	WinGet,OutWin8, ExStyle,ahk_id %OutWin3%	;窗口扩展样式
	WinGet,OutWin9,PID,ahk_id %OutWin3%	;窗口进程PID
	WinGet,OutWin10,ProcessName,ahk_id %OutWin3%	;窗口进程名
	WinGet,OutWin11,ProcessPath,ahk_id %OutWin3%	;窗口进程路径

	Loop,%ListView1_Text_A0% 	
		LV_Modify(A_Index,"Col2",OutWin%A_Index%)	
	LV_ModifyCol()
;=============设置控件列表的数据===================

;~ OutCtrl1=		;控件类别名
;~ OutCtrl2=		;控件文本
;~ OutCtrl3=		;控件编号
;~ OutCtrl4=		;控件句柄
;~ OutCtrl5=		;控件坐标
;~ OutCtrl6=		;控件大小
;~ OutCtrl7=		;控件内点击坐标
;~ OutCtrl8=		;控件样式
;~ OutCtrl9=		;控件扩展样式
;===========================================
	Gui, 1:ListView,ListView2	;切换到控件列表以设置数据
	if (OutCtrl1!=""){ ;如果控件类别名不为空

		
		ControlGetText,OutCtrl2,%OutCtrl1%,ahk_id %OutWin3%	;获取控件文本
		ControlGet,OutCtrl4,Hwnd,,%OutCtrl1%,ahk_id %OutWin3%	;控件句柄
		OutCtrl3 := DllCall("GetDlgCtrlID", uint, OutCtrl4)	;控件ID
		if (OutCtrl3<=0) ;如果获取的控件ID小于0就把控件ID变量置空
			OutCtrl3=
		ControlGetPos,OutCtrlX,OutCtrlY,OutCtrlW,OutCtrlH,%OutCtrl1%,ahk_id %OutWin3%	;控件坐标/大小
		if (OutCtrlX!="") {
			OutCtrl5=%OutCtrlX%,%OutCtrlY%
			OutCtrl6=%OutCtrlW%,%OutCtrlH%
		}else{
			OutCtrl5=
			OutCtrl6=
		}
		if (OutCtrl6!="") { 	;控件内点击坐标
			if (OutX-(WinX+OutCtrlX)>=0) {
				OutCtrl7_X:=OutX-(WinX+OutCtrlX)
				OutCtrl7_Y:=OutY-(WinY+OutCtrlY)
				OutCtrl7=x%OutCtrl7_X% y%OutCtrl7_Y%
			}else{
				OutCtrl7=
			}
		}else{
			OutCtrl7=
		}
		ControlGet,OutCtrl8,Style,,%OutCtrl1%,ahk_id %OutWin3%	;控件样式
		ControlGet,OutCtrl9,ExStyle,,%OutCtrl1%,ahk_id %OutWin3%	;控件扩展样式
		;上面所获取的数据变量名都设置为 同变量名+序号 是为了这里能两句命令就能解决复赋值问题

		Loop,%ListView2_Text_A0% 	
			LV_Modify(A_Index,"Col2",OutCtrl%A_Index%)	
		LV_ModifyCol() ;重新调整列宽
		if (TABVar=1) ;如果当前标签是第1个,
			GuiControl, Choose, Tab1,2 ;激活第2个标签页
		;===========================================
	}else{
		Gui, 2:Destroy
		;如果控件类别名为空的,控件标签页中全部置空
		Loop,%ListView2_Text_A0% 	
			LV_Modify(A_Index,"Col2","")	
		if (TABVar=2) ;如果当前标签是第2个,
			GuiControl, Choose, Tab1,1 ;激活第1个标签页
	}
;===========================================
		Gui, 1:ListView,ListView3 ;切换到列表控件3
		PixelGetColor,Color,%OutX%,%OutY%,Alt Slow RGB ;获取鼠标下RGB颜色值
		LV_Modify(1,"Col2",OutX "," OutY) 
		LV_Modify(2,"Col2",Color)
		LV_ModifyCol()
;=============设置可见文本的数据===================
DetectHiddenText,Off 
WinGetText,OutWinText_Visible,ahk_id %OutWin3%
GuiControl,,Visible_text,%OutWinText_Visible%
;=============设置全部文本的数据===================
DetectHiddenText,On 
WinGetText,OutWinText_Hidden,ahk_id %OutWin3%
GuiControl,,Hidden_text,%OutWinText_Hidden%
}
;==================================================Hidden_text
return


_MenuIsCheck( ThisMenu, ThisMenuItem, ValueName) { ;从注册表读取属性
	RegRead,ThisCheck,HKCU,Software\AutoHotKey\AHKInfo,%ValueName%
	if (ThisCheck=1) {
		Menu,%ThisMenu%,Check,%ThisMenuItem%
		errorLevel=1
	}else if (ThisCheck=0) {
		Menu,%ThisMenu%,UnCheck,%ThisMenuItem%
		errorLevel=0
	}else
		errorLevel=-1
}

_RegW( ValueName, value ) { ;写注册表
RegWrite,REG_DWORD ,HKCU,Software\AutoHotKey\AHKInfo,%ValueName%,%value%
}
_RegR( ValueName) {	;读注册表
RegRead,Outvalue,HKCU,Software\AutoHotKey\AHKInfo,%ValueName%
return %Outvalue%
}

IsMenuItemChecked( MenuPos, SubMenuPos, hWnd ) { ; 检查菜单项是否选中,返回1或0
 hMenu :=DllCall("GetMenu", UInt,hWnd )
 hSubMenu := DllCall("GetSubMenu", UInt,hMenu, Int,MenuPos )
 VarSetCapacity(mii, 48, 0), NumPut(48, mii, 0), NumPut(1, mii, 4)
 DllCall( "GetMenuItemInfo", UInt,hSubMenu, UInt,SubMenuPos, Int, 1, UInt,&mii )
Return ( NumGet(mii, 12) & 0x8 ) ? 1 : 0
}

EmptyMem(PID="AHK Rocks"){
pid:=(pid="AHK Rocks") ? DllCall("GetCurrentProcessId") : pid
h:=DllCall("OpenProcess", "UInt", 0x001F0FFF, "Int", 0, "Int", pid)
DllCall("SetProcessWorkingSetSize", "UInt", h, "Int", -1, "Int", -1)
DllCall("CloseHandle", "Int", h) 
}

_ToolTip(Text,OutTime=3000) { ;自动消失的ToolTip
	ToolTip,%Text%
	SetTimer, RemoveToolTip, %OutTime%
}

RemoveToolTip:
SetTimer, RemoveToolTip, Off
ToolTip
return