// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

import 'dart:io';
import 'package:args/args.dart';
import 'package:xyz_gen/generate_makeups/generate_makeups.dart';

const ROOT_OPTION = "root";
const OUTPUT_OPTION = "output";
const CLASS_TEMPLATE_OPTION = "class-template";
const BUILDER_TEMPLATE_OPTION = "builder-template";
const EXPORTS_TEMPLATE_OPTION = "exports-template";

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addOption(ROOT_OPTION, abbr: "r", help: "Path to the root directory.")
    ..addOption(OUTPUT_OPTION, abbr: "o", help: "Path to the output directory.")
    ..addOption(CLASS_TEMPLATE_OPTION, abbr: "c", help: "Path to the class template file.")
    ..addOption(BUILDER_TEMPLATE_OPTION, abbr: "b", help: "Path to the builder template file.")
    ..addOption(EXPORTS_TEMPLATE_OPTION, abbr: "e", help: "Path to the exports template file.")
    ..addFlag("help", abbr: "h", negatable: false, help: "Displays the help information.");

  try {
    final results = parser.parse(arguments);

    if (results["help"]) {
      _printUsage(parser);
      return;
    }

    final root = results[ROOT_OPTION] as String?;
    final output = results[OUTPUT_OPTION] as String?;
    final classTemplateFile = results[CLASS_TEMPLATE_OPTION] as String?;
    final builderTemplateFile = results[BUILDER_TEMPLATE_OPTION] as String?;
    final exportsTemplateFile = results[EXPORTS_TEMPLATE_OPTION] as String?;

    if ([root, output, classTemplateFile, builderTemplateFile, exportsTemplateFile]
        .contains(null)) {
      print("You must provide all the required options.");
      _printUsage(parser);
      exit(1);
    }

    await generateMakeups(
      rootDirPath: root!,
      outputDirPath: output!,
      classTemplateFilePath: classTemplateFile!,
      builderTemplateFilePath: builderTemplateFile!,
      exportsTemplateFilePath: exportsTemplateFile!,
    );
  } catch (e) {
    print("Error: $e");
  }
}

void _printUsage(ArgParser parser) {
  print(
    [
      "XYZ Gen - Makeups Generator",
      "Usage: dart generate_makeups.dart -r <root_directory_path> -o <output_directory_path> -c <class_template_path> -b <builder_template_path> -e <exports_template_path>",
      "Example: dart generate_makeups.dart -r ../my_xyz_project/lib/widgets/ -o ../my_xyz_project/lib/makeups/ -c ../templates/makeup_class_template.md -b ../templates/makeup_builder_template.md -e ../templates/makeup_exports_template.md",
      parser.usage
    ].join("\n"),
  );
}
