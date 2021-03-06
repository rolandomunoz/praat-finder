# Extract files from a table (dialog)
#
# Written by Rolando Munoz A. (04 March 2021)
#
# This script is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# A copy of the GNU General Public License is available at
# <http://www.gnu.org/licenses/1>.
#

# Constants
search_table_path$ = "../temp/search.Table"
defaults = 1
standard_btn = 1
cancel_btn = 2
apply_btn = 3
ok_btn = 4

@check_search_table: search_table_path$
@check_search_results: search_table_path$

repeat
	if defaults
		sound_dirname$ = "."
		sound_path = 1
		dst_dirname$ = ""
		sound_file_extension$ = "wav"
		filename_format$ = "[Filename]-[DuplicateID]"
		margin = 0.1
		defaults = 0
	endif

	beginPause: "Extract files"
		comment: "Input:"
		comment: "Folder with sound files:"
		text: "sound_dirname", sound_dirname$
		optionMenu: "Sound path", sound_path
			option: "Relative to TextGrid paths"
			option: "Absolute path"
		word: "Sound file extension", sound_file_extension$
		comment: "Output:"
		comment: "Save in:"
		text: "dst_dirname", dst_dirname$
		comment: "Filename format...                                                (*) Use these tags: [ID] [DuplicateID] [Filename] [Text]"
		text: "Filename format", filename_format$
		comment: "Left and right margins (seconds)..."
		real: "Margin", margin
	clicked = endPause: "Standards", "Cancel", "Apply", "Ok", 4, 2

	if clicked == standard_btn
		defaults = 1
	endif

	if clicked == cancel_btn
		exitScript()
	endif
	
	if clicked == ok_btn or clicked == apply_btn
		# Variables
		relative_dirname = if sound_path > 1 then 0 else 1 fi
		# Check dialog
		check_counter = 0

		@check_if_empty: dst_dirname$, "Save in"
		check_counter = if check_if_empty.return then check_counter else check_counter+1 fi

		@check_if_empty: filename_format$, "Filename format"
		check_counter = if check_if_empty.return then check_counter else check_counter+1 fi
		
		if check_counter == 2
			runScript: "extract_files.praat", sound_dirname$, sound_file_extension$, relative_dirname, search_table_path$, dst_dirname$, filename_format$, margin
		endif
	endif
until clicked == 4

include _warning_dialogs.praat