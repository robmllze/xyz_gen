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
  await generateMakeupsApp([
    // Template file path.
    "--builder-template",
    "$currentScriptDir/templates/generate_makeups/default_makeup_builder_template.dart.md",
    "--class-template",
    "$currentScriptDir/templates/generate_makeups/default_makeup_class_template.dart.md",
    "--exports-template",
    "$currentScriptDir/templates/generate_makeups/default_makeup_exports_template.dart.md",
    "--theme-template",
    "$currentScriptDir/templates/generate_makeups/default_generated_theme_template.dart.md",
    "--generate-template",
    "$currentScriptDir/templates/generate_makeups/default_makeup_generate_template.dart.md",
    // Root directories.
    "-r",
    [
      "$TARGET/lib",
    ].map((e) => "$currentScriptDir/../$e").join("&"),
    // Sub-directories.
    "-s",
    [
      "widgets",
      "components",
    ].join("&"),
    // Output directory.
    "--output",
    [
      "$TARGET/lib/makeups",
    ].map((e) => "$currentScriptDir/../$e").join("&"),
  ]);
}
