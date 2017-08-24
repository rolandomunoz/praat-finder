# Copyright 2017 Rolando Muñoz Aramburú

include ../procedures/config.proc

@config.init: "../.preferences"

beginPause: "index"
  sentence: "Textgrid folder", config.init.return$["textgrids_dir"]
  word: "Tier name", config.init.return$["tier_name"]
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

@config.setField: "textgrids_dir", textgrid_folder$
@config.setField: "tier_name", tier_name$
@config.setField: "match_pattern", search_for$

fileList = Create Strings as file list: "fileList", textgrid_folder$ + "/*.TextGrid"

selectObject: fileList
n = Get number of strings

if !n
  pauseScript: "The source folder does not contain any TextGrid file"
  exitScript()
endif

for i to n
  filename$ = object$[fileList, i]
  tgDir$ = textgrid_folder$ + "/" + filename$

  tg = Read from file: tgDir$
  tb_tg = Down to Table: "no", 16, "yes", "yes"
  tb_tg.tier = nowarn Extract rows where column (text): "tier", "is equal to", tier_name$
  # if match_pattern$ matches the interval text, then add interval info to the index
  tb_tg.tier.interval[i] = nowarn Extract rows where column (text): "text", mode$[mode], search_for$

  Append column: "filename"
  Append column: "filename_directory"
  Formula: "filename_directory", """'tgDir$'"""
  Formula: "filename", """'filename$'"""
  removeObject: tg, tb_tg, tb_tg.tier
endfor
removeObject: fileList

for i to n
  if i = 1
    selectObject: tb_tg.tier.interval[i]
  else
    plusObject: tb_tg.tier.interval[i]
  endif
endfor

index = Append
Rename: "index"

for i to n
  removeObject: tb_tg.tier.interval[i]
endfor

if Object_'index'.nrow
  selectObject: index
  Save as text file: preferencesDirectory$ + "/local/index.Table"
else
  selectObject: index
  deleteFile: preferencesDirectory$ + "/local/index.Table"
  pauseScript: "The index is empty. Try again."
endif

pauseScript: "Completed successfully"