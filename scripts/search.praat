# Search 
#
# Written by Rolando Munoz A. (aug 2017)
# Last modified on 4 Aug 2019
#
# This script is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# A copy of the GNU General Public License is available at
# <http://www.gnu.org/licenses/>.
#
include ../procedures/config.proc

@config.init: "../preferences.txt"

if not fileReadable("../temp/index.Table")
  writeInfoLine: "Search"
  appendInfoLine: "Message: Create an index first. In the plug-in menu, go to ""Do > Create index..."""
  exitScript()
endif

tb_all_tiers = Read from file: "../temp/tier_summary.Table"
n = Object_'tb_all_tiers'.nrow
for i to n
  tier_name$[i]= object$[tb_all_tiers, i, "tier"]
endfor
removeObject: tb_all_tiers

beginPause: "Search"
  optionMenu: "Tier name", number(config.init.return$["search.tier_name_option"])
    for i to n
      option: tier_name$[i]
    endfor
  sentence: "Search for", config.init.return$["search.search_for"]
  optionMenu: "Mode", number(config.init.return$["search.mode"])
    option: "is equal to"
    option: "is not equal to"
    option: "contains"
    option: "does not contain"
    option: "starts with"
    option: "does not start with"
    option: "ends with"
    option: "does not end with"
    option: "contains a word equal to"
    option: "does not contain a word equal to"
    option: "contains a word starting with"
    option: "does not contain a word starting with"
    option: "contains a word ending with"
    option: "does not contain a word ending with"
    option: "matches (regex)"
    comment: "If the search is successful, then..."
  optionMenu: "Do", number(config.init.return$["search.do"])
    option: "Nothing"
    option: "View & Edit files..."
    option: "Extract files..."
    option: "Filter search..."
clicked = endPause: "Cancel", "Apply", "Ok", 3

if clicked = 1
  exitScript()
endif

@config.setField: "search.tier_name_option", string$(tier_name)
@config.setField: "search.search_for", search_for$
@config.setField: "search.mode", string$(mode)
@config.setField: "search.do", string$(do)
@config.setField: "open_file.row", "1"

# Make a search

tb_tier = Read from file: "../temp/" + "index_" + tier_name$[tier_name] + ".Table"
tb_search = nowarn Extract rows where column (text): "text", mode$, search_for$
Rename: "search_" + search_for$
Save as text file: "../temp/search.Table"

# Print Search Summary content
tb_search_unique = Collapse rows: "text", "", "", "", "", ""
infoSearch$ = List: 1
infoSearch$ = replace$(infoSearch$, "row	text", "Search Summary: ", 1)
removeObject: tb_tier, tb_search_unique
selectObject: tb_search

# Print
## Print Info
writeInfoLine: "Search"
appendInfoLine: "Search pattern: ", search_for$
appendInfoLine: "Tier name: ", tier_name$
appendInfoLine: "Total number of occurrences: ", object[tb_search].nrow

## Print Search Summary
appendInfoLine: "_________________________________________________"
appendInfo: infoSearch$

if object[tb_search].nrow
  scriptName$[2] = "open_files.praat"
  scriptName$[3] = "extract_files.praat"
  scriptName$[4] = "filter_search.praat"
  if do > 1
    runScript: scriptName$[do]
  endif
endif

if clicked = 2
  runScript: "search.praat"
endif
