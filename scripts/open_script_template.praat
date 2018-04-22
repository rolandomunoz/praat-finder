# Open script template
#
# Written by Rolando Munoz A. (April 2018)
#
# This script is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# A copy of the GNU General Public License is available at
# <http://www.gnu.org/licenses/>.
#
if !fileReadable("../temp/query.Table")
  writeInfoLine: "Open script template"
  appendInfoLine: "Message: Make a query first"
  exitScript()
endif

pref$ = readFile$("../preferences.txt")
tgFolder$ = extractLine$(pref$, "textgrids_dir: ")

preferencePath$ = defaultDirectory$ + "/../preferences.txt"
queryPath$ = defaultDirectory$ + "/../temp/query.Table"

script$ = readFile$("script_template_original.praat")
script$ = replace$(script$, "<TextGrid_folder>", tgFolder$, 1)
script$ = replace$(script$, "<query_path>", queryPath$, 1)

writeFile("../temp/script_template.praat", script$)
Read from file: "../temp/script_template.praat"
