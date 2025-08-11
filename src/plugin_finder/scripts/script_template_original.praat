# Script template
# This script runs on the TextGrid files that contain your search
# Insert your code in the "Paste your code" section or modify this script

# Read the Search table
table_index = Read from file: "<search_path>"
number_of_rows = Get number of rows

# Get the directory for each TextGrid
for i_row to number_of_rows
	selectObject: table_index
	
	# Get values from table
	# text$ = Get value: i_row, "text"
	# tier$ = Get value: i_row, "tier"
	# notes$ = Get value: i_row, "notes"
	# tmin = Get value: i_row, "tmin"
	# tmax = Get value: i_row, "tmax"
	textgrid_path$ = Get value: i_row, "path"
		
	##########################################################################
	###################### Paste your code here ##############################
	##########################################################################

	## Open a TextGrid file
	textgrid_id = Read from file: textgrid_path$
	
	## Do something...

	
	pauseScript()
	
	# Save your files
	# Save as text file: textgrid_path$
	removeObject: textgrid_id
endfor

removeObject: table_index
