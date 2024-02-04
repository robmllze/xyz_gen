//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:args/args.dart';

import '/utils/all_utils.g.dart';
import 'package:xyz_utils/shared/all_shared.g.dart';

import 'args.dart';
import 'generate.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> generateForAnnotationTestApp(List<String> arguments) async {
  await basicCmdAppHelper<GenerateForAnnotationTestApp>(
    appTitle: "XYZ Gen - Generate For Annotation Test",
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
      )
      ..addOption(
        "patterns",
        abbr: "p",
        help: "Path patterns separated by `&`.",
      )
      ..addOption(
        "dart-sdk",
        help: "Dart SDK path.",
      ),
    onResults: (parser, results) {
      return GenerateForAnnotationTestApp(
        rootPaths: splitArg(results["roots"])?.toSet(),
        subPaths: splitArg(results["subs"])?.toSet(),
        pathPatterns: splitArg(results["patterns"])?.toSet(),
        fallbackDartSdkPath: results["dart-sdk"],
      );
    },
    action: (parser, results, args) async {
      await generateForAnnotationTest(
        rootDirPaths: args.rootPaths ?? {},
        subDirPaths: args.subPaths ?? {},
        pathPatterns: args.pathPatterns ?? {},
      );
    },
  );
}
