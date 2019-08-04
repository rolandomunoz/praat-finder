# Filter a search table
#
# Written by Rolando Munoz A. (15 Sep 2017)
#
# This script is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# A copy of the GNU General Public License is available at
# <http://www.gnu.org/licenses/1>.
#
include ../procedures/config.proc
include ../procedures/get_tier_number.proc

@config.init: "../preferences.txt"
if fileReadable("../temp/search.Table")
  search = Read from file: "../temp/search.Table"
  Append column: "temp"
else
  writeInfoLine: "Make a search first"
  exitScript()
endif

# Open the table containig all the tier names, then remove it before being displayed by the pause window
tb_all_tiers = Read from file: "../temp/tier_summary.Table"
n = Object_'tb_all_tiers'.nrow
for i to n
  tier_name$[i]= object$[tb_all_tiers, i, "tier"]
endfor
removeObject: tb_all_tiers

beginPause: "Filter search"
  sentence: "Folder_with_annotation_files", config.init.return$["textgrids_dir"]
    optionMenu: "Tier name", number(config.init.return$["filter_search.tier_name_option"])
    for i to n
      option: tier_name$[i]
    endfor
  sentence: "Search for (Regex)", config.init.return$["filter_search.search_for"]
  comment: "If the search is successful, then..."
  optionMenu: "Do", number(config.init.return$["filter_search.do"])
    option: "Nothing"
    option: "View & Edit files..."
    option: "Extract files..."
    option: "Filter search..."
clicked = endPause: "Cancel", "Apply", "Ok", 3

if clicked = 1
  exitScript()
endif

@config.setField: "filter_search.tier_name_option", string$(tier_name)
@config.setField: "filter_search.search_for", search_for$
@config.setField: "filter_search.do", string$(do)
tier_name$ = tier_name$[tier_name]

for i to Object_'search'.nrow
  getTierNumber.return[tier_name$] = 0
  file_path$ = object$[search, i, "path"]
  file_path$ = folder_with_annotation_files$ + "/" + file_path$
  tmin = object[search, i, "tmin"]
  tmax = object[search, i, "tmax"]
  tmid = (tmax + tmin)*0.5
  tg = Read from file: file_path$
  @getTierNumber
  tier = getTierNumber.return[tier_name$]
  if tier
    interval = Get interval at time: tier, tmid
    interval_label$ = Get label of interval: tier, interval
    if index_regex(interval_label$, search_for$)
      selectObject: search
      Set numeric value: i, "temp", 1
    endif
  endif
  removeObject: tg
endfor
selectObject: search
search_extracted = nowarn Extract rows where column (number): "temp", "equal to", 1
Rename: "search"
Remove column: "temp"

removeObject: search
writeInfoLine: "Filter search..."
appendInfoLine: "Search pattern: ", search_for$
appendInfoLine: "Tier name: ", tier_name$
appendInfoLine: "Total number of occurrences: ", object[search_extracted].nrow

if object[search_extracted].nrow
  @config.setField: "open_file.row", "1"
  selectObject: search_extracted
  Save as text file: "../temp/search.Table"
  removeObject: search_extracted
  
  scriptName$[2] = "open_files.praat"
  scriptName$[3] = "extract_files.praat"
  scriptName$[4] = "filter_search.praat"
  if do > 1
    runScript: scriptName$[do]
  endif
endif

if clicked = 2
  runScript: "filter_search.praat"
endif
