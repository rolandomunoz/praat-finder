# Open a TextGrid and optionally a Sound in the TextGridEditor
#
# Written by Rolando Munoz A. (08 Sep 2017)
# Las modified on 24 Feb 2021
#
# This script is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# A copy of the GNU General Public License is available at
# <http://www.gnu.org/licenses/>.
#
@config.init: "../preferences.txt"
message$= ". (=same as each indexed TextGrid dirname)"

beginPause: "View & Edit files"
	comment: "Folder with sound files:"
	text: "sd_dirname", message$
	word: "Sound file extension", "wav"
	boolean: "Folder path relative to indexed TextGrids", 1
	comment: "Display settings..."
	real: "Margin", number(config.init.return$["open_file.margin"])
	boolean: "Add notes", 0
	boolean: "Adjust sound level", number(config.init.return$["open_file.adjust_sound_level"])
clicked = endPause: "Cancel", "Apply", "Ok", 3

if clicked = 1
	exitScript()
endif

# Save in preferences
@config.setField: "sounds_dir", sd_dirname$
@config.setField: "open_file.margin", string$(margin)
@config.setField: "open_file.adjust_sound_level", string$(adjust_sound_level)

# Initial variables
sd_dirname$ = if sd_dirname$ == message$ then "." else sd_dirname$ fi
sd_ext$ = sound_file_extension$
relative_mode= folder_path_relative_to_indexed_TextGrids
row = number(config.init.return$["open_file.row"])
pause = 1
table_dir$ = "../temp/search.Table"
volume = 0.99

# Checking...

## Check if a search is done
if not fileReadable(table_dir$)
	writeInfoLine: "View & Edit files"
	appendInfoLine: "Message: Make a search first"
	exitScript()
endif

## Check if the search table have recorded cases
search = Read from file: table_dir$
if not object[search].nrow
	writeInfoLine: "View & Edit files"
	appendInfoLine: "Message: Nothing to show. Please, make another search."
	exitScript()
endif

# Start pause window
n_rows = object[search].nrow
while pause
	row = if row > n_rows then 1 else row fi
	#Get info from the search table
	text$ = object$[search, row, "text"]
	tg_path$ = object$[search, row, "path"]
	@basename: tg_path$
	tg_basename$ = basename.return$
	@swap_extension: tg_basename$, sd_ext$
	sd_basename$ = swap_extension.return$
	
	if relative_mode
		sd_rel_dirname$ = sd_dirname$
		@dirname: tg_path$
		@join_many_paths: {dirname.return$, sd_rel_dirname$, sd_basename$}
		sd_path$ =join_many_paths.return$
	else
		@join_many_paths: {sd_dirname$, sd_basename$}
		sd_path$ = join_many_paths.return$
	endif
	tmin = object[search, row, "tmin"]
	tmax = object[search, row, "tmax"]
	tmid = (tmax - tmin)*0.5 + tmin
	tier$ = object$[search, row, "tier"]

	#Display
	tg = Read from file: tg_path$
	@getTierNumber
	tier = getTierNumber.return[tier$]
	sd = 0
	
	if fileReadable(sd_path$)
		if adjust_sound_level
			sd = Read from file: sd_path$
			Scale peak: volume
		else
			sd = Open long sound file: sd_path$
		endif
		plusObject: tg
		show_volumne_widget = 1
	else
		show_volumne_widget = 0
	endif

	nowarn View & Edit
	editor: tg
	for i to tier - 1
		Select next tier
	endfor
	
	Select: tmin - margin, tmax + margin
	Zoom to selection
	Move cursor to: tmid

	beginPause: "View & Edit files"
		if add_notes
			sentence: "Notes", object$[search, row, "notes"]
		endif
		comment: "Case: 'row'/'n_rows'"
		comment: "Text: " + if length(text$)> 25 then left$(text$, 25) + "..." else text$ fi
		comment: "File name: " + tg_basename$
		natural: "Next case",	if (row + 1) > n_rows then 1 else row + 1 fi
		if show_volumne_widget
			real: "Volume", volume
		endif
	clicked_finder = endPause: "Continue", "Save", "Quit", 1
	endeditor

	if add_notes
		selectObject: search
		Set string value: row, "notes", notes$
		Save as text file: table_dir$
	endif

	if clicked_finder = 2
		selectObject: tg
		Save as text file: tg_path$
	endif
	
	removeObject: tg
	if sd
		removeObject: sd
	endif
	@config.setField: "open_file.row", string$(row)
	row = next_case

	if clicked_finder = 3
		removeObject: search
		pause = 0
	endif
endwhile

if clicked = 2
	runScript: "open_files.praat"
endif

include ../procedures/config.proc
include ../procedures/get_tier_number.proc
include ../procedures/paths.proc