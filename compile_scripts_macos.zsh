cd scripts
dart compile exe generate_all_exports.dart -o compiled/macos/generate_all_exports
dart compile exe delete_generated_dart_files.dart -o compiled/macos/delete_generated_dart_files
dart compile exe generate_makeups.dart -o compiled/macos/generate_makeups
dart compile exe generate_models.dart -o compiled/macos/generate_models
dart compile exe generate_screen_configurations.dart -o compiled/macos/generate_screen_configurations
dart compile exe generate_screen.dart -o compiled/macos/generate_screen`