#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Recommended for catching common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
MsgBox,33,提示,
(
你是安装AutoHotkey_L吗?
还是卸载?
)
IfMsgBox,Ok
{
FileGetVersion,Version,AutoHotkey.exe
if !ErrorLevel
{
	IfExist,SciTE_rc1\SciTE.exe
	{
		RegWrite,REG_SZ,HKEY_LOCAL_MACHINE,SOFTWARE\AutoHotkey,InstallDir,%A_ScriptDir%
		RegWrite,REG_SZ,HKEY_LOCAL_MACHINE,SOFTWARE\AutoHotkey,Version,%Version%
		
		RegWrite,REG_SZ,HKEY_LOCAL_MACHINE,SOFTWARE\Classes\.ahk,,AutoHotkeyScript
		RegWrite,REG_SZ,HKEY_LOCAL_MACHINE,SOFTWARE\Classes\.ahk\ShellNew,FileName,%A_ScriptDir%\SciTE_rc1\脚本模板.ahk
		RegWrite,REG_SZ,HKEY_LOCAL_MACHINE,SOFTWARE\Classes\AutoHotkeyScript,,AutoHotkey 脚本
		RegWrite,REG_SZ,HKEY_LOCAL_MACHINE,SOFTWARE\Classes\AutoHotkeyScript\DefaultIcon,,%A_ScriptDir%\AutoHotkey.exe,1
		
		RegWrite,REG_SZ,HKEY_LOCAL_MACHINE,SOFTWARE\Classes\AutoHotkeyScript\Shell,,Open
		RegWrite,REG_SZ,HKEY_LOCAL_MACHINE,SOFTWARE\Classes\AutoHotkeyScript\Shell\Open,,运行脚本
		;~ Open =
		RegWrite,REG_SZ,HKEY_LOCAL_MACHINE,SOFTWARE\Classes\AutoHotkeyScript\Shell\Open\Command,,"%A_ScriptDir%\AutoHotkey.exe" "`%1" `%*
		RegWrite,REG_SZ,HKEY_LOCAL_MACHINE,SOFTWARE\Classes\AutoHotkeyScript\Shell\Compile,,编译脚本

		RegWrite,REG_SZ,HKEY_LOCAL_MACHINE,SOFTWARE\Classes\AutoHotkeyScript\Shell\Compile\Command,,"%A_ScriptDir%\Compiler\Ahk2Exe.exe" /in  "`%1"
		RegWrite,REG_SZ,HKEY_LOCAL_MACHINE,SOFTWARE\Classes\AutoHotkeyScript\Shell\Edit,,编辑脚本
		RegWrite,REG_SZ,HKEY_LOCAL_MACHINE,SOFTWARE\Classes\AutoHotkeyScript\Shell\Edit\Command,,"%A_ScriptDir%\SciTE_rc1\SciTE.exe" "`%1"
		刷新图标()
		MsgBox,0,提示,AHK_L 安装成功!
	}else
		MsgBox,16,出错,指定路径没有 SciTE_rc1\SciTE.exe
}else
	MsgBox,16,路径下没有 AutoHotkey.exe
}
IfMsgBox,Cancel
{
	RegDelete,HKEY_LOCAL_MACHINE,SOFTWARE\AutoHotkey
	RegDelete,HKEY_LOCAL_MACHINE,SOFTWARE\Classes\.ahk
	RegDelete,HKEY_LOCAL_MACHINE,SOFTWARE\Classes\AutoHotkeyScript
	刷新图标()
	MsgBox,卸载完成!
}


刷新图标(){
FileDelete,%A_Temp%\Tmpinf.inf
FileAppend,[Version]`nSignature="$Windows NT$"`n[DefaultInstall],%A_Temp%\Tmpinf.inf
run=RUNDLL32 SETUPAPI.DLL,InstallHinfSection DefaultInstall 128 %A_Temp%\Tmpinf.inf
RunWait,%run%
FileDelete,%A_Temp%\Tmpinf.inf

}