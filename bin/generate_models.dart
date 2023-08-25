// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

import 'dart:io';
import 'package:args/args.dart';

import 'package:xyz_gen/generate_models/generate_models.dart';
import 'package:xyz_utils/xyz_utils.dart';

const ROOT_OPTION = "root";
const TEMPLATE_OPTION = "template";

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addOption(ROOT_OPTION, abbr: "r", help: "Path to the root directory.")
    ..addOption(TEMPLATE_OPTION, abbr: "t", help: "Path to the template file.")
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

    final root = results[ROOT_OPTION] as String?;
    final templateFile = results[TEMPLATE_OPTION] as String?;

    if (root == null || templateFile == null) {
      printRed("You must provide both -root and -template options.");
      printUsage(parser);
      exit(1);
    }

    await generateModels(
      rootDirPath: root,
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
      "Usage: dart generate_models.dart -r <root_directory_path> -t <template_file_path>",
      "Example: dart generate_models.dart -r ./my_xyz_project/lib/models/ -t ./templates/model_template.md",
      parser.usage
    ].join("\n"),
  );
}
