#!/usr/bin/env zsh

# Include the paths file.
. ./_paths.zsh

# Generate using the default arguments.
dart ../src/generate_makeups.dart -r $LIB_PATH:$SHARED_LIB_PATH -s widgets  -o $LIB_PATH/makeups -t $EXPORTS_TEMPLATE_PATH -b $MAKEUP_BUILDER_TEMPLATE_PATH  -c $MAKEUP_CLASS_TEMPLATE_PATH -e $MAKEUP_EXPORTS_TEMPLATE_PATH

# This will also generate using the default arguments.
#dart ../src/generate_makeups.dart