VERSION_rc=%A_ScriptDir%\VERSION.rc
AHKFile=%A_ScriptDir%\测试对象.ahk

IniRead,Description,%AHKFile%,Res,Description,%A_Space%
IniRead,Version,%AHKFile%,Res,Version,%AHKVersion%
IniRead,Copyright,%AHKFile%,Res,Copyright,%A_Space%
StringReplace,Version_a,Version,`.,`,,All
		
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

),%VERSION_rc%
