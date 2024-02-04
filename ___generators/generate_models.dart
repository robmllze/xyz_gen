//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:xyz_gen/xyz_gen.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

const TARGET = "test_app";

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

void main([List<String> arguments = const []]) async {
  // STEP 1 - GENERATE THE MODELS
  await generateModelsApp([
    // Template file path.
    "-t",
    "$currentScriptDir/templates/generate_models/default_model_template.dart.md",
    // Root directories.
    "-r",
    [
      "$TARGET/lib",
    ].map((e) => "$currentScriptDir/../$e").join("&"),
    // Sub-directories.
    "-s",
    [
      "models",
    ].join("&"),
  ]);
  // STEP 2 - INCLUDE MODEL FILES TO DART EXPORTS
  await generateExportsApp([
    "-t",
    "$currentScriptDir/templates/generate_exports/default_exports_template.dart.md",
    "-r",
    [
      "$TARGET/lib",
    ].map((e) => "$currentScriptDir/../$e").join("&"),
    "-s",
    [
      "models",
    ].join("&"),
  ]);
}
