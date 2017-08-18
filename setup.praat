# Copyright 2017 Rolando Muñoz Aramburú

## Static menu
Add menu command: "Objects", "Goodies", "Indexer", "", 0, ""
Add menu command: "Objects", "Goodies", "Index by tier number...", "Indexer", 1, "scripts/index_by_tier_number.praat"
Add menu command: "Objects", "Goodies", "Index by tier name...", "Indexer", 1, "scripts/index_by_tier_name.praat"
Add menu command: "Objects", "Goodies", "-", "Indexer", 1, ""
Add menu command: "Objects", "Goodies", "About", "Indexer", 1, "scripts/about.praat"

## Create a local directory
createDirectory: preferencesDirectory$ + "/local"