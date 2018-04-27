# Open a TextGrid and optionally a Sound in the TextGridEditor
#
# Written by Rolando Munoz A. (08 Sep 2017)
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

@config.init: "../preferences.txt"
recursive_search = number(config.init.return$["create_index.recursive_search"])

beginPause: "View & Edit files"
  comment: "The directories where your files are stored..."
  sentence: "Textgrid folder", config.init.return$["textgrids_dir"]
  sentence: "Audio folder", config.init.return$["sounds_dir"]
  comment: "Audio settings..."
  word: "Audio extension", ".wav"
  boolean: "Adjust sound level", number(config.init.return$["open_file.adjust_sound_level"])
  comment: "Display settings..."
  real: "Margin", number(config.init.return$["open_file.margin"])
  boolean: "Add notes", 0
clicked = endPause: "Cancel", "Apply", "Ok", 3

if clicked = 1
  exitScript()
endif

# Save in preferences
@config.setField: "textgrids_dir", textgrid_folder$
@config.setField: "sounds_dir", audio_folder$
@config.setField: "open_file.margin", string$(margin)
@config.setField: "open_file.adjust_sound_level", string$(adjust_sound_level)

# Initial variables
audio_folder$ = if audio_folder$ == "" then "." else audio_folder$ fi
relative_to_TextGrid_paths= if startsWith(audio_folder$, ".") then 1 else 0 fi
row = number(config.init.return$["open_file.row"])
pause = 1
queryDir$ = "../temp/query.Table"
volume = 0.99
adjust_sound_level_constant = adjust_sound_level

# Checking...

## Check dialogue box fields
if textgrid_folder$ == ""
  writeInfoLine: "View & Edit files"
  appendInfoLine: "Please, complete the Textgrid folder field"
  runScript: "open_files.praat"
  exitScript()
endif

## Check if a query is done
if !fileReadable(queryDir$)
  writeInfoLine: "View & Edit files"
  appendInfoLine: "Message: Make a query first"
  exitScript()
endif

## Check if the query table have recorded cases
query = Read from file: queryDir$
nrow = object[query].nrow
if !nrow
  writeInfoLine: "View & Edit files"
  appendInfoLine: "Message: Nothing to show. Please, make another query."
  exitScript()
endif

# Start pause window
while pause
  row = if row > nrow then 1 else row fi
  adjust_sound_level = adjust_sound_level_constant
  #Get info from the query table
  text$ = object$[query, row, "text"]
  tgPath$ = textgrid_folder$ + "/" + object$[query, row, "file_path"]

  if relative_to_TextGrid_paths
    baseName$ = object$[query, row, "filename"]
    tgName$ = baseName$ + ".TextGrid"
    sdPath$ = (tgPath$ - tgName$) + audio_folder$ + "/" + baseName$ + audio_extension$
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
    if adjust_sound_level
      sd = Read from file: sdPath$
      Scale peak: volume
    else
      sd = Open long sound file: sdPath$
    endif
    plusObject: tg
  else
    adjust_sound_level = 0
  endif

  View & Edit
  editor: tg
  for i to tier - 1
    Select next tier
  endfor
  
  Select: tmin - margin, tmax + margin
  Zoom to selection
  Move cursor to: tmid

  beginPause: "View & Edit files"
    if add_notes
      sentence: "Notes", object$[query, row, "notes"]
    endif
    comment: "Case: 'row'/'nrow'"
    comment: "Text: " + if length(text$)> 25 then left$(text$, 25) + "..." else text$ fi
    comment: "File name: " + object$[query, row, "filename"]
    natural: "Next case",  if (row + 1) > nrow then 1 else row + 1 fi
    if adjust_sound_level
      real: "Volume", volume
    endif
  clicked_finder = endPause: "Continue", "Save", "Quit", 1
  endeditor

  if add_notes
    selectObject: query
    Set string value: row, "notes", notes$
    Save as text file: queryDir$
  endif

  if clicked_finder = 2
    selectObject: tg
    Save as text file: tgPath$
  endif
  
  removeObject: tg
  if sd
    removeObject: sd
  endif
  @config.setField: "open_file.row", string$(row)
  row = next_case

  if clicked_finder = 3
    removeObject: query
    pause = 0
  endif
endwhile

if clicked = 2
  runScript: "open_files.praat"
endif