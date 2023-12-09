//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Screen Access App
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import '/all.dart';

import '../_internal_dependencies.dart';
import '../utils/get_xyz_gen_lib_path.dart';

const _ADDITIONAL_SCREEN_CLASS_NAMES_OPTION = "additional-screen-class-names";

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> generateScreenAccessApp(List<String> arguments) async {
  final defaultTemplatesPath =
      join(await getXyzGenLibPath(), "templates", "screen");
  await basicConsoleAppBody<GenerateScreenAccessArgs>(
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
        ROOTS_OPTION,
        abbr: "r",
        help: "Root directory paths separated by `$SEPARATOR`.",
        defaultsTo: toLocalPathFormat("/lib"),
      )
      ..addOption(
        SUBS_OPTION,
        abbr: "s",
        help: "Sub-directory paths separated by `$SEPARATOR`.",
        defaultsTo: "screens",
      )
      ..addOption(
        PATTERNS_OPTION,
        abbr: "p",
        help: "Path patterns separated by `$SEPARATOR`.",
      )
      ..addOption(
        _ADDITIONAL_SCREEN_CLASS_NAMES_OPTION,
        help: "Additional screen class names separated by `$SEPARATOR`.",
      )
      ..addOption(
        OUTPUT_OPTION,
        abbr: "o",
        help: "Output file path.",
        defaultsTo: toLocalPathFormat("/lib/screen_access.g.dart"),
      )
      ..addOption(
        TEMPLATE_FILE_PATH_OPTION,
        abbr: "t",
        help: "Template file path.",
        defaultsTo: toLocalPathFormat(
            join(defaultTemplatesPath, "screen_access_template.dart.md")),
      ),
    onResults: onResults,
    action: action,
  );
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

GenerateScreenAccessArgs onResults(_, dynamic results) {
  return GenerateScreenAccessArgs(
    rootPaths: splitArg(results[ROOTS_OPTION])?.toSet(),
    subPaths: splitArg(results[SUBS_OPTION])?.toSet(),
    pathPatterns: splitArg(results[PATTERNS_OPTION])?.toSet(),
    screenClassNames:
        splitArg(results[_ADDITIONAL_SCREEN_CLASS_NAMES_OPTION])?.toSet(),
    templateFilePath: results[TEMPLATE_FILE_PATH_OPTION],
    outputFilePath: results[OUTPUT_OPTION],
  );
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> action(_, __, GenerateScreenAccessArgs args) async {
  final outputFilePath = args.outputFilePath!;
  await generateScreenAccess(
    rootPaths: args.rootPaths ?? const {},
    subPaths: args.subPaths ?? const {},
    pathPatterns: args.pathPatterns ?? {},
    screenClassNames: args.screenClassNames ?? const {},
    templateFilePath: args.templateFilePath!,
    outputFilePath: outputFilePath,
  );
  await fmtDartFile(outputFilePath);
}
