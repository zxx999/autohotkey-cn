Haystack = The23quick45brown56fox67jumps88over9the90az887dog.
RegExMatch(Haystack, "(\d+)(?CFunction)")
Function(Match, CalloutNumber, FoundPos){

    MsgBox Match=%Match%`nCalloutNumber=%CalloutNumber%`nFoundPos=%FoundPos%
	Pos:=FoundPos+StrLen(Match)
	MsgBox,%pos%
    return 1
}