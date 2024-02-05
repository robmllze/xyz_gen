//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:args/args.dart';
import 'package:path/path.dart' as p;

import '/utils/all_utils.g.dart';
import 'package:xyz_utils/shared/all_shared.g.dart';

import 'args.dart';
import 'generate.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// A command line app for generating makeups.
Future<void> generateMakeupsApp(List<String> arguments) async {
  final defaultTemplatesPath = p.join(
    await getXyzGenLibPath(),
    "generators",
    "generate_makeups",
    "templates",
  );
  await basicCmdAppHelper<GenerateMakeupsArgs>(
    appTitle: "XYZ Gen - Generate Makeups",
    arguments: arguments,
    parser: ArgParser()
      ..addFlag(
        "help",
        abbr: "h",
        negatable: false,
        help: "Help information.",
      )
      ..addOption(
        "roots",
        abbr: "r",
        help: "Root directory paths separated by `&`.",
        defaultsTo: "lib",
      )
      ..addOption(
        "subs",
        abbr: "s",
        help: "Sub-directory paths separated by `&`.",
        defaultsTo: "components&widgets",
      )
      ..addOption(
        "patterns",
        abbr: "p",
        help: "Path patterns separated by `&`.",
      )
      ..addOption(
        "output",
        abbr: "o",
        help: "Output directory path.",
        defaultsTo: toLocalSystemPathFormat("/lib/makeups"),
      )
      ..addOption(
        "builder-template",
        abbr: "b",
        help: "Builder template file path.",
        defaultsTo: p.join(
          toLocalSystemPathFormat(defaultTemplatesPath),
          "default_makeup_builder_template.dart.md",
        ),
      )
      ..addOption(
        "class-template",
        abbr: "c",
        help: "Class template file path.",
        defaultsTo: p.join(
          toLocalSystemPathFormat(defaultTemplatesPath),
          "default_makeup_class_template.dart.md",
        ),
      )
      ..addOption(
        "exports-template",
        abbr: "e",
        help: "Exports template file path.",
        defaultsTo: p.join(
          toLocalSystemPathFormat(defaultTemplatesPath),
          "default_makeup_exports_template.dart.md",
        ),
      )
      ..addOption(
        "theme-template",
        abbr: "t",
        help: "Theme template file path.",
        defaultsTo: p.join(
          toLocalSystemPathFormat(defaultTemplatesPath),
          "default_generated_theme_template.dart.md",
        ),
      )
      ..addOption(
        "generate-template",
        abbr: "g",
        help: "Generate template file path.",
        defaultsTo: p.join(
          toLocalSystemPathFormat(defaultTemplatesPath),
          "default_makeup_generate_template.dart.md",
        ),
      )
      ..addOption(
        "dart-sdk",
        help: "Dart SDK path.",
      ),
    onResults: (parser, results) {
      return GenerateMakeupsArgs(
        fallbackDartSdkPath: results["dart-sdk"],
        classTemplateFilePath: results["class-template"],
        builderTemplateFilePath: results["builder-template"],
        exportsTemplateFilePath: results["exports-template"],
        generatedThemeTemplateFilePath: results["theme-template"],
        generateTemplateFilePath: results["generate-template"],
        rootPaths: splitArg(results["roots"])?.toSet(),
        subPaths: splitArg(results["subs"])?.toSet(),
        pathPatterns: splitArg(results["patterns"])?.toSet(),
        outputDirPath: results["output"],
      );
    },
    action: (parser, results, args) async {
      await generateMakeups(
        fallbackDartSdkPath: args.fallbackDartSdkPath,
        rootPaths: args.rootPaths!,
        subDirPaths: args.subPaths ?? const {},
        pathDirPatterns: args.pathPatterns ?? const {},
        outputDirPath: args.outputDirPath!,
        classTemplateFilePath: args.classTemplateFilePath!,
        builderTemplateFilePath: args.builderTemplateFilePath!,
        exportsTemplateFilePath: args.exportsTemplateFilePath!,
        generatedThemeTemplateFilePath: args.generatedThemeTemplateFilePath!,
        generateTemplateFilePath: args.generateTemplateFilePath!,
      );
    },
  );
}
