;
; File encoding:  UTF-8
; Platform:  Windows XP/Vista/7
; Author:    A.N.Other <myemail@nowhere.com>
;
; Script description:
;	Template script
;

#NoEnv
#NoTrayIcon
SendMode Input
SetWorkingDir, %A_ScriptDir%

if 0 = 0
	ExitApp

Loop,%0%
{
	param := %A_Index%
	Index:=A_Index+1
	param2 := %Index% 
	if param = /in
		ahk_a=%param2%
	if param = /gui
		ahk_g=gui
}
compiler_RES = ..\..\Compiler\Ahk2Exe_RES.ahk
compiler = ..\..\Compiler\Ahk2Exe.exe
AHK=..\..\AutoHotkey.exe
if ahk_a && FileExist(compiler_RES)
	RunWait,"%AHK%"  /ErrorStdOut  "%compiler_RES%" "%ahk_a%"

if ahk_a && ahk_g && FileExist(compiler_RES)
	RunWait,%compiler% "%ahk_a%"

;======================================================
;~ v2 = %2%
;~ if v2
	;~ v2 = /bin "%v2%"

;~ compiler = ..\..\Compiler\Ahk2Exe.exe
;~ if v2 && FileExist("..\..\AutoHotkey_L\Compiler\Ahk2Exe.exe")
	;~ compiler = ..\..\AutoHotkey_L\Compiler\Ahk2Exe.exe

;~ IfExist, ..\..\Compiler\Compile_AHK.exe
	;~ RunWait, ..\..\Compiler\Compile_AHK.exe "%1%"
;~ else
	;~ RunWait, %compiler% /in "%1%" %v2%
