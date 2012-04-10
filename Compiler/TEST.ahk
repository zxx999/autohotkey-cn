VERSION_rc=%A_ScriptDir%\VERSION.rc
AHKFile=%A_ScriptDir%\测试对象.ahk

IniRead,Description,%AHKFile%,Res,Description,%A_Space%
IniRead,Version,%AHKFile%,Res,Version,%AHKVersion%
IniRead,Copyright,%AHKFile%,Res,Copyright,%A_Space%
StringReplace,Version_a,Version,`.,`,,All
		
FileDelete,%VERSION_rc%
File=
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

)
StrPutVar(file,eee,"cp0")
MsgBox,% eee

StrPutVar(string, ByRef var, encoding)
{
    ; 确定容量.
    VarSetCapacity( var, StrPut(string, encoding)
        ; StrPut 返回字符数, 但 VarSetCapacity 需要字节数.
        * ((encoding="utf-16"||encoding="cp1200") ? 2 : 1) )
    ; 复制或转换字符串.
    return StrPut(string, &var, encoding)
}
