# Include the paths file.
. .\_paths.ps1

# Generate using the default arguments.
dart ..\src\generate_models.dart -r "$LIB_PATH:$SHARED_LIB_PATH" -s "models" -t $MODEL_TEMPLATE_PATH

# This will also generate using the default arguments.
#dart ..\src\generate_models.dart

# Apply Dart fixes to all files in the models path.
Set-Location -Path $MODELS_PATH
dart fix --apply

# Apply Dart fixes to all files in the shared models path.
Set-Location -Path $SHARED_MODELS_PATH
dart fix --apply
