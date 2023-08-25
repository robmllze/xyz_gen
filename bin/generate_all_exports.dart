// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

import 'package:args/args.dart';

import 'package:xyz_gen/generate_all_exports/generate_all_exports.dart';
import 'package:xyz_utils/xyz_utils.dart';

const DIRECTORY_OPTION = "directory";

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addOption(DIRECTORY_OPTION, abbr: "d", help: "Path to the directory.")
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

    final directoryPath = results[DIRECTORY_OPTION] as String?;

    if (directoryPath == null) {
      printRed("You must provide the -directory option.");
      printUsage(parser);
      return;
    }

    await generateAllExports(directoryPath);
  } catch (e) {
    printRed("Error: $e");
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

void printUsage(ArgParser parser) {
  printLightCyan(
    [
      "XYZ Gen All Exports Generator",
      "Usage: dart generate_all_exports.dart -d <directory_path>",
      "Example: dart generate_all_exports.dart -d ./lib/utils/",
      parser.usage
    ].join("\n"),
  );
}
