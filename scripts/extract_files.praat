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

beginPause: "Extract Sound & TextGrid"
  comment: "Input:"
  comment: "The directories where your files are stored..."
  sentence: "Textgrid folder", config.init.return$["textgrids_dir"]
  sentence: "Audio folder", config.init.return$["sounds_dir"]
  boolean: "Relative to TextGrid paths", 1
  word: "Audio extension", ".wav"
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

@config.setField: "sounds_dir", audio_folder$
@config.setField: "textgrids_dir", textgrid_folder$
@config.setField: "sound_extension", audio_extension$
@config.setField: "extract_files.stdout_dir", save_in$
@config.setField: "extract_files.file_name.margin", string$(margin)
@config.setField: "extract_files.file_name.keep_original_filename", string$(keep_original_filename)
@config.setField: "extract_files.margin", string$(margin)

queryDir$ = preferencesDirectory$ + "/local/query.Table"

if !fileReadable(queryDir$)
  pauseScript: "Create an query first"
  exitScript()
endif

query = Read from file: queryDir$
nrow = Object_'query'.nrow
if !nrow
  exitScript: "No files in the query"
endif

repetition_digits = 4
zero$ = ""
for i to repetition_digits
  zero$ = zero$ + "0"
endfor

for row to nrow
  # Get info from query
  tg_name$ = object$[query, row, "filename"]
  tg_path$ = textgrid_folder$ + "/" + object$[query, row, "file_path"]

  if relative_to_TextGrid_paths
    filename$ = object$[query, row, "filename"]
    tg_name$ = filename$ + ".TextGrid"
    sd_path$ = (tg_path$ - tg_name$) + audio_folder$ + "/" + filename$ + audio_extension$
  else
    sd_name$ = object$[query, row, "filename"] + audio_extension$
    sd_path$ = audio_folder$ + "/" + sd_name$
  endif
  text$ = object$[query, row, "text"]
  tmin = object[query, row, "tmin"]
  tmax = object[query, row, "tmax"]
  tmid = (tmax - tmin)*0.5 + tmin
  if fileReadable(tg_path$) and fileReadable(sd_path$)
    tg = Read from file: tg_path$
    sd = Open long sound file: sd_path$
    base_name$ = selected$("LongSound")
    root_name$ = if keep_original_filename then base_name$ + "_" else "" fi

    left_margin = if (tmin-margin) > 0 then margin else tmin fi
    right_margin = if (Object_'sd'.xmax - tmax) >= margin  then margin else Object_'sd'.xmax-tmax fi
    
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

removeObject: query
writeInfoLine: "Completed succsessfully"