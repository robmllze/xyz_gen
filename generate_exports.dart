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
const APP_FOLDER = "lib";

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
      ].join("&"),
      // Sub-directories.
      "-s",
      [
        "generators/generate_exports",
        "generators/generate_for_annotation_TEST",
        "generators/generate_for_files_TEST",
        "generators/generate_license_headers",
        "generators/generate_makeups",
        "generators/generate_models",
        "generators/generate_preps",
        "generators/generate_screen_access",
        "generators/generate_screen_configurations",
        "generators/generate_screens",
        "xyz_utils",
        "xyz_utils/xyz_utils_non_web",
        "xyz_utils/xyz_utils_web_friendly",
      ].join("&"),
    ],
  ]);
}
