# Open a TextGrid and optionally a Sound in the TextGridEditor
#
# Written by Rolando Muñoz A. (08 Sep 2017)
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
include ../procedures/get_tier_number.proc

@config.init: "../.preferences.txt"
recursive_search = number(config.init.return$["create_index.recursive_search"])

beginPause: "View & Edit files"
  comment: "Input:"
  comment: "The directories where your files are stored..."
  sentence: "Textgrid folder", config.init.return$["textgrids_dir"]
  sentence: "Audio folder", config.init.return$["sounds_dir"]
  boolean: "Relative to TextGrid paths", 1
  word: "Audio extension", ".wav"
  comment: "Output:"
  comment: "Display settings..."
  real: "Margin", number(config.init.return$["open_file.margin"])
  boolean: "Add notes", 0
clicked = endPause: "Continue", "Quit", 1

if clicked = 2
  exitScript()
endif

@config.setField: "textgrids_dir", textgrid_folder$
@config.setField: "sounds_dir", audio_folder$
@config.setField: "open_file.margin", string$(margin)

queryDir$ = preferencesDirectory$ + "/local/query.Table"

if !fileReadable(queryDir$)
  pauseScript: "finder: Make a query first"
  exitScript()
endif

query = Read from file: queryDir$
nrow = Object_'query'.nrow
if !nrow
  pauseScript: "No files in the query"
  exitScript()
endif

row = number(config.init.return$["open_file.row"])
while 1
  row = if row > nrow then 1 else row fi

  #Get info from the query table
  text$ = object$[query, row, "text"]
  tgPath$ = textgrid_folder$ + "/" + object$[query, row, "file_path"]

  if relative_to_TextGrid_paths
    filename$ = object$[query, row, "filename"]
    tgName$ = filename$ + ".TextGrid"
    sdPath$ = (tgPath$ - tgName$) + audio_folder$ + "/" + filename$ + audio_extension$
  else
    sdName$ = object$[query, row, "filename"] + audio_extension$
    sdPath$ = audio_folder$ + "/" + sdName$
  endif

  tmin = object[query, row, "tmin"]
  tmax = object[query, row, "tmax"]
  tmid = (tmax - tmin)*0.5 + tmin
  tier$ = object$[query, row, "tier"]

  #Display
  tg = Read from file: tgPath$
  @getTierNumber
  tier = getTierNumber.return[tier$]
  sd = 0
  
  if fileReadable(sdPath$)
    sd = Open long sound file: sdPath$
    plusObject: tg
  endif

  View & Edit
  editor: tg
  for i to tier - 1
    Select next tier
  endfor
  
  Select: tmin - margin, tmax + margin
  Zoom to selection
  Move cursor to: tmid

  beginPause: "finder"
    if add_notes
      sentence: "Notes", object$[query, row, "notes"]
    endif
    comment: "Case: 'row'/'nrow'"
    comment: "Text: " + if length(text$)> 25 then left$(text$, 25) + "..." else text$ fi
    comment: "File name: " + object$[query, row, "filename"]
    natural: "Next case",  if (row + 1) > nrow then 1 else row + 1 fi
  clicked = endPause: "Continue", "Save", "Quit", 1
  endeditor

  if add_notes
    selectObject: query
    Set string value: row, "notes", notes$
    Save as text file: queryDir$
  endif

  if clicked = 2
    selectObject: tg
    Save as text file: tgPath$
  endif
  
  removeObject: tg
  if sd
    removeObject: sd
  endif
  @config.setField: "open_file.row", string$(row)
  row = next_case

  if clicked = 3
    removeObject: query
    exitScript()
  endif
endwhile