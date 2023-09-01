# Include the paths file.
. .\_paths.ps1

# Generate using the default arguments.
dart ..\src\generate_screen_access.dart -r "$LIB_PATH:$SHARED_LIB_PATH" -s "screens" -o "$SCREENS_PATH\screen_access_g.dart" -t $SCREEN_ACCESS_TEMPLATE_PATH

# This will also generate using the default arguments.
#dart ..\src\generate_screen_access.dart
