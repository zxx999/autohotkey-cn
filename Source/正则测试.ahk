Gui, Add, Edit, x16 y10 w450 h20 vRegular gGoMatch,Regular
Gui, Add, Edit, x16 y50 w450 h130 vHaystack gGoMatch,Haystack
Gui, Add, Edit, x16 y204 w450 h160 vResult, Result
Gui, Show, x299 y167 h379 w479, RegExMatchTest
Return
GuiClose:
ExitApp

GoMatch:
Gui,Submit,Nohide
OutPut=
FoundPos:=RegExMatch(Haystack,Regular,OutPut)
;如果FoundPos为空则把它内容设置为Error,如果不是就把:后的FoundPos弄进前的FoundPos中
FoundPos:=(FoundPos="") ? "Error" : FoundPos
Msg=[%FoundPos%] %OutPut%
GuiControl,,Result,%Msg%
Return