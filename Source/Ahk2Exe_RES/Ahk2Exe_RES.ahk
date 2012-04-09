
/****************预编译程序参数******************
[Compiler]
Exe_Ico=
Exe_OutName=
Exe_Bin=
Exe_mpress=1
[Res]
Description=自定义编译器
Version=1.0.0.0
Copyright=by 星雨朝霞
首要图标
Del_ICON_Main=
源码脚本图标
Del_ICON_Shortcut=
挂起图标
Del_ICON_Suspend=
暂停图标
Del_ICON_pause=
同时挂起与暂停图标
Del_ICON_S_P=
Win9x系统托盘首要图标
Del_ICON_Maim9x=1
Win9x系统挂起图标
Del_ICON_Suspend9x=1
托盘首要图标
Del_ICON_Tray=
默认快捷键
Del_key=1
默认对话框
Del_Dialog=1
默认菜单
Del_Menu=1
*/ ;==============================脚本开始====================================
#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
#NoTrayIcon
DllCall("AllocConsole")
;~ stdout := FileOpen(DllCall("GetStdHandle", "int", -11, "ptr"), "h `n")
;~ stdout := DllCall("GetStdHandle", "int", -11, "ptr")
WriteLine("+> 编译初始化...")
ResHacker=%A_ScriptDir%\ResHacker.exe
GoRC=%A_ScriptDir%\GoRC.exe
iconv=%A_ScriptDir%\iconv.exe
FileInstall,GoRC.exe,%GoRC%
FileInstall,ResHacker.exe,%ResHacker%
FileInstall,iconv.exe,%iconv%
AHKFile=%1%
IfNotExist,%AHKFile%
    ExitApp
SplitPath,AHKFile,AHKFile_Name,AHKFile_Dir,AHKFile_Ext,AHKFile_NameNoExt

IniRead,Exe_Ico,%AHKFile%,Compiler,Exe_Ico,%A_Space%
IniRead,Exe_OutName,%AHKFile%,Compiler,Exe_OutName,%A_Space%
IniRead,Exe_Bin,%AHKFile%,Compiler,Exe_Bin,%A_Space%
IniRead,Exe_mpress,%AHKFile%,Compiler,Exe_mpress,%A_Space%
if Exe_Ico!=
    SplitPath,Exe_Ico,,,Exe_Ico_Ext
    If Exe_Ico_Ext=ico
        Exe_Ico= /icon "%Exe_Ico%"
if Exe_OutName=
    Exe_OutName=%AHKFile_Dir%\%AHKFile_NameNoExt%.exe
if Exe_Bin!=
    Exe_Bin= /bin "%Exe_Bin%"

CompilerC= /in "%AHKFile%" %Exe_Ico% /out "%Exe_OutName%" %Exe_Bin% /mpress 0

