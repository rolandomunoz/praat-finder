# Search 
#
# Written by Rolando Munoz A. (aug 2017)
# Last modified on 24 Feb 2021
#
# This script is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# A copy of the GNU General Public License is available at
# <http://www.gnu.org/licenses/>.
#

tempObject# = selected#()
@config.init: "../preferences.txt" 

if not fileReadable("../temp/index.Table")
	writeInfoLine: "Search"
	appendInfoLine: "Message: Create an index first. In the plug-in menu, go to ""Do > Create index..."""
	exitScript()
endif

tb_all_tiers = Read from file: "../temp/tier_summary.Table"
numberOfRows = object[tb_all_tiers].nrow
for i to numberOfRows
	tier_name$[i]= object$[tb_all_tiers, i, "tier"]
endfor
removeObject: tb_all_tiers

selectObject: tempObject#

beginPause: "Search"
	optionMenu: "Tier name", number(config.init.return$["search.tier_name_option"])
		for i to numberOfRows
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
		option: ""
		option: "View & Edit files..."
		option: "Extract files..."
		option: "Filter search..."
		option: "Search report"	
		option: "Frequency report"
clicked = endPause: "Cancel", "Apply", "Ok", 3

if clicked = 1
	exitScript()
endif

@config.setField: "search.tier_name_option", string$(tier_name)
@config.setField: "search.search_for", search_for$
@config.setField: "search.mode", string$(mode)
@config.setField: "search.do", string$(do)
@config.setField: "open_file.row", "1"

# Scripts name
scriptName$# = {"", "open_files.praat", "extract_files-dialog.praat", "filter_search.praat", "report_search.praat", "report_frequency.praat"}
freqColumnName$ = "Frequency"

# Make a search
table_basename$ = "index_" + tier_name$[tier_name] + ".Table"
table_path$ = "../temp/" + table_basename$
tb_tier = Read from file: table_path$
tb_search = nowarn Extract rows where column (text): "text", mode$, search_for$
n_cases = object[tb_search].nrow

Save as text file: "../temp/search.Table"

## Print Info
writeInfoLine: "Search... Done!"
appendInfoLine: "Search for: ", search_for$
appendInfoLine: "Tier name: ", tier_name$
appendInfoLine: "Total number of occurrences: ", n_cases

# Do
if n_cases
	selectObject: tb_search
	if do > 1
		runScript: scriptName$#[do]
	endif
endif

removeObject: tb_tier, tb_search

if clicked = 2
	runScript: "search.praat"
endif

include ../procedures/config.proc
