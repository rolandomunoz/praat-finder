# Search for folders in a directory hierarchy. It uses the Depth-first Search algorithm
#
# Written by Rolando Munoz A. (13 Sep 2017)
# Modify by Rolando Munoz A. on (28 Jun 2018)
# Modify by Rolando Munoz A. on (30 Jul 2019)
# This script is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# A copy of the GNU General Public License is available at
# <http://www.gnu.org/licenses/>.
#

#! ~~~params
#! selection:
#!   in:
#!     - objectName$: name of resulting Strings object
#!     - filePath$: directory path where files are stored. It admits wildcard * at the end.
#!     - recursive_search: 1 for searching in all subdirectories of the filePath; 0 for searching at the path level.
#!   out:
#!     - strings: 1
#! ~~~
#! Emulate Create Strings as file list command with recursive search option
#!
procedure createStringAsFileList: .objectName$, .filePath$, .recursive_search
  # Normalize filePath
  ## Possible entries:
  ## /home/rolando/Desktop/A/*.txt
  ## /home/rolando/Desktop/A/*
  ## /home/rolando/Desktop/A/
  ## /home/rolando/Desktop/A
  ## C:\users\rolando\casa

  if .recursive_search
    # Normalize file path
    .filePath$= replace$(.filePath$, "\", "/", 0)
    if not index(.filePath$, "*")
      .sep$= if endsWith(.filePath$, "/") then "" else "/" fi
      .filePath$= .filePath$ + .sep$ + "*"
    endif
    
    # Get path and file name
    .filePattern$ = replace_regex$(.filePath$, "(.*/)(.*)", "\2", 1)
    .directoryPath$ = replace_regex$(.filePath$, "(.*/)(.*)", "\1", 1)

    @_findFiles: .directoryPath$, .filePattern$, .recursive_search
    .tb_fileList= selected("Table")
    Formula: "path", ~replace$(self$["path"], .directoryPath$ + "/","",1)
    if windows
      Formula: "path", ~replace$(self$["path"], "\","\",0)
    endif
    @_tb2Strings: "path"
    Rename: .objectName$
    removeObject: .tb_fileList
  else
    .return = Create Strings as file list: .objectName$, .filePath$
  endif
endproc

#! ~~~params
#! selection:
#!   in:
#!     - objectName$: The name of the returning Strings object
#!     - path$: root path directory$
#!     - recursive_search: 1 if recursive search, else 0
#!   out:
#!     - strings: 1
#! ~~~
#! Emulate Create Strings as directory list command with recursive search option
#!
procedure createStringsAsDirectoryList: .objectName$, .path$, .recursive_search
  if .recursive_search
    @_findDirectories: .path$
    .tb= selected("Table")
    Formula: "path", ~replace$(self$["path"], .path$ + "/","",1)
    if windows
      Formula: "path", ~replace$(self$["path"], "\","\",0)
    endif
    Remove row: 1; the first element does not count beacause it is the root path
    @_tb2Strings: "path"
    Rename: .objectName$
    removeObject: .tb
  else
    Create Strings as directory list: .objectName$, .path$
  endif
endproc

#! ~~~params
#! selection:
#!   in:
#!     - rootDirectory$: the root directory
#!   out:
#!     - table: 1
#! ~~~
#! Search for folders in a directory hierarchy. It uses the Depth-first Search algorithm
#!
procedure _findDirectories: .rootDirectory$
  # Create a table
  .return = Create Table with column names: "directoryList", 0, "id parent_id i_dir n_dir path"
  @_findDirectoriesCall: .return, 0, .rootDirectory$
  selectObject: .return
endproc

#! ~~~params
#! selection:
#!   in:
#!     - tb_directoryList: a Table object where directories are stored
#!     - parentId: a Strings object which contains a directory List
#!     - directory$: a directory path
#! ~~~
#! Internal procedure. This procedure complete the Table tb_directoryList 
#! with all directory paths below a root. It is based on Post Order Traversal algorithm.
#!
procedure _findDirectoriesCall: .tb_directoryList, .parentId, .directory$
   .str_directoryList = Create Strings as directory list: "directoryList", .directory$
  .nDirectories = Get number of strings

  selectObject: .tb_directoryList
  Append row
  Set numeric value: object[.tb_directoryList].nrow, "id", .str_directoryList
  Set numeric value: object[.tb_directoryList].nrow, "parent_id", .parentId
  Set numeric value: object[.tb_directoryList].nrow, "i_dir", 1
  Set numeric value: object[.tb_directoryList].nrow, "n_dir", .nDirectories
  Set string value: object[.tb_directoryList].nrow, "path", .directory$

  selectObject: .str_directoryList
  for .i to .nDirectories
    .folderName$= object$[.str_directoryList, .i]
    @_findDirectoriesCall: .tb_directoryList, .str_directoryList, .directory$ + "/" + .folderName$
  endfor
  removeObject: .str_directoryList

  # Parent id
  ## Get parent id
  selectObject: .tb_directoryList
  .tb_row = Search column: "id", string$(.str_directoryList)
  .str_directoryList = object[.tb_directoryList, .tb_row, "parent_id"]

  if .str_directoryList
  ## Increase counter 'i' of the parent id
    .tb_row = Search column: "id", string$(.str_directoryList)
    .i = object[.tb_directoryList, .tb_row, "i_dir"]
    Set numeric value: .tb_row, "i_dir", .i+1
    .nDirectories = object[.tb_directoryList, .tb_row, "n_dir"]
    .directory$ = object$[.tb_directoryList, .tb_row, "path"]
  endif
endproc

#! ~~~params
#! selection:
#!   in:
#!     - path$: the root file
#!     - filePattern$: the name pattern of the files
#!   out:
#!     - strings: 1
#! ~~~
#! Search for files in a directory hierarchy. It uses the Depth-first Search algorithm
#!
procedure _findFiles: .path$, .filePattern$
  .tb_return= Create Table with column names: "fileList", 0, "path"
  @_findDirectories: .path$
  .tb_directoryList= selected("Table")
  for .i to object[.tb_directoryList].nrow
    .filePath$= object$[.tb_directoryList, .i, "path"]
    .str_fileList= Create Strings as file list: "fileList", .filePath$ + "/" + .filePattern$
    .nFiles= Get number of strings
    for .j to .nFiles
      .filename$= object$[.str_fileList, .j]
      .fileFullPath$= .filePath$ + "/" + .filename$
      selectObject: .tb_return
      Append row
      Set string value: object[.tb_return].nrow, "path", .fileFullPath$
    endfor
    removeObject: .str_fileList
  endfor
  removeObject: .tb_directoryList
  selectObject: .tb_return
endproc

#! ~~~params
#! selection:
#! - Table
#!   in:
#!     - columnName$: name of the column table
#! ~~~
#! Convert one table column to a Strings object
#!
procedure _tb2Strings: .columnName$
  .tb= selected("Table")
  .str_return = Create Strings as tokens: "", " ,"
  for .i to object[.tb].nrow
    path$= object$[.tb, .i, .columnName$]
    Insert string: 0, path$
  endfor
endproc
