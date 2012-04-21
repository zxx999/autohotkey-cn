#MButton::SoundSet, +1, , mute  ; 切换主静音 (设置到相反的状态)
#WheelUp::SoundSet,+3
#WheelDown::SoundSet,-3
#Ctrl::SoundSet, +1, , mute  ; 切换主静音 (设置到相反的状态)
#Up::SoundSet,+3
#Down::SoundSet,-3
#CapsLock:: ;小说下载阅读器隐显 自定义老板键
窗口条件=ahk_class ThunderRT6FormDC ahk_exe Book.exe
WinGet,Style1 ,Style,%窗口条件%
if (Style1&0x10000000) ;判断窗口是否包含WS_VISIBLE样式,就是可见
    WinHide,%窗口条件% ;可见时隐藏它
else{ ;如果不可见,就显示它并激活
    WinShow,%窗口条件%
    WinActivate,%窗口条件%
}
return 
