// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

import 'package:args/args.dart';

import 'package:xyz_utils/xyz_utils_non_web.dart';

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

    await deleteGeneratedDartFiles(
      directoryPath,
      onDelete: (final filePath) {
        printLightYellow("Deleted generated file `$filePath`");
      },
    );
  } catch (e) {
    printRed("Error: $e");
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

void printUsage(ArgParser parser) {
  printLightCyan(
    [
      "XYZ Gen Delete Generated Dart Files",
      "Usage: dart delete_generated_dart_files.dart -d <directory_path>",
      "Example: dart delete_generated_dart_files.dart -d ./lib",
      parser.usage
    ].join("\n"),
  );
}
