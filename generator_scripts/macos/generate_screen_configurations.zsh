#!/usr/bin/env zsh

# Include the paths file.
. ./_paths.zsh

# Generate using the default arguments.
dart ../src/generate_screen_configurations.dart -r $LIB_PATH:$SHARED_LIB_PATH -s screens -o $SCREENS_PATH/screen_access_g.dart  -t $SCREEN_CONFIGURATION_TEMPLATE_PATH

# This will also generate using the default arguments.
#dart ../src/generate_screen_configurations.dart

# Apply Dart fixes to all files in the screens path.
cd $SCREENS_PATH
dart fix --apply

# Apply Dart fixes to all files in the shared screens path.
cd $SHARED_SCREENS_PATH
dart fix --apply