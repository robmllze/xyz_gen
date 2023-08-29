// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

import 'package:args/args.dart';

import 'package:xyz_gen/generate_all_exports/generate_all_exports.dart';
import 'package:xyz_utils/xyz_utils.dart';

const ROOT_OPTION = "root";

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addOption(
      ROOT_OPTION,
      abbr: "r",
      help: "Path to the root directory.",
    )
    ..addFlag(
      "help",
      abbr: "h",
      negatable: false,
      help: "Displays the help information.",
    );

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

    if (root == null) {
      printRed("You must provide the -root option.");
      printUsage(parser);
      return;
    }

    await generateAllExports(root);
  } catch (e) {
    printRed("Error: $e");
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

void printUsage(ArgParser parser) {
  printLightCyan(
    [
      "XYZ Gen All Exports Generator",
      "Usage: dart generate_all_exports.dart -r <root_directory_path>",
      "Example: dart generate_all_exports.dart -r ../my_xyz_project/lib/",
      parser.usage
    ].join("\n"),
  );
}
