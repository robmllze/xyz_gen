// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

import 'dart:io';
import 'package:xyz_gen/generate_models/generate_models.dart';
import 'package:args/args.dart';
import 'package:xyz_utils/xyz_utils_non_web.dart';

const rootDirOption = "root";
const templateFileOption = "template";

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addOption(rootDirOption, abbr: "r", help: "Path to the root directory.")
    ..addOption(templateFileOption, abbr: "t", help: "Path to the template file.")
    ..addFlag("help", abbr: "h", negatable: false, help: "Displays the help information.");

  try {
    late ArgResults results;
    try {
      results = parser.parse(arguments);
    } catch (e) {
      printRed("Error: Failed to parse arguments.");
      return;
    }
    if (results["help"]) {
      printUsage(parser);
      return;
    }

    final rootDir = results[rootDirOption] as String?;
    final templateFile = results[templateFileOption] as String?;

    if (rootDir == null || templateFile == null) {
      printRed("You must provide both -root and -template options.");
      printUsage(parser);
      exit(1);
    }

    await generateModels(
      rootDirPath: rootDir,
      templateFilePath: templateFile,
    );
  } catch (e) {
    printRed("Error: $e");
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

void printUsage(ArgParser parser) {
  printLightCyan(
    [
      "XYZ Gen Model Generator",
      "Usage: dart generate_models.dart -r <root_directory> -t <template_file>",
      "Example: dart generate_models.dart -r ./my_xyz_project/lib/models/ -t ./templates/model_template.md",
      parser.usage
    ].join("\n"),
  );
}
