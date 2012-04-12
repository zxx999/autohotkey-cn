Haystack = The quick brown fox jumps over the lazy dog.
RegExMatch(Haystack, "i)(The) (\w+)\b(?CCallout)")
Callout(m) {
    MsgBox m=%m%`nm1=%m1%`nm2=%m2%
    return 1
}