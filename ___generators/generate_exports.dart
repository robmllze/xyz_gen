//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:xyz_gen/generators/generate_exports/all_generate_exports.g.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

// Specify the root folder in your project to start generating from.
const APP_FOLDER = "app";

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

void main(List<String> arguments) async {
  await generateExportsApp([
    if (arguments.isNotEmpty)
      ...arguments
    else ...[
      // Template file path.
      "-t",
      "___generators/templates/generate_exports/default_exports_template.dart.md",
      // Root directories.
      "-r",
      [
        APP_FOLDER,
      ].join(":"),
      // Sub-directories.
      "-s",
      [
        "app_services",
        "app_state",
        "app",
        "brokers",
        "components",
        "configs",
        "firebase_options",
        "functions",
        "interfaces",
        "lib",
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
      ].join(":"),
    ]
  ]);
}
