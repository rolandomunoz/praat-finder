# Query a table
#
# Written by Rolando Munoz A. (aug 2017)
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

tb_all_tiers = Read from file: "../temp/tier_summary.Table"
n = Object_'tb_all_tiers'.nrow
for i to n
  tier_name$[i]= object$[tb_all_tiers, i, "tier"]
endfor
removeObject: tb_all_tiers

beginPause: "Query by tier name"
  optionMenu: "Tier name", number(config.init.return$["query.tier_name_option"])
    for i to n
      option: tier_name$[i]
    endfor
  sentence: "Search for", config.init.return$["query.search_for"]
  optionMenu: "Mode", number(config.init.return$["query.mode"])
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
  optionMenu: "Do", number(config.init.return$["query.do"])
    option: "Nothing"
    option: "View & Edit files..."
    option: "Extract files..."
    option: "Filter query..."
clicked = endPause: "Cancel", "Apply", "Ok", 3

if clicked = 1
  exitScript()
endif

mode$[1] = "is equal to"
mode$[2] = "is not equal to"
mode$[3] = "contains"
mode$[4] = "does not contain"
mode$[5] = "starts with"
mode$[6] = "does not start with"
mode$[7] = "ends with"
mode$[8] = "does not end with"
mode$[9] = "contains a word equal to"
mode$[10] = "does not contain a word equal to"
mode$[11] = "contains a word starting with"
mode$[12] = "does not contain a word starting with"
mode$[13] = "contains a word ending with"
mode$[14] = "does not contain a word ending with"
mode$[15] = "matches (regex)"

@config.setField: "query.tier_name_option", string$(tier_name)
@config.setField: "query.search_for", search_for$
@config.setField: "query.mode", string$(mode)
@config.setField: "query.do", string$(do)
@config.setField: "open_file.row", "1"

# Make a query
tb_tier = Read from file: "../temp/" + "index_" + tier_name$[tier_name] + ".Table"
tb_query = nowarn Extract rows where column (text): "text", mode$[mode], search_for$
Rename: "query_" + search_for$
Save as text file: "../temp/query.Table"

# Print Search Summary content
tb_query_unique = Collapse rows: "text", "", "", "", "", ""
infoSearch$ = List: 1
infoSearch$ = replace$(infoSearch$, "row	text", "Search Summary: ", 1)
removeObject: tb_tier, tb_query_unique
selectObject: tb_query

# Print
## Print Info
writeInfoLine: "Query by tier name..."
appendInfoLine: "Search pattern: ", search_for$
appendInfoLine: "Tier name: ", tier_name$
appendInfoLine: "Total number of occurrences: ", object[tb_query].nrow

## Print Search Summary
appendInfoLine: "_________________________________________________"
appendInfo: infoSearch$

if object[tb_query].nrow
  scriptName$[2] = "open_files.praat"
  scriptName$[3] = "extract_files.praat"
  scriptName$[4] = "filter_query.praat"
  if do > 1
    runScript: scriptName$[do]
  endif
endif

if clicked = 2
  runScript: "query_by_tier_name.praat"
endif