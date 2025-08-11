# Export search table
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
dir$ = "../temp/search.Table"

if fileReadable(dir$)
    tb = Read from file: dir$
else
    exitScript: "The search table couldn't be found"
endif

directory_name$ = chooseDirectory$: "Choose a directory to save the search table"
if directory_name$ <> ""
  filename$ ="search"
  suffix$ = ""
  counter = 1
  while fileReadable(directory_name$ + "/" + filename$ + suffix$ + ".txt")
    suffix$ = "_" + string$(counter)
    counter+=1
  endwhile
  Save as tab-separated file: directory_name$ + "/" + filename$ + suffix$ + ".txt"
  # Print message
  writeInfoLine: "Export search"
  appendInfoLine: "Message: Done!"
endif
