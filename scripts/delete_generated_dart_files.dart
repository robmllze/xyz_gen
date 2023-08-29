// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

import 'package:args/args.dart';

import 'package:xyz_utils/xyz_utils_non_web.dart';

const ROOT_OPTION = "root";

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addOption(ROOT_OPTION, abbr: "r", help: "Path to the root directory.")
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

    if (root == null) {
      printRed("You must provide the -root option.");
      printUsage(parser);
      return;
    }

    await deleteGeneratedDartFiles(
      root,
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
      "Usage: dart delete_generated_dart_files.dart -r <root_directory_path>",
      "Example: dart delete_generated_dart_files.dart -r ../my_xyz_project/lib",
      parser.usage
    ].join("\n"),
  );
}
