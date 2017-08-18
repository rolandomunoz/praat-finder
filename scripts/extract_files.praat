# Copyright 2017 Rolando Muñoz Aramburú

include ../procedures/config.proc
include ../procedures/get_tier_number.proc

@config.init: "../.preferences"

beginPause: "Split Sound and TextGrid where..."
  comment: "Input:"
  comment: "The directory where the files are stored..."
  sentence: "Audio folder", config.init.return$["sounds_dir"]
  sentence: "Textgrid folder", config.init.return$["textgrids_dir"]
  word: "Audio extension", config.init.return$["sound_extension"]
  comment: "Output:"
  comment: "The directory where the resulting files will be stored..."
  sentence: "Save in", config.init.return$["extract_files.stdout_dir"]
  comment: "Set the filename..."
  boolean: "Keep original filename", number(config.init.return$["extract_files.keep_original_filename"])
  comment: "Add a margin..."
  real: "Margin", number(config.init.return$["extract_files.margin"])
clicked = endPause: "Continue", "Quit", 1

if clicked = 2
  exitScript()
endif

@config.setField: "sound_extension", audio_extension$
@config.setField: "textgrids_dir", textgrid_folder$
@config.setField: "sounds_dir", audio_folder$
@config.setField: "extract_files.stdout_dir", save_in$
@config.setField: "extract_files.file_name.margin", string$(margin)
@config.setField: "extract_files.file_name.keep_original_filename", string$(keep_original_filename)
@config.setField: "extract_files.margin", string$(margin)

indexDir$ = preferencesDirectory$ + "/local/index.Table"

if !fileReadable(indexDir$)
  pauseScript: "Create an index first"
endif

index = Read from file: indexDir$
nrow = Object_'index'.nrow
if !nrow
  exitScript: "No files in the index"
endif

for row to nrow
  # Get info from index
  tg_name$ = object$[index, row, "filename"]
  base_name$ = tg_name$ - ".TextGrid"
  sd_name$ = base_name$ + audio_extension$
  sd_dir$ = audio_folder$ + "/" + sd_name$
  tg_dir$ = textgrid_folder$ + "/" + tg_name$
  text$ = object$[index, row, "text"]
  tmin = object[index, row, "tmin"]
  tmax = object[index, row, "tmax"]
  tmid = (tmax - tmin)*0.5 + tmin
  
  if fileReadable(tg_dir$) and fileReadable(sd_dir$)
    tg = Read from file: tg_dir$
    sd = Open long sound file: sd_dir$
    root_name$ = if keep_original_filename then base_name$ + "_" else "" fi

    left_margin = if (tmin-margin) > 0 then margin else 0 fi
    right_margin = if (tmax + margin) < Object_'sd'.xmax then margin else 0 fi

    ## Extract TextGrid
    selectObject: tg
    tg_extracted = Extract part: tmin, tmax, "no"
    nocheck Extend time: left_margin, "Start"
    nocheck Extend time: right_margin, "End"
    Shift times to: "start time", 0

    ## Extract audio
    selectObject: sd
    sd_extracted = Extract part: tmin-left_margin, tmax+right_margin, "no"

    file_id = 0
    repeat
      file_id += 1
      file_id$ = if file_id > 9 then "R'file_id'" else "R0'file_id'" fi
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