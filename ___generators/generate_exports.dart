//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:xyz_gen/xyz_gen.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

// To-Do: Specify your apps/root folders to generate for.
const targetApps = <String>[
  "",
];

// To-Do: Specify the directories in your apps/root folders to generate for.
const subDirectories = <String>[
  "",
  "src/generators/generate_exports",
  "src/generators/generate_for_annotation_TEST",
  "src/generators/generate_for_annotation_TEST",
  "src/generators/generate_for_files_TEST",
  "src/generators/generate_license_headers",
  "src/generators/generate_makeups",
  "src/generators/generate_models",
  "src/generators/generate_preps",
  "src/generators/generate_screen_access",
  "src/generators/generate_screen_configurations",
  "src/generators/generate_screen",
  "src/generators/generate_widgets",
  "generators",
  "accessibility",
  "app_services",
  "app_state",
  "app",
  "brokers",
  "components",
  "configs",
  "firebase_options",
  "functions",
  "interfaces",
  "makeups",
  "managers",
  "model_filters",
  "models",
  "routing",
  "screens",
  "service_brokers",
  "services",
  "src",
  "theme",
  "types",
  "utils",
  "widgets",
];

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
//
// DO NOT MODIFY BELOW
//
// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

void main() async {
  await generateExportsApp([
    "-t",
    "$currentScriptDir/templates/generate_exports/default_exports_template.dart.md",
    "-r",
    targetApps.map((e) => "$currentScriptDir/../${e.isNotEmpty ? "$e/" : ""}lib").join("&"),
    "-s",
    subDirectories.join("&"),
  ]);
}

/*
/Users/robmllze/Desktop/XYZ/xyz_gen/lib/src/generators/generate_exports
/Users/robmllze/Desktop/XYZ/xyz_gen/lib/src/generators/generate_exports/src
/Users/robmllze/Desktop/XYZ/xyz_gen/lib/src/generators/generate_exports/templates
/Users/robmllze/Desktop/XYZ/xyz_gen/lib/src/generators/generate_for_annotation_TEST
/Users/robmllze/Desktop/XYZ/xyz_gen/lib/src/generators/generate_for_annotation_TEST/src
/Users/robmllze/Desktop/XYZ/xyz_gen/lib/src/generators/generate_for_files_TEST
/Users/robmllze/Desktop/XYZ/xyz_gen/lib/src/generators/generate_for_files_TEST/src
/Users/robmllze/Desktop/XYZ/xyz_gen/lib/src/generators/generate_license_headers
/Users/robmllze/Desktop/XYZ/xyz_gen/lib/src/generators/generate_license_headers/src
/Users/robmllze/Desktop/XYZ/xyz_gen/lib/src/generators/generate_license_headers/templates
/Users/robmllze/Desktop/XYZ/xyz_gen/lib/src/generators/generate_makeups
/Users/robmllze/Desktop/XYZ/xyz_gen/lib/src/generators/generate_makeups/src
/Users/robmllze/Desktop/XYZ/xyz_gen/lib/src/generators/generate_makeups/templates
/Users/robmllze/Desktop/XYZ/xyz_gen/lib/src/generators/generate_models
/Users/robmllze/Desktop/XYZ/xyz_gen/lib/src/generators/generate_models/src
/Users/robmllze/Desktop/XYZ/xyz_gen/lib/src/generators/generate_models/src/generate_parts
/Users/robmllze/Desktop/XYZ/xyz_gen/lib/src/generators/generate_models/templates
/Users/robmllze/Desktop/XYZ/xyz_gen/lib/src/generators/generate_preps
/Users/robmllze/Desktop/XYZ/xyz_gen/lib/src/generators/generate_preps/src
/Users/robmllze/Desktop/XYZ/xyz_gen/lib/src/generators/generate_screen
/Users/robmllze/Desktop/XYZ/xyz_gen/lib/src/generators/generate_screen/src
/Users/robmllze/Desktop/XYZ/xyz_gen/lib/src/generators/generate_screen/templates
/Users/robmllze/Desktop/XYZ/xyz_gen/lib/src/generators/generate_screen_access
/Users/robmllze/Desktop/XYZ/xyz_gen/lib/src/generators/generate_screen_access/src
/Users/robmllze/Desktop/XYZ/xyz_gen/lib/src/generators/generate_screen_access/templates
/Users/robmllze/Desktop/XYZ/xyz_gen/lib/src/generators/generate_screen_configurations
/Users/robmllze/Desktop/XYZ/xyz_gen/lib/src/generators/generate_screen_configurations/src
/Users/robmllze/Desktop/XYZ/xyz_gen/lib/src/generators/generate_screen_configurations/src/generate_parts
/Users/robmllze/Desktop/XYZ/xyz_gen/lib/src/generators/generate_screen_configurations/templates
*/
