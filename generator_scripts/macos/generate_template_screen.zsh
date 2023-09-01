#!/usr/bin/env zsh

# Name of the screen. Start with "Screen". Must be PascalCase.
NAME="ScreenTemplate"

# Title of the screen.
TITLE="Template"

# Whether the screen is only accessible if the user is signed in and verified.
IS_ONLY_ACCESSIBLE_IF_SIGNED_IN_AND_VERIFIED=false

# Whether the screen is only accessible if the user is signed in.
IS_ONLY_ACCESSIBLE_IF_SIGNED_IN=true

# Whether the screen is only accessible if the user is signed out.
IS_ONLY_ACCESSIBLE_IF_SIGNED_OUT=false

# Whether the screen is manually accessible using a /path in the URL, e.g. `xyz.app/path`.
IS_REDIRECTABLE=true

MAKEUP="G.theme.myScreenDefault()"

NAVIGATOR="const SizedBox()"

# Internal parameters separated by double colons. Keys and values separated by single colons.
INTERNAL_PARAMETERS="name:String::scale:double?"

# Path segments separated by colons.
PATH_SEGMENTS="uid"

# Qquery parameters separated by colons.
QUERY_PARAMETERS="blah:blahblah:blahblahblah"

# Include the paths file.
. ./_paths.zsh

# Generate the class, state, logic and configuration files for the screen.
dart ../src/generate_screen.dart \
    --name $NAME \
    --title $TITLE \
    --output $SCREENS_PATH \
    --is-only-accessible-if-signed-in-and-verified $IS_ONLY_ACCESSIBLE_IF_SIGNED_IN_AND_VERIFIED \
    --is-only-accessible-if-signed-in $IS_ONLY_ACCESSIBLE_IF_SIGNED_IN \
    --is-only-accessible-if-signed-out $IS_ONLY_ACCESSIBLE_IF_SIGNED_OUT \
    --is-redirectable $IS_REDIRECTABLE \
    --internal-parameters $INTERNAL_PARAMETERS \
    --query-parameters $QUERY_PARAMETERS \
    --path-segments $PATH_SEGMENTS \
    --makeup $MAKEUP \
    --navigator $NAVIGATOR \
    --configuration-template $SCREEN_CONFIGURATION_TEMPLATE_PATH \
    --logic-template $SCREEN_LOGIC_TEMPLATE_PATH \
    --screen-template $SCREEN_TEMPLATE_PATH \
    --state-template $SCREEN_STATE_TEMPLATE_PATH

# Regenerate 'screen_access_g.dart' to connect the newly generated screen to the router.
dart ../src/generate_screen_access.dart -r $LIB_PATH:$SHARED_LIB_PATH -s screens -o $SCREENS_PATH/screen_access_g.dart  -t $SCREEN_ACCESS_TEMPLATE_PATH

# Regenerate 'all_screens.dart' to make the newly generated screen files accessible throughout the source code.
dart ../src/generate_all_exports.dart -r $LIB_PATH -s screens -t $ALL_EXPORTS_TEMPLATE_PATH
