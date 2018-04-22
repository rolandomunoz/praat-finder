# Import query table
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
tb = selected("Table")

col$[1] = "tmin"
col$[2] = "tier"
col$[3] = "text"
col$[4] = "tmax"
col$[5] = "filename"
col$[6] = "file_path"
col$[7] = "notes"

numberOfColumns = 7
import = 1
for i to numberOfColumns
  isColumn= Get column index: col$[i]
  if not isColumn
    import = 0
    i = numberOfColumns
  endif
endfor

if import
  Save as text file: "../temp/query.Table"
  writeInfoLine: "Import query"
  appendInfoLine: "Message: Done!"

else
  writeInfoLine: "Import query"
  appendInfoLine: "Message: Cannot import table. Your table must contain (at least) the following columns:", newline$
  for i to numberOfColumns
    appendInfoLine: "- ", col$[i]
  endfor
endif