ahk2exe=%A_ScriptDir%\ahk2exe.exe
IfExist,%ahk2exe%
{
    WriteLine("+> 正在编译...")
    RunWait,"%ahk2exe%" %CompilerC%
    If FileExist(ResHacker) && FileExist(Exe_OutName)
    {
        WriteLine("+> 正在处理预编译参数...")
        IniRead,Description,%AHKFile%,Res,Description,%A_Space%
        FileGetVersion,AHKVersion,%A_ScriptDir%\..\AutoHotkey.exe
        if ErrorLevel
            AHKVersion=0.0.0.0
        IniRead,Version,%AHKFile%,Res,Version,%AHKVersion%
        IniRead,Copyright,%AHKFile%,Res,Copyright,%A_Space%
        StringReplace,Version_a,Version,`.,`,,All
        VERSION_rc=%A_ScriptDir%\VERSION.rc
        FileDelete,%VERSION_rc%
        FileAppend,
        (
        1 VERSIONINFO
        FILEVERSION %Version_a%
        PRODUCTVERSION %Version_a%
        FILEOS 0x4
        FILETYPE 0x1
        {
        BLOCK "StringFileInfo"
        {
            BLOCK "040904b0"
            {
                VALUE "FileDescription", "%Description%"
                VALUE "FileVersion", "%Version%"
                VALUE "InternalName", ""
                VALUE "LegalCopyright", "%Copyright%"
                VALUE "OriginalFilename", ""
                VALUE "ProductName", ""
                VALUE "ProductVersion", "%Version%"
            }
        }

        BLOCK "VarFileInfo"
        {
            VALUE "Translation", 0x0409 0x04B0
        }
        }

        ),%VERSION_rc%,CP936
        IniRead,Del_ICON_Main,%AHKFile%,Res,Del_ICON_Main,%A_Space%
        IniRead,Del_ICON_Shortcut,%AHKFile%,Res,Del_ICON_Shortcut,%A_Space%
        IniRead,Del_ICON_Suspend,%AHKFile%,Res,Del_ICON_Suspend,%A_Space%
        IniRead,Del_ICON_pause,%AHKFile%,Res,Del_ICON_pause,%A_Space%
        IniRead,Del_ICON_S_P,%AHKFile%,Res,Del_ICON_S_P,%A_Space%
        IniRead,Del_ICON_Maim9x,%AHKFile%,Res,Del_ICON_Maim9x,%A_Space%
        IniRead,Del_ICON_Suspend9x,%AHKFile%,Res,Del_ICON_Suspend9x,%A_Space%
        IniRead,Del_ICON_Tray,%AHKFile%,Res,Del_ICON_Tray,%A_Space%
        IniRead,Del_key,%AHKFile%,Res,Del_key,%A_Space%
        IniRead,Del_Dialog,%AHKFile%,Res,Del_Dialog,%A_Space%
        IniRead,Del_Menu,%AHKFile%,Res,Del_Menu,%A_Space%
        if Del_ICON_Main!=
            Del_ICON_Main=-delete ICONGROUP,159,1033
        else
            Del_ICON_Main=
        if Del_ICON_Shortcut!=
            Del_ICON_Shortcut=-delete ICONGROUP,160,1033
        else
            Del_ICON_Shortcut=
        if Del_ICON_Suspend!=
            Del_ICON_Suspend=-delete ICONGROUP,206,1033
        else
            Del_ICON_Suspend=
        if Del_ICON_pause!=
            Del_ICON_pause=-delete ICONGROUP,207,1033
        else
            Del_ICON_pause=
        if Del_ICON_S_P!=
            Del_ICON_S_P=-delete ICONGROUP,208,1033
        else
            Del_ICON_S_P=
        if Del_ICON_Maim9x!=
            Del_ICON_Maim9x=-delete ICONGROUP,228,1033
        else
            Del_ICON_Maim9x=
        if Del_ICON_Suspend9x!=
            Del_ICON_Suspend9x=-delete ICONGROUP,229,1033
        else
            Del_ICON_Suspend9x=
        if Del_ICON_Tray!=
            Del_ICON_Tray=-delete ICONGROUP,230,1033
        else
            Del_ICON_Tray=
        if Del_key!=
            Del_key=-delete Accelerators,212,1033
        else
            Del_key=
        if Del_Dialog!=
            Del_Dialog=-delete Dialog,205,1033
        else
            Del_Dialog=
        if Del_Menu!=
            Del_Menu=-delete Menu,211,1033
        else
            Del_Menu=
        Res=%A_ScriptDir%\Res.script
        FileDelete,%Res%
        FileAppend,//ANSI,%Res%
        IniWrite,%Exe_OutName%,%Res%,FILENAMES,Exe
        IniWrite,%Exe_OutName%,%Res%,FILENAMES,SaveAs
        FileAppend,
        (
            [COMMANDS]
            %Del_ICON_Main%
            %Del_ICON_Shortcut%
            %Del_ICON_Suspend%
            %Del_ICON_pause%
            %Del_ICON_S_P%
            %Del_ICON_Maim9x%
            %Del_ICON_Suspend9x%
            %Del_ICON_Tray%
            %Del_key%
            %Del_Dialog%
            %Del_Menu%
            -delete versioninfo,1,1033
            -addoverwrite VERSION.RES,,,
        ),%Res%
        WriteLine("+> 正在改写版本...")
        RunWait,"%iconv%" VERSION.rc -f utf-8 -t gb2312,%A_ScriptDir%,Hide
        RunWait,"%GoRC%" /r "%VERSION_rc%",%A_ScriptDir%,Hide
        RunWait,"%ResHacker%" -script "%Res%"
        FileDelete,%Res%
        FileDelete,ResHacker.log
        FileDelete,VERSION.rc
        FileDelete,VERSION.RES
        FileDelete,ResHacker.ini
        if FileExist(A_ScriptDir "\mpress.exe") && Exe_mpress
        {
            WriteLine("+> 正在压缩程序...")
            RunWait, "%A_ScriptDir%\mpress.exe" -q -x "%Exe_OutName%",, Hide
        }
    }
}
if A_IsCompiled
{
    FileDelete,%ResHacker%
    FileDelete,%GoRC%
    FileDelete,%iconv%
}
WriteLine("+> 编译完成!")

WriteLine(Line){
;~ stdout.WriteLine(Line)
;~ stdout.Read(0) ; 刷新写入缓冲区.
}