# Query a table
#
# Written by Rolando Muñoz A. (aug 2017)
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

@config.init: "../.preferences"

tb_all_tiers = Read from file: "../../local/tier_summary.Table"
n = Object_'tb_all_tiers'.nrow
for i to n
  tier_name$[i]= object$[tb_all_tiers, i, "tier"]
endfor
removeObject: tb_all_tiers

beginPause: "index"
  optionMenu: "Tier_name", number(config.init.return$["tier_name_option"])
    for i to n
      option: tier_name$[i]
    endfor
  sentence: "Search for", config.init.return$["match_pattern"]
  optionMenu: "Mode", 1
    option: "is equal to"
    option: "is not equal to"
    option: "contains"
    option: "does not contain"
    option: "starts with"
    option: "does not start with"
    option: "ends with"
    option: "does not end with"
    option: "matches (regex)"
clicked = endPause: "Continue", "Quit", 1

mode$[1] = "is equal to"
mode$[2] = "is not equal to"
mode$[3] = "contains"
mode$[4] = "does not contain"
mode$[5] = "starts with"
mode$[6] = "does not start with"
mode$[7] = "ends with"
mode$[8] = "does not end with"
mode$[9] = "matches (regex)"

if clicked = 2
  exitScript()
endif

@config.setField: "tier_name_option", string$(tier_name)
@config.setField: "match_pattern", search_for$
@config.setField: "open_file.row", "1"

tb_tier = Read from file: "../../local/" + "index_" + tier_name$[tier_name] + ".Table"
tb_query = nowarn Extract rows where column (text): "text", mode$[mode], search_for$
Rename: "query"
number_of_cases = Object_'tb_query'.nrow

# Save query and remove objects
Save as text file: preferencesDirectory$ + "/local/query.Table"
removeObject: tb_tier
pauseScript: "'number_of_cases' items were found"