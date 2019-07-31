# Extract files from a table
#
# Written by Rolando Munoz A. (Aug 2017)
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

beginPause: "Extract Sound & TextGrid"
  comment: "Input:"
  comment: "The directories where your files are stored..."
  sentence: "Folder with annotation files", config.init.return$["textgrids_dir"]
  sentence: "Folder with sound files", config.init.return$["sounds_dir"]
  comment: "Sound settings..."
  word: "Sound file extension", ".wav"
  comment: "Ouput:"
  comment: "Save in..."
  text: "Save in", ""
  comment: "Name format..."
  comment: "Tag list: <basename>, <matched_text>, <repetition_id>, <number_id>"
  sentence: "Name format", "<basename>_<repetition_id>"
  comment: "Left and right margins (seconds)..."
  real: "Margin", number(config.init.return$["extract_files.margin"])
clicked = endPause: "Cancel", "Apply", "Ok", 3

if clicked = 1
  exitScript()
endif

# Save in preferences
@config.setField: "sounds_dir", folder_with_sound_files$
@config.setField: "textgrids_dir", folder_with_annotation_files$
@config.setField: "sound_extension", sound_file_extension$
@config.setField: "extract_files.file_name.margin", string$(margin)
@config.setField: "extract_files.margin", string$(margin)

# Initial variables
stdout_filename$ = name_format$
searchDir$ = "../temp/search.Table"
fileCounter = 0
repetition_digits = 4
folder_with_sound_files$ = if folder_with_sound_files$ == "" then "." else folder_with_sound_files$ fi
relativePath= if startsWith(folder_with_sound_files$, ".") then 1 else 0 fi
zero$ = ""

for i to repetition_digits
  zero$ = zero$ + "0"
endfor

# Checking...
## Check dialogue box fields
if folder_with_annotation_files$ == ""
  writeInfoLine: "Extract Sound & TextGrid"
  appendInfoLine: "Please, complete the 'Textgrid folder' field"
  runScript: "extract_files.praat"
  exitScript()
endif

if save_in$ == ""
  writeInfoLine: "Extract Sound & TextGrid"
  appendInfoLine: "Please, complete the 'Save in' field"
  runScript: "extract_files.praat"
  exitScript()
elsif startsWith(save_in$, ".")
  writeInfoLine: "Extract Sound & TextGrid"
  appendInfoLine: "We do not allow relative paths in the 'Save in' folder. Please, change the directory"
  runScript: "extract_files.praat"
  exitScript()
endif

## Check if a search is done
if !fileReadable(searchDir$)
  writeInfoLine: "Extract Sound & TextGrid"
  appendInfoLine: "Message: Make a search first"
  exitScript()
endif

## Check if the search table have recorded cases
search = Read from file: searchDir$
nRows = object[search].nrow
if !nRows
  writeInfoLine: "Extract Sound & TextGrid"
  appendInfoLine: "Message: Nothing to show. Please, make another search"
  exitScript()
endif

fileCounter= 0
for row to nRows
  # Get audio and annotation files paths
  basename$ = object$[search, row, "filename"]
  
  tg$ = basename$ + ".TextGrid"
  sd$ = basename$ + sound_file_extension$
  tgPath$ = folder_with_annotation_files$ + "/" + object$[search, row, "file_path"]

  sdPath$ = if relativePath then (tgPath$ - tg$) + folder_with_sound_files$ else folder_with_sound_files$ fi
  sdPath$ = sdPath$ + "/" + sd$
  
  # Get matched text information
  text$ = object$[search, row, "text"]
  tmin = object[search, row, "tmin"]
  tmax = object[search, row, "tmax"]
  tmid = (tmax - tmin)*0.5 + tmin
 
  # Open one by one all files
  if fileReadable(tgPath$) and fileReadable(sdPath$)
    fileCounter+=1
    tg = Read from file: tgPath$
    sd = Open long sound file: sdPath$

    leftMargin = if (tmin-margin) > 0 then margin else tmin fi
    rightMargin = if (object[sd].xmax - tmax) >= margin then margin else object[sd].xmax-tmax fi
    
    ## Extract TextGrid
    selectObject: tg
    tg_extracted = Extract part: tmin, tmax, "no"
    nocheck Extend time: leftMargin, "Start"
    nocheck Extend time: rightMargin, "End"
    Shift times to: "start time", 0

    ## Extract audio
    selectObject: sd
    sd_extracted = Extract part: tmin-leftMargin, tmax+rightMargin, "no"
    
    stdout_current_basename$ = replace$(stdout_filename$, "<basename>", basename$, 0)
    stdout_current_basename$ = replace$(stdout_current_basename$, "<matched_text>", text$, 0)
    stdout_current_basename$ = replace$(stdout_current_basename$, "<number_id>", string$(fileCounter), 0)
    if index(stdout_current_basename$, "<repetition_id>")
      file_id = 0
      repeat
        file_id += 1
        tmp_zero$ = left$(zero$, repetition_digits - length(string$(file_id)))
        repetition_id$ = tmp_zero$ +  string$(file_id)
        stdout_current_basename_test$= replace$(stdout_current_basename$, "<repetition_id>", repetition_id$, 0)
        fileFullPath$ = save_in$ + "/" + stdout_current_basename_test$
      until !fileReadable(fileFullPath$ + ".TextGrid")
    else
      fileFullPath$ = save_in$ + "/" + stdout_current_basename$
    endif
    
    selectObject: sd_extracted
    Save as WAV file: fileFullPath$ + ".wav"
    selectObject: tg_extracted
    Save as text file: fileFullPath$ + ".TextGrid"
    removeObject: tg, tg_extracted, sd, sd_extracted
  endif
endfor

removeObject: search
writeInfoLine: "Extract Sound & TextGrid"
appendInfoLine: "Number of extracted files: ", fileCounter * 2
appendInfoLine: "- Annotation files: ", fileCounter
appendInfoLine: "- Sound files: ", fileCounter

if clicked = 2
  runScript: "extract_files.praat"
endif
