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
recursive_search = number(config.init.return$["create_index.recursive_search"])

beginPause: "Extract Sound & TextGrid"
  comment: "Input:"
  comment: "The directories where your files are stored..."
  sentence: "Textgrid folder", config.init.return$["textgrids_dir"]
  sentence: "Audio folder", config.init.return$["sounds_dir"]
  comment: "Audio settings..."
  word: "Audio extension", ".wav"
  comment: "Ouput:"
  comment: "The directory where the resulting files will be stored..."
  sentence: "Save in", config.init.return$["extract_files.save_in"]
  comment: "File name..."
  optionMenu: "Basename", number(config.init.return$["extract_files.keep_original_filename"])
  option: "Filename"
  option: "Matched text"
  option: "Filename + matched text"
  option: "Matched text + filename"
  sentence: "Filename", "<basename>"
  comment: "Add a margin(in seconds) to the extracted files..."
  real: "Margin", number(config.init.return$["extract_files.margin"])
clicked = endPause: "Cancel", "Apply", "Ok", 3

if clicked = 1
  exitScript()
endif

# Save in preferences
@config.setField: "sounds_dir", audio_folder$
@config.setField: "textgrids_dir", textgrid_folder$
@config.setField: "sound_extension", audio_extension$
@config.setField: "extract_files.save_in", save_in$
@config.setField: "extract_files.file_name.margin", string$(margin)
@config.setField: "extract_files.margin", string$(margin)

# Initial variables
stdout_filename$ = filename$
searchDir$ = "../temp/search.Table"
fileCounter = 0
repetition_digits = 4
audio_folder$ = if audio_folder$ == "" then "." else audio_folder$ fi
relativePath= if startsWith(audio_folder$, ".") then 1 else 0 fi
zero$ = ""

for i to repetition_digits
  zero$ = zero$ + "0"
endfor

# Checking...
## Check dialogue box fields
if textgrid_folder$ == ""
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

for row to nRows
  # Get audio and annotation files paths
  fileBasename$ = object$[search, row, "filename"]
  tg$ = fileBasename$ + ".TextGrid"
  sd$ = fileBasename$ + audio_extension$
  tgPath$ = textgrid_folder$ + "/" + object$[search, row, "file_path"]

  sdPath$ = if relativePath then (tgPath$ - tg$) + audio_folder$ else audio_folder$ fi
  sdPath$ = sdPath$ + "/" + sd$
  
  # Get matched text information
  text$ = object$[search, row, "text"]
  tmin = object[search, row, "tmin"]
  tmax = object[search, row, "tmax"]
  tmid = (tmax - tmin)*0.5 + tmin
 
  # Open one by one all files
  if fileReadable(tgPath$) and fileReadable(sdPath$)
    tg = Read from file: tgPath$
    sd = Open long sound file: sdPath$

    if basename = 1
      stdout_basename$ = fileBasename$ + "_"
    elsif basename = 2
      stdout_basename$ = text$ + "_"
    elsif basename = 3
      stdout_basename$ = fileBasename$ + "_" + text$ + "_"
    elsif basename = 4
      stdout_basename$ = text$ + "_" + fileBasename$ + "_"
    endif
    stdout_basename$ = replace$(stdout_filename$, "<basename>", stdout_basename$, 0)

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
    
    file_id = 0
    repeat
      file_id += 1
      tmp_zero$ = left$(zero$, repetition_digits - length(string$(file_id)))
      file_id$ = tmp_zero$ +  string$(file_id)
      fileDir$ = save_in$ + "/" + stdout_basename$ + file_id$
    until !fileReadable(fileDir$ + ".TextGrid")
    
    selectObject: sd_extracted
    Save as WAV file: fileDir$ + ".wav"
    selectObject: tg_extracted
    Save as text file: fileDir$ + ".TextGrid"
    removeObject: tg, tg_extracted, sd, sd_extracted
    fileCounter+=1
  endif
endfor

removeObject: search
writeInfoLine: "Extract Sound & TextGrid"
appendInfoLine: "Number of created files: ", fileCounter * 2
appendInfoLine: "Number of TextGrid files: ", fileCounter
appendInfoLine: "Number of audio files: ", fileCounter

if clicked = 2
  runScript: "extract_files.praat"
endif