#!/usr/bin/env zsh

# Include the paths file.
. ./_paths.zsh

# Generate using the default arguments.
dart ../src/generate_models.dart -r $LIB_PATH:$SHARED_LIB_PATH -s models -t $MODEL_TEMPLATE_PATH

# This will also generate using the default arguments.
#dart ../src/generate_models.dart

# Apply Dart fixes to all files in the models path.
cd $MODELS_PATH
dart fix --apply

# Apply Dart fixes to all files in the shared models path.
cd $SHARED_MODELS_PATH
dart fix --apply

