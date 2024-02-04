//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:xyz_gen/generators/generate_exports/all_generate_exports.g.dart';
import 'package:xyz_gen/generators/generate_models/all_generate_models.g.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

// Specify the root folder in your project to start generating from.
const APP_FOLDER = "test";

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

void main() async {
  // STEP 1 - GENERATE THE MODELS
  await generateModelsApp([
    // Template file path.
    "-t",
    "___generators/templates/generate_models/default_model_template.dart.md",
    // Root directories.
    "-r",
    [
      "$APP_FOLDER/lib",
    ].join("&"),
    // Sub-directories.
    "-s",
    [
      "models",
    ].join("&"),
  ]);
  // STEP 2 - INCLUDE MODEL FILES TO DART EXPORTS
  generateExportsApp([
    "-t",
    "___generators/templates/generate_exports/default_exports_template.dart.md",
    "-r",
    [
      "$APP_FOLDER/lib",
    ].join("&"),
    "-s",
    [
      "models",
    ].join("&"),
  ]);
}
