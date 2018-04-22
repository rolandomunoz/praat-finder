# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).


## [Unrealised]

## [1.1.0] 30-04-2018

### Added
  - New command 'Open script template'
  - New command in the Object window when selecting a Table, 'Import query'
  - Query by tier name: update search mode
  - Query by tier name: select between a list of commands what comes next after doing a query

### Changed
  - Commands use the Info window to show messages
  - More detailed messages for all commands
  - New buttons in the dialogue boxes: Cancel, Apply and 'Ok'
  - A better interface for the command 'Filter query...'
  - Support relative paths: audio file paths can be defined in relation to the location of their TextGrid files. 
  - 'Import query' check the column names
  
### Fixed
  - A bug in 'Extract files...'. Intervals are extracted with the correct margin.

## [1.0.0] 2018-03-13

### Added
  - Added commands
    - `Create index`
    - `Query by tier name...`
    - `Export query...`
    - `Import query...`
    - `View & Edit files...`
    - `Extract files...`
    - `Filter query...`
    - `About`
