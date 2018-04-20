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
fileName$ = chooseReadFile$: "Open a tab separated file"
if fileName$ <> ""
  tb = Read Table from tab-separated file: fileName$
  selectObject: tb
  Save as text file: "../temp/query.Table"
  writeInfoLine: "Import query"
  appendInfoLine: "Message: Done!"
else
  exitScript()
endif
