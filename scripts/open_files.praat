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

@config.init: "../.preferences"

beginPause: "index"
  comment: "Input:"
  comment: "The directories where your files are stored..."
  sentence: "Audio folder", config.init.return$["sounds_dir"]
  sentence: "Textgrid folder", config.init.return$["textgrids_dir"]
  boolean: "Relative path", 1
  word: "Audio extension", ".wav"
  comment: "Output:"
  comment: "Display settings..."
  real: "Margin", number(config.init.return$["open_file.margin"])
clicked = endPause: "Continue", "Quit", 1

if clicked = 2
  exitScript()
endif

@config.setField: "textgrids_dir", textgrid_folder$
@config.setField: "sounds_dir", audio_folder$
@config.setField: "open_file.margin", string$(margin)

indexDir$ = preferencesDirectory$+ "/local/index.Table"

if !fileReadable(indexDir$)
  pauseScript: "finder: Create an index first"
endif

index = Read from file: indexDir$
nrow = Object_'index'.nrow
if !nrow
  exitScript: "No files in the index"
endif

row = number(config.init.return$["open_file.row"])
while 1
  row = if row > nrow then 1 else row fi

  #Get info from index
  text$ = object$[index, row, "text"]
  tgName$ = object$[index, row, "filename"]
  sdName$ = tgName$ - ".TextGrid" + audio_extension$
  sdDir$ = audio_folder$ + "/" + sdName$
  tgDir$ = textgrid_folder$ + "/" + tgName$

  tmin = object[index, row, "tmin"]
  tmax = object[index, row, "tmax"]
  tmid = (tmax - tmin)*0.5 + tmin
  tier$ = object$[index, row, "tier"]

  #Display
  
  tg = Read from file: tgDir$
  @getTierNumber
  tier = getTierNumber.return[tier$]
  sd = 0
  
  if fileReadable(sdDir$)
    sd = Open long sound file: sdDir$
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
    comment: "Case: 'row'/'nrow'"
    comment: "Text: " + if length(text$)> 25 then left$(text$, 25) + "..." else text$ fi
    natural: "Next case",  if (row + 1) > nrow then 1 else row + 1 fi
  clicked = endPause: "Continue", "Save", "Quit", 1
  endeditor

  if clicked = 2
    selectObject: tg
    Save as text file: tgDir$
  endif
  
  removeObject: tg
  if sd
    removeObject: sd
  endif
  @config.setField: "open_file.row", string$(row)
  row = next_case

  if clicked = 3
    removeObject: index
    exitScript()
  endif
endwhile