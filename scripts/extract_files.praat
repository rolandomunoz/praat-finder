# Extract files from a table
#
# Written by Rolando Munoz A. (Aug 2017)
# Las modified on 02 Feb 2021
#
# This script is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# A copy of the GNU General Public License is available at
# <http://www.gnu.org/licenses/1>.
#
@config.init: "../preferences.txt"

beginPause: "Extract Sound & TextGrid"
	comment: "Input:"
	comment: "	The directories where your files are stored..."
	sentence: "Folder with annotation files:", config.init.return$["textgrids_dir"]
	sentence: "Folder with sound files", config.init.return$["sounds_dir"]
	comment: "	Sound settings..."
	word: "Sound file extension", "wav"
	comment: "Ouput:"
	sentence: "Save in", ""
	comment: "Name format..."
	comment: "	Tags: [OriginalFileName], [MatchedText], [RepetitionID], [NumericID]"
	text: "Name format", "[OriginalFileName]-[RepetitionID]"
	comment: "Left and right margins (seconds)..."
	real: "Margin", number(config.init.return$["extract_files.margin"])
clicked = endPause: "Cancel", "Apply", "Ok", 3

if clicked = 1
	exitScript()
endif

# Save in preferences
@config.setField: "sounds_dir", folder_with_sound_files$
@config.setField: "textgrids_dir", folder_with_annotation_files$
@config.setField: "sound_extension", sound_file_extension$
@config.setField: "extract_files.file_name.margin", string$(margin)
@config.setField: "extract_files.margin", string$(margin)

# Initial variables
sd_file_extension$ = sound_file_extension$

searchDir$ = "../temp/search.Table"
fileCounter = 0
folder_with_sound_files$ = if folder_with_sound_files$ == "" then "." else folder_with_sound_files$ fi
leading_zeros$ = "0000"
relativePath= if startsWith(folder_with_sound_files$, ".") then 1 else 0 fi
tg_file_extension$ = "TextGrid"

# Checking
## Check dialogue box fields
if folder_with_annotation_files$ == ""
	writeInfoLine: "Extract Sound & TextGrid"
	appendInfoLine: "Please, complete the 'Textgrid folder' field"
	runScript: "extract_files.praat"
	exitScript()
endif

if save_in$ == ""
	writeInfoLine: "Extract Sound & TextGrid"
	appendInfoLine: "Please, complete the 'Save in' field"
	runScript: "extract_files.praat"
	exitScript()
elsif startsWith(save_in$, ".")
	writeInfoLine: "Extract Sound & TextGrid"
	appendInfoLine: "We do not allow relative paths in the 'Save in' folder. Please, change the directory"
	runScript: "extract_files.praat"
	exitScript()
endif

## Check if a search is done
if !fileReadable(searchDir$)
	writeInfoLine: "Extract Sound & TextGrid"
	appendInfoLine: "Message: Make a search first"
	exitScript()
endif

## Check if the search table have recorded cases
search = Read from file: searchDir$
nRows = object[search].nrow
if !nRows
	writeInfoLine: "Extract Sound & TextGrid"
	appendInfoLine: "Message: Nothing to show. Please, make another search"
	exitScript()
endif

fileCounter= 0
for row to nRows
	# Get audio and annotation files paths
	rel_path$ = object$[search, row, "basename"]
	tg_rel_path$ = rel_path$ + "." + tg_file_extension$
	sd_rel_path$ = rel_path$ + "." + sd_file_extension$
	tg_path$ = folder_with_annotation_files$ + "/" + object$[search, row, "path"]
	
	@basename: tg_path$
	@splitext_path: basename.return$
	root_name$ = splitext_path.return$#[1]
	
	# Get audio path
	if relativePath
		# Relative to the audio path
		@dirname: tg_path$
		@basename: tg_path$
		@swap_extension: basename.return$, sound_file_extension$
		sd_basename$ = swap_extension.return$		
		tg_dirname$ = dirname.return$
		sd_rel_dirname$ = folder_with_sound_files$
		@join_many_paths: {tg_dirname$, sd_rel_dirname$, sd_basename$}
	else
		# Relative to the audio directory
		@join_many_paths: {folder_with_sound_files$, sd_rel_path$}
	endif
	sd_path$ = join_many_paths.return$

	# Get matched text information
	text$ = object$[search, row, "text"]
	tmin = object[search, row, "tmin"]
	tmax = object[search, row, "tmax"]
	tmid = (tmax - tmin)*0.5 + tmin
 
	# Open one by one all files
	if fileReadable(tg_path$) and fileReadable(sd_path$)
		fileCounter+=1
		
		tg = Read from file: tg_path$
		sd = Open long sound file: sd_path$

		leftMargin = if (tmin-margin) > 0 then margin else tmin fi
		rightMargin = if (object[sd].xmax - tmax) >= margin then margin else object[sd].xmax-tmax fi
		
		## Extract TextGrid
		selectObject: tg
		tg_extracted = Extract part: tmin, tmax, "no"
		nocheck Extend time: leftMargin, "Start"
		nocheck Extend time: rightMargin, "End"
		Shift times to: "start time", 0

		## Extract audio
		selectObject: sd
		sd_extracted = Extract part: tmin-leftMargin, tmax+rightMargin, "no"

		# File names
		@leading_zeros: fileCounter, leading_zeros$
		numericID$ = leading_zeros.return$
		
		new_name$ = replace$(name_format$, "[NumericID]", numericID$, 0)
		new_name$ = replace$(new_name$, "[OriginalFileName]", root_name$, 0)
		new_name$ = replace$(new_name$, "[MatchedText]", text$, 0)

		if index(new_name$, "[RepetitionID]")
			repetitionID = 0
			repeat
				repetitionID += 1
				@leading_zeros: repetitionID, leading_zeros$
				repetitionID$ = leading_zeros.return$
				new_name_test$= replace$(new_name$, "[RepetitionID]", repetitionID$, 0)
				new_tg_path$ = save_in$ + "/" + new_name_test$ + ".TextGrid"
			until !fileReadable(new_tg_path$)
		else
			new_tg_path$ = save_in$ + "/" + new_name$ + ".TextGrid"
		endif
		
		# Save files
		selectObject: sd_extracted
		
		@swap_extension: new_tg_path$, "wav"
		new_sd_path$ = swap_extension.return$

		Save as WAV file: new_sd_path$
		selectObject: tg_extracted
		Save as text file: new_tg_path$
		removeObject: tg, tg_extracted, sd, sd_extracted
	endif
endfor

removeObject: search
writeInfoLine: "Extract Sound & TextGrid"
appendInfoLine: "Number of extracted files: ", fileCounter * 2
appendInfoLine: "- Annotation files: ", fileCounter
appendInfoLine: "- Sound files: ", fileCounter

if clicked = 2
	runScript: "extract_files.praat"
endif

procedure leading_zeros: .number, .leadingZeros$
	.number$ = string$(.number)
	.numberOfDigits = length(.number$)
	.numberOfLeadingZeros = length(.leadingZeros$)
	.zeroLength = .numberOfLeadingZeros - .numberOfDigits
	.tmp_zero$ = left$(.leadingZeros$, .zeroLength)
	.return$ = .tmp_zero$ + .number$
endproc

include ../procedures/config.proc
include ../procedures/get_tier_number.proc
include ../procedures/paths.proc