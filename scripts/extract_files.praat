# Extract files from a table
#
# Written by Rolando Munoz A. (Aug 2017)
# Las modified on 27 Feb 2021
#
# This script is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# A copy of the GNU General Public License is available at
# <http://www.gnu.org/licenses/1>.
#
form Extract Sound & TextGrid
	sentence sound_dirname .
	word sound_extension wav
	boolean relative_dirname 1
	sentence search_table_path ../temp/search.Table
	sentence dst_dirname C:\Users\lab\Desktop\test\folder_01-output
	text name_format [Filename]-[DuplicateID]
	real margin 0.1
endform

# [ID], [DuplicateID], [Filename], [Text]
# main
search = Read from file: search_table_path$
nrows = object[search].nrow
leading_zeros_default = 3
leading_zeros = length(string$(nrows))
leading_zeros = if leading_zeros_default > leading_zeros then leading_zeros_default else leading_zeros fi

fileCounter= 0
for row to nrows
	# Get audio and annotation files paths
	tg_path$ = object$[search, row, "path"]
	@get_pair_path: tg_path$, sound_extension$, sound_dirname$, relative_dirname
	sd_path$ = get_pair_path.return$
	@basename_without_extension: tg_path$
	root_name$ = basename_without_extension.return$
	
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
		sound_extensionracted = Extract part: tmin-leftMargin, tmax+rightMargin, "no"

		# File names
		@zfill: string$(fileCounter), leading_zeros
		numericID$ = zfill.return$
		
		new_name$ = replace$(name_format$, "[ID]", numericID$, 0)
		new_name$ = replace$(new_name$, "[Filename]", root_name$, 0)
		new_name$ = replace$(new_name$, "[Text]", text$, 0)

		if index(new_name$, "[DuplicateID]")
			repetitionID = 0
			repeat
				repetitionID += 1
				@zfill: string$(repetitionID), leading_zeros
				repetitionID$ = zfill.return$
				new_name_test$= replace$(new_name$, "[DuplicateID]", repetitionID$, 0)
				new_tg_path$ = dst_dirname$ + "/" + new_name_test$ + ".TextGrid"
			until !fileReadable(new_tg_path$)
		else
			new_tg_path$ = dst_dirname$ + "/" + new_name$ + ".TextGrid"
		endif
		
		@dirname: new_tg_path$
		@make_dirs: dirname.return$
		
		# Save files
		selectObject: sound_extensionracted
		
		@swap_extension: new_tg_path$, "wav"
		new_sd_path$ = swap_extension.return$

		Save as WAV file: new_sd_path$
		selectObject: tg_extracted
		Save as text file: new_tg_path$
		removeObject: tg, tg_extracted, sd, sound_extensionracted
	endif
endfor

removeObject: search
writeInfoLine: "Extract Sound & TextGrid"
appendInfoLine: "Number of extracted files: ", fileCounter * 2
appendInfoLine: "- Annotation files: ", fileCounter
appendInfoLine: "- Sound files: ", fileCounter

procedure zfill: .number$, .width
	.digits = length(.number$)
	if .digits < .width
		.zeroes$ = ""
		.max = (.width - .digits)
		for .i to .max
			.zeroes$ = .zeroes$ + "0"
		endfor
		.return$ = .zeroes$ + .number$
	else
		.return$ = .number$
	endif
endproc

include ../procedures/paths.proc