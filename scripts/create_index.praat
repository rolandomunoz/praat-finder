# Index all the TextGrids in a Table object
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

@config.init: "../.preferences"

beginPause: "index"
  sentence: "Textgrid folder", config.init.return$["textgrids_dir"]
clicked = endPause: "Continue", "Quit", 1

if clicked = 2
  exitScript()
endif

@config.setField: "textgrids_dir", textgrid_folder$

# List all the files in the root directory
fileList = Create Strings as file list: "fileList", textgrid_folder$ + "/*.TextGrid"
selectObject: fileList
nFiles = Get number of strings

# If no file are listed, exit the script
if !nFiles
  pauseScript: "The source folder does not contain any TextGrid file"
  exitScript()
endif

# Split the number of files in groups of 1000. (This is so because Praat only admits 40000 files loaded at the same time in Object window)
step = 1000
residual_step = if (nFiles mod step) > 0 then 1 else 0 fi
number_of_steps = (nFiles div step) + residual_step

file_min = 1 - step
file_max = 0

# Join all the TextGrids into index tables
for i to number_of_steps
  file_min += step
  file_max += step
  file_max = if file_max > nFiles then nFiles else file_max fi
  for file_number from file_min to file_max
    filename$ = object$[fileList, file_number]
    tg_path$ = textgrid_folder$ + "/" + filename$
  
    tg = Read from file: tg_path$
    tb[file_number] = Down to Table: "no", 16, "yes", "yes"
    Append column: "filename"
    Append column: "file_path"
    Formula: "filename", """'filename$'"""
    Formula: "file_path", """'tg_path$'"""
    removeObject: tg
  endfor

  # Select all Tables
  for file_number from file_min to file_max
    if file_number = 1
      selectObject: tb[file_number]
    else
      plusObject: tb[file_number]
    endif
  endfor
  
  # Join all tables
  index[i] = Append

  # Remove Tables
  for file_number from file_min to file_max
    removeObject: tb[file_number]
  endfor
endfor
removeObject: fileList

# Select all the index tables
for i to number_of_steps
  if i = 1
    selectObject: index[i]
  else
    plusObject: index[i]
  endif
endfor

# Merge all the index tables in a single index
index = Append
Rename: "index"

# Remove all the previous index tables
for i to number_of_steps
  removeObject: index[i]
endfor

# Save the index
selectObject: index
Save as text file: preferencesDirectory$ + "/local/index.Table"
pauseScript: "Completed successfully"