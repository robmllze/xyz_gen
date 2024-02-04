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

import 'generate.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// A command line app for generating models.
Future<void> generateModelsApp(List<String> arguments) async {
  await basicCmdAppHelper<BasicCmdAppArgs>(
    appTitle: "XYZ Gen - Generate Models",
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
        defaultsTo: toLocalPathFormat("/lib"),
      )
      ..addOption(
        "subs",
        abbr: "s",
        help: "Sub-directory paths separated by `&`.",
        defaultsTo: "models",
      )
      ..addOption(
        "patterns",
        abbr: "p",
        help: "Path patterns separated by `&`.",
      )
      ..addOption(
        "template",
        abbr: "t",
        help: "Template file path.",
        defaultsTo: p.join(
          await getXyzGenLibPath(),
          "generators",
          "generate_models",
          "templates",
          "default_model_template.dart.md",
        ),
      )
      ..addOption(
        "dart-sdk",
        help: "Dart SDK path.",
      ),
    onResults: (parser, results) {
      return BasicCmdAppArgs(
        fallbackDartSdkPath: results["dart-sdk"],
        templateFilePath: results["template"],
        rootPaths: splitArg(results["roots"])?.toSet(),
        subPaths: splitArg(results["subs"])?.toSet(),
        pathPatterns: splitArg(results["patterns"])?.toSet(),
      );
    },
    action: (parser, results, args) async {
      await generateModels(
        fallbackDartSdkPath: args.fallbackDartSdkPath,
        rootDirPaths: args.rootPaths!,
        subDirPaths: args.subPaths ?? const {},
        pathPatterns: args.pathPatterns ?? const {},
        templateFilePath: args.templateFilePath!,
      );
    },
  );
}
