$scripts = @("delete_generated_dart_files", "generate_all_exports", "generate_makeups", "generate_models", "generate_screen_access", "generate_screen_configurations", "generate_screen")

# Compile the scripts for Windows.
foreach ($script in $scripts) {
    dart compile exe "..\src\$script.dart" --target-os windows -o "..\windows\bin\$script.exe"
}

# Compile the scripts for MacOS.
# foreach ($script in $scripts) {
#     dart compile exe "..\src\$script.dart" --target-os macos -o "..\macos\bin\$script"
# }
