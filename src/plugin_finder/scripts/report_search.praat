# Search 
#
# Written by Rolando Munoz A. (Sep 2019)
# Last modified on 10 Sep 2019
#
# This script is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# A copy of the GNU General Public License is available at
# <http://www.gnu.org/licenses/>.
#

tb_search_path$= "../temp/search.Table"
fileExists= fileReadable(tb_search_path$)
if fileExists
  tb_search = Read from file: tb_search_path$
  Rename: "Search_report"
else
  writeInfoLine: "Search"
  appendInfoLine: "Message: Create an index first. In the plug-in menu, go to ""Do > Create index..."""
endif
