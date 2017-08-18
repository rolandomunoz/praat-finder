# Copyright 2017 Rolando Muñoz

clearinfo
stringsID = Read Strings from raw text file: "../cpran.yaml"
nStrings = Get number of strings

for iString to nStrings
    line$ = Get string: iString
    appendInfoLine: line$
endfor

removeObject: stringsID
