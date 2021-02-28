procedure check_if_empty: .variable$, .field_name$
	# Warning
	# Checking
	## Check dialogue box fields
	.return= 0
	if .variable$ == ""
		@warning_dialog: "Please, complete the ['.field_name$'] field"
		.return =1
	endif
endproc

procedure check_search_table: .table_path$
	## Check if a search is done
	if !fileReadable(.table_path$)
		@quit_dialog: "Make a search first!"
	endif
endproc

procedure check_search_results: .table_path$
	## Check if the search table have recorded cases
	.objects# = selected#()
	.search = Read from file: .table_path$
	.nRows = object[.search].nrow
	removeObject: .search
	selectObject: .objects#
	if !.nRows
		@quit_dialog: "Nothing to show. Please, try a new search!"
	endif
endproc

procedure quit_dialog: .message$
	beginPause: "Warning!"
	comment: .message$
	endPause: "Ok", 1, 1
	exitScript()
endproc

procedure warning_dialog: .message$
	beginPause: "Warning!"
	comment: .message$
	endPause: "Ok", 1, 1
endproc