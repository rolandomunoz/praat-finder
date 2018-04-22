# Script template
# This script runs on the TextGrid files that contain your search
# Insert your code in the "Paste your code" section or modify this script

form Run script
  sentence TextGrid_folder <TextGrid_folder>
endform

# Read Query table
table_index = Read from file: "<query_path>"
number_of_rows = Get number of rows

# Get the directory for each TextGrid
for i_row to number_of_rows
  selectObject: table_index
  
  # Get values from table
  textgrid_name$ = Get value: i_row, "file_path"
  # text$ = Get value: i_row, "text"
  # tier$ = Get value: i_row, "tier"
  # notes$ = Get value: i_row, "notes"
  # tmin = Get value: i_row, "tmin"
  # tmax = Get value: i_row, "tmax"

  textgrid_name$ = Get value: i_row, "file_path"
  textgrid_path$ = textGrid_folder$ + "/"+ textgrid_name$
    
  ##########################################################################
  ###################### Paste your code here ##############################
  ##########################################################################

  ## Open a TextGrid file
  textgrid_id = Read from file: textgrid_path$
  
  ## Do something...

  
  
  
  # Save your files
  # Save as text file: textgrid_path$
  removeObject: textgrid_id
endfor

removeObject: table_index