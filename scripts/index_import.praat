# Import search table
#
# Written by Rolando Munoz A. (14 Sep 2017)
#
# This script is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# A copy of the GNU General Public License is available at
# <http://www.gnu.org/licenses/1>.
#
fileName$ = chooseReadFile$: "Open a tab separated file"
if fileName$ == ""
  exitScript()
endif
tb = Read Table from tab-separated file: fileName$

# Column names
col$# = {"tmin", "tier", "text", "tmax", "path", "notes"}

import = 1
numberOfColumns = size(col$#)
for i to numberOfColumns
  isColumn= Get column index: col$#[i]
  if isColumn == 0
    import = 0
    i = numberOfColumns
  endif
endfor

if import
  Save as text file: "../temp/search.Table"
  writeInfoLine: "Import search"
  appendInfoLine: "Message: Done!"
else
  writeInfoLine: "Import search"
  appendInfoLine: "Message: Cannot import table. Your table must contain (at least) the following columns:", newline$
  for i to numberOfColumns
    appendInfoLine: "('i') ", col$#[i]
  endfor
endif
