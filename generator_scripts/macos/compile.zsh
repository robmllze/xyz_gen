#!/usr/bin/env zsh

# Compile the scripts for macos.
for script in delete_generated_dart_files generate_all_exports generate_makeups generate_models generate_screen_access generate_screen_configurations generate_screen; do
    dart compile exe ../src/$script.dart --target-os macos -o ../macos/bin/$script
done

# Compile the scripts for windows.
# for script in delete_generated_dart_files generate_all_exports generate_makeups generate_models generate_screen_access generate_screen_configurations generate_screen; do
#     dart compile exe ../src/$script.dart --target-os windows -o ../windows/bin/$script.exe
# done
