search_table_path$ = "../temp/search.Table"
@check_search_table: search_table_path$
@check_search_results: search_table_path$

label DEFAULTS
sound_dirname$ = "."
sound_path = 1
dst_dirname$ = ""
sound_file_extension$ = "wav"
filename_format$ = "[Filename]-[DuplicateID]"
margin = 0.1
label APPLY
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
	comment: "Filename format...                                          Hint: use these tags [ID], [DuplicateID], [Filename], [Text]"
	text: "Filename format", filename_format$
	comment: "Left and right margins (seconds)..."
	real: "Margin", margin
clicked = endPause: "Standards", "Cancel", "Apply", "Ok", 4, 2

if clicked == 2
	exitScript()
elif clicked == 1
	goto DEFAULTS
endif

# Variables
relative_dirname = if sound_path > 1 then 0 else 1 fi 

# Check
@check_if_empty: dst_dirname$, "Save in"
if check_if_empty.return
  goto APPLY
endif

@check_if_empty: filename_format$, "Filename format"
if check_if_empty.return
  goto APPLY
endif

runScript: "extract_files.praat", sound_dirname$, sound_file_extension$, relative_dirname, search_table_path$, dst_dirname$, filename_format$, margin

if clicked == 3
	goto APPLY
endif

include _warning_dialogs.praat