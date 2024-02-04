//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:xyz_gen/xyz_gen.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

// To-Do: Specify your apps/root folders to generate exports for.
const targetApps = <String>[
  "test_app",
];

// To-Do: Specify the directories in your apps/root folders to generate exports for.
const subDirectories = <String>[
  "",
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

void main([List<String> arguments = const []]) async {
  await generateExportsApp([
    if (arguments.isNotEmpty)
      ...arguments
    else ...[
      // Template file.
      "-t",
      "$currentScriptDir/templates/generate_exports/default_license_header_template.dart.md",
      // Root directories.
      "-r",
      targetApps.map((e) => "$currentScriptDir/../${e.isNotEmpty ? "$e/" : ""}lib").join("&"),
      // Sub-directories.
      "-s",
      subDirectories.join("&"),
    ],
  ]);
}
