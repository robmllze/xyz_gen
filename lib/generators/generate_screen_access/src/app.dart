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
import '/xyz_utils/all_xyz_utils.g.dart';

import 'args.dart';
import 'generate.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> generateScreenAccessApp(List<String> arguments) async {
  await basicApp<GenerateScreenAccessArgs>(
    appTitle: "XYZ Generate Screen Access",
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
        help: "Root directory paths separated by `:`.",
        defaultsTo: toLocalPathFormat("/lib/screens"),
      )
      ..addOption(
        "subs",
        abbr: "s",
        help: "Sub-directory paths separated by `:`.",
      )
      ..addOption(
        "patterns",
        abbr: "p",
        help: "Path patterns separated by `:`.",
      )
      ..addOption(
        "additional-screen-class-names",
        help: "Additional screen class names separated by `:`.",
      )
      ..addOption(
        "template",
        abbr: "t",
        help: "Template file path.",
        defaultsTo: p.join(
          await getXyzGenLibPath(),
          "generators",
          "generate_screen_access",
          "templates",
          "default_screen_access_template.dart.md",
        ),
      )
      ..addOption(
        "output",
        abbr: "o",
        help: "Output file path.",
        defaultsTo: toLocalPathFormat("/lib/screen_access.g.dart"),
      ),
    onResults: (parser, results) {
      return GenerateScreenAccessArgs(
        rootPaths: splitArg(results["roots"])?.toSet(),
        subPaths: splitArg(results["subs"])?.toSet(),
        pathPatterns: splitArg(results["patterns"])?.toSet(),
        screenClassNames: splitArg(results["additional-screen-class-names"])?.toSet(),
        templateFilePath: results["template"],
        outputFilePath: results["output"],
      );
    },
    action: (parser, results, args) async {
      final outputFilePath = args.outputFilePath!;
      await generateScreenAccess(
        rootDirPaths: args.rootPaths ?? const {},
        subDirPaths: args.subPaths ?? const {},
        pathPatterns: args.pathPatterns ?? {},
        screenClassNames: args.screenClassNames ?? const {},
        templateFilePath: args.templateFilePath!,
        outputFilePath: outputFilePath,
      );
      await fmtDartFile(outputFilePath);
    },
  );
}
