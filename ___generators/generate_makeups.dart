//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:xyz_gen/generators/generate_makeups/all_generate_makeups.g.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

// Specify the root folder in your project to start generating from.
const APP_FOLDER = "app";

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

void main() async {
  await generateMakeupsApp([
    // Template file path.
    "--builder-template",
    "___generators/templates/generate_makeups/default_makeup_builder_template.dart.md",
    "--class-template",
    "___generators/templates/generate_makeups/default_makeup_class_template.dart.md",
    "--exports-template",
    "___generators/templates/generate_makeups/default_makeup_exports_template.dart.md",
    "--theme-template",
    "___generators/templates/generate_makeups/default_generated_theme_template.dart.md",
    "--generate-template",
    "___generators/templates/generate_makeups/default_makeup_generate_template.dart.md",
    // Root directories.
    "-r",
    [
      "$APP_FOLDER/lib",
    ].join(":"),
    // Sub-directories.
    "-s",
    [
      "widgets",
      "components",
    ].join(":"),
    // Output directory.
    "--output",
    "$APP_FOLDER/lib/makeups",
  ]);
}
