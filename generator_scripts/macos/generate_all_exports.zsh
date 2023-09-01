#!/usr/bin/env zsh

# Include the paths file.
. ./_paths.zsh

# Generate using the default arguments.
dart ../src/generate_all_exports.dart -r $LIB_PATH:$SHARED_LIB_PATH -s configs:makeups:managers:models:routing:screens:services:themes:utils:widgets  -t $ALL_EXPORTS_TEMPLATE_PATH

# This will also generate using the default arguments.
#dart ../src/generate_all_exports.dart