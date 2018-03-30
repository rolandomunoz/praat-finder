# Copyright 2017 Rolando Muñoz Aramburú
if praatVersion < 6033
  appendInfoLine: "Plug-in name: Indexer"
  appendInfoLine: "Warning: This plug-in only works on Praat version above 6.0.32. Please, get a more recent version of Praat."
  appendInfoLine: "Praat website: http://www.fon.hum.uva.nl/praat/"
endif
## Static menu
Add menu command: "Objects", "Goodies", "Indexer", "", 0, ""
Add menu command: "Objects", "Goodies", "Create index...", "Indexer", 1, "scripts/create_index.praat"
Add menu command: "Objects", "Goodies", "-", "Indexer", 1, ""
#Add menu command: "Objects", "Goodies", "Query by tier number...", "Indexer", 1, "scripts/query_by_tier_number.praat"
Add menu command: "Objects", "Goodies", "Query by tier name...", "Indexer", 1, "scripts/query_by_tier_name.praat"
Add menu command: "Objects", "Goodies", "Export query...", "Import/Export", 1, "scripts/index_export.praat"
Add menu command: "Objects", "Goodies", "Import query...", "Import/Export", 1, "scripts/index_import.praat"
Add menu command: "Objects", "Goodies", "-", "Indexer", 1, ""
Add menu command: "Objects", "Goodies", "Do", "Indexer", 1, ""
Add menu command: "Objects", "Goodies", "View & Edit files...", "Do", 2, "scripts/open_files.praat"
Add menu command: "Objects", "Goodies", "Extract files...", "Do", 2, "scripts/extract_files.praat"
Add menu command: "Objects", "Goodies", "", "Do", 2, ""
Add menu command: "Objects", "Goodies", "Filter query...", "Do", 2, "scripts/filter_query.praat"

# Add menu command: "Objects", "Goodies", "Run script...", "Do", 2, "scripts/run_script.praat"

Add menu command: "Objects", "Goodies", "-", "Indexer", 1, ""
Add menu command: "Objects", "Goodies", "About", "Indexer", 1, "scripts/about.praat"

## Create a local directory
createDirectory: preferencesDirectory$ + "/local"