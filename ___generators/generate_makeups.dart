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
  "example_app",
];

// To-Do: Specify the directories in your apps/root folders to generate for.
const subDirectories = <String>[
  "widgets",
  "components",
];

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
//
// DO NOT MODIFY BELOW
//
// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

void main() async {
  for (final targetApp in targetApps) {
    await generateMakeupsApp([
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
      "-r",
      "$currentScriptDir/../${targetApp.isNotEmpty ? "$targetApp/" : ""}lib",
      "-s",
      subDirectories.join("&"),
      "--output",
      "$currentScriptDir/../$targetApp/lib/makeups",
    ]);
  }
}
