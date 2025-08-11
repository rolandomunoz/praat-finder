form Create index
	sentence TextGrid_directory C:\Users\lab\Desktop\phonetic-collection
	word TextGrid_extension TextGrid
	boolean Recursive_search
	boolean Include_empty_intervals
	sentence Destiny_directory
endform

# Remove previous indexes if any
table_ext$ = "Table"
fnames$# = fileNames$#("'destiny_directory$'/*.'table_ext$'")
for i to size(fnames$#)
	@join_many_paths: {destiny_directory$, fnames$#[i]}
	deleteFile: join_many_paths.return$
endfor

# List all the files in the root directory
@createStringAsFileList: "fileList", textGrid_directory$ + "/*.'textGrid_extension$'", recursive_search
files = selected("Strings")
nfiles = Get number of strings
if nfiles == 0
	removeObject: files
	exitScript()
endif

max = 100
min = 1
number_of_groups = nfiles div max + if (nfiles mod max) > 0 then 1 else 0 fi
group_counter = 0
indexes# = zero#(number_of_groups)

repeat
	continue = if nfiles > max then 1 else 0 fi
	max = if nfiles > max then max else nfiles fi
	group_size = max - min + 1
	group_counter+=1
	tables# = zero#(group_size)
	index = 0
	for i from min to max
		index+=1
		tg_name$ = object$[files, i]
		@join_many_paths: {textGrid_directory$, tg_name$}
		@normpath: join_many_paths.return$
		tg_path$ = normpath.return$

	  tg = Read from file: tg_path$
		tb = Down to Table: "no", 16, "yes", include_empty_intervals
		Append column: "path"
		Formula: "path", ~ tg_path$
		tables#[index] = tb
		removeObject: tg
	endfor

	# Merge all the index tables in a single index
	selectObject: tables#
	new_table = Append
	indexes#[group_counter] = new_table
	
	removeObject: tables#

	min = max + 1
	max += group_size
until continue == 0

selectObject: indexes#
index = Append
Rename: "index"
removeObject: indexes#

# Save index.Table
selectObject: index
Append column: "notes"
@join_many_paths: {destiny_directory$, "index.Table"}
Save as text file: join_many_paths.return$

# Save tier_summary.Table
selectObject: index
tb_tiers = Collapse rows: "tier", "", "", "", "", ""
@join_many_paths: {destiny_directory$, "tier_summary.Table"}
Save as text file: join_many_paths.return$

# Save tier tables
number_of_tiers = object[tb_tiers].nrow
for i to number_of_tiers
	tier_name$= object$[tb_tiers, i, "tier"]
	selectObject: index
	tb_extracted_tier = Extract rows where column (text): "tier", "is equal to", tier_name$
	case$[i]= tier_name$
	case[i]= object[tb_extracted_tier].nrow
	@join_many_paths: {destiny_directory$, "index_'tier_name$'.Table"}
	Save as text file: join_many_paths.return$
	removeObject: tb_extracted_tier
endfor
removeObject: tb_tiers, files, index

# Print in the Info window
writeInfoLine: "Create index... Done!"
appendInfoLine: ""
appendInfoLine: "Tiers:"
for i to number_of_tiers
	appendInfoLine: "	", case$[i], " (labels = ", case[i], ")"
endfor

include ../procedures/config.proc
include ../procedures/list_recursive_path.proc
include ../procedures/paths.proc