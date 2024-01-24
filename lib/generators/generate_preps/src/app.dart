//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:args/args.dart';

import '/utils/all_utils.g.dart';
import '/xyz_utils/all_xyz_utils.g.dart';

import 'args.dart';
import 'generate.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> generatePrepsApp(List<String> arguments) async {
  await basicApp<PrepTemplateArgs>(
    appTitle: "XYZ Generate Preps",
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
        defaultsTo: toLocalPathFormat("/lib"),
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
      ),
    onResults: (parser, results) {
      return PrepTemplateArgs(
        rootPaths: splitArg(results["roots"])?.toSet(),
        subPaths: splitArg(results["subs"])?.toSet(),
        pathPatterns: splitArg(results["patterns"])?.toSet(),
      );
    },
    action: (parser, results, args) async {
      await generatePreps(
        rootDirPaths: args.rootPaths ?? {},
        subDirPaths: args.subPaths ?? {},
        pathPatterns: args.pathPatterns ?? {},
        prepMappers: [
          // Increase the build number by 1.
          (rawKey, value) {
            if (rawKey == "version") {
              return Version.parse(value ?? "").increase(build: 1).toString();
            }
            return null;
          }
        ],
      );
    },
  );
}
