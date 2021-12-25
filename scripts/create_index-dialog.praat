# Index all the TextGrids in a Table object
#
# Written by Rolando Munoz A. (08 Sep 2017)
# Las modified on 12 December 2021
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
config_path$ = "../preferences.txt"
temp_directory$ = "../temp"
index_path$ = "'temp_directory$'/index.Table"
cancel_btn = 1
apply_btn = 2
ok_btn = 3

repeat
	@config.init: config_path$
	beginPause: "Create index"
		text: "Folder with annotation files", config.init.return$["textgrids_dir"]
		word: "Annotation file extension:", "TextGrid"
		boolean: "Process subfolders as well", number(config.init.return$["create_index.process_subfolders_as_well"])
		boolean: "Include empty intervals", number(config.init.return$["create_index.include_empty_intervals"])
		comment: "Next step..."
		optionMenu: "Do", number(config.init.return$["create_index.do"])
			option: ""
			option: "Search..."
	clicked = endPause: "Cancel","Apply", "Ok", 3, 1

	# Stop
	if clicked == cancel_btn
		exitScript()
	endif
	
	textGrid_directory$ = folder_with_annotation_files$
	# Set values
	@config.set_value: "textgrids_dir", textGrid_directory$
	@config.set_value: "create_index.do", string$(do)
	@config.set_value: "create_index.process_subfolders_as_well", string$(process_subfolders_as_well)
	@config.set_value: "create_index.include_empty_intervals", string$(include_empty_intervals)
	@config.set_value: "search.tier_name_option", "1"
	@config.set_value: "search.search_for", ""
	@config.set_value: "search.mode", "1"
	@config.set_value: "search.do", "1"
	@config.set_value: "filter_search.tier_name_option", "1"
	@config.set_value: "filter_search.search_for", ""
	@config.set_value: "filter_search.do", "1"
	@config.set_value: "open_file.row", "1"
	@config.set_value: "sounds_dir", "."
	@config.set_value: "extract_files.save_in", ""
	@config.write

	runScript: "create_index.praat", textGrid_directory$, annotation_file_extension$, process_subfolders_as_well, include_empty_intervals, temp_directory$
	if not fileReadable(index_path$)
		@warning_dialog: "No TextGrid files found"
	else
		if do == 2
			runScript: "search.praat"
		endif		
	endif

until clicked == ok_btn

include ../procedures/config.proc
include ../procedures/list_recursive_path.proc
include ../procedures/paths.proc
include _warning_dialogs.praat