# Extract files from a table
#
# Written by Rolando Muñoz A. (Aug 2017)
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

@config.init: "../.preferences.txt"
recursive_search = number(config.init.return$["create_index.recursive_search"])

beginPause: "Split Sound and TextGrid where..."
  comment: "Input:"
  if recursive_search
    textgrid_folder$ = ""
    audio_folder$ = ""
  else
    comment: "The directories where your files are stored..."
    sentence: "Audio folder", config.init.return$["sounds_dir"]
    sentence: "Textgrid folder", config.init.return$["textgrids_dir"]  
  endif
  word: "Audio extension", config.init.return$["sound_extension"]
  comment: "Output:"
  comment: "The directory where the resulting files will be stored..."
  sentence: "Save in", config.init.return$["extract_files.stdout_dir"]
  comment: "Set the filename..."
  boolean: "Keep original filename", number(config.init.return$["extract_files.keep_original_filename"])
  comment: "Add a margin..."
  real: "Margin", number(config.init.return$["extract_files.margin"])
  boolean: "Remove empty tiers", 0
clicked = endPause: "Continue", "Quit", 1

if clicked = 2
  exitScript()
endif

if !recursive_search
  @config.setField: "sounds_dir", audio_folder$
  @config.setField: "textgrids_dir", textgrid_folder$
endif
@config.setField: "sound_extension", audio_extension$
@config.setField: "extract_files.stdout_dir", save_in$
@config.setField: "extract_files.file_name.margin", string$(margin)
@config.setField: "extract_files.file_name.keep_original_filename", string$(keep_original_filename)
@config.setField: "extract_files.margin", string$(margin)

indexDir$ = preferencesDirectory$ + "/local/query.Table"

if !fileReadable(indexDir$)
  pauseScript: "Create an index first"
endif

index = Read from file: indexDir$
nrow = Object_'index'.nrow
if !nrow
  exitScript: "No files in the index"
endif

repetition_digits = 4
zero$ = ""
for i to repetition_digits
  zero$ = zero$ + "0"
endfor

for row to nrow
  # Get info from index
  tg_name$ = object$[index, row, "filename"]
  if recursive_search
    tg_dir$ = tg_name$
    sd_dir$ = (tg_name$ - ".TextGrid") + audio_extension$
  else
    base_name$ = tg_name$ - ".TextGrid"
    sd_name$ = base_name$ + audio_extension$
    sd_dir$ = audio_folder$ + "/" + sd_name$
    tg_dir$ = textgrid_folder$ + "/" + tg_name$
  endif
  text$ = object$[index, row, "text"]
  tmin = object[index, row, "tmin"]
  tmax = object[index, row, "tmax"]
  tmid = (tmax - tmin)*0.5 + tmin
  if fileReadable(tg_dir$) and fileReadable(sd_dir$)
    tg = Read from file: tg_dir$
    sd = Open long sound file: sd_dir$
    base_name$ = selected$("LongSound")
    root_name$ = if keep_original_filename then base_name$ + "_" else "" fi

    left_margin = if (tmin-margin) > 0 then margin else 0 fi
    right_margin = if (tmax + margin) < Object_'sd'.xmax then margin else 0 fi

    ## Extract TextGrid
    selectObject: tg
    tg_extracted = Extract part: tmin, tmax, "no"
    nocheck Extend time: left_margin, "Start"
    nocheck Extend time: right_margin, "End"
    Shift times to: "start time", 0

    if remove_empty_tiers
      runScript: "remove_empty_tiers.praat", tg_extracted
    endif

    ## Extract audio
    selectObject: sd
    sd_extracted = Extract part: tmin-left_margin, tmax+right_margin, "no"

    file_id = 0
    repeat
      file_id += 1
      tmp_zero$ = left$(zero$, repetition_digits - length(string$(file_id)))
      file_id$ = "R" + tmp_zero$ +  string$(file_id)
      file_dir$ = save_in$ + "/" + root_name$ + text$ + "_" + file_id$
    until !fileReadable(file_dir$ + ".TextGrid")
    
    selectObject: sd_extracted
    Save as WAV file: file_dir$ + ".wav"
    selectObject: tg_extracted
    Save as text file: file_dir$ + ".TextGrid"
      
    removeObject: tg, tg_extracted, sd, sd_extracted
  endif
endfor

removeObject: index
pauseScript: "Completed succsessfully"