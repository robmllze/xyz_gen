//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import '/all.dart';

import '/_internal_dependencies.dart';
import '/utils/get_xyz_gen_lib_path.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> generateScreenAccessApp(List<String> arguments) async {
  final defaultTemplatesPath = join(await getXyzGenLibPath(), "templates", "screen");
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
        BasicConsoleAppOptions.ROOTS,
        abbr: "r",
        help: "Root directory paths separated by `:`.",
        defaultsTo: toLocalPathFormat("/lib"),
      )
      ..addOption(
        BasicConsoleAppOptions.SUBS,
        abbr: "s",
        help: "Sub-directory paths separated by `:`.",
        defaultsTo: "screens",
      )
      ..addOption(
        BasicConsoleAppOptions.PATTERNS,
        abbr: "p",
        help: "Path patterns separated by `:`.",
      )
      ..addOption(
        GenerateScreenAccessAppOptions.ADDITIONAL_SCREEN_CLASS_NAMES,
        help: "Additional screen class names separated by `:`.",
      )
      ..addOption(
        BasicConsoleAppOptions.OUTPUT,
        abbr: "o",
        help: "Output file path.",
        defaultsTo: toLocalPathFormat("/lib/screen_access.g.dart"),
      )
      ..addOption(
        BasicConsoleAppOptions.TEMPLATE_FILE_PATH,
        abbr: "t",
        help: "Template file path.",
        defaultsTo: toLocalPathFormat(
          join(defaultTemplatesPath, "screen_access_template.dart.md"),
        ),
      ),
    onResults: onResults,
    action: action,
  );
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

GenerateScreenAccessArgs onResults(_, dynamic results) {
  return GenerateScreenAccessArgs(
    rootPaths: splitArg(results[BasicConsoleAppOptions.ROOTS])?.toSet(),
    subPaths: splitArg(results[BasicConsoleAppOptions.SUBS])?.toSet(),
    pathPatterns: splitArg(results[BasicConsoleAppOptions.PATTERNS])?.toSet(),
    screenClassNames:
        splitArg(results[GenerateScreenAccessAppOptions.ADDITIONAL_SCREEN_CLASS_NAMES])?.toSet(),
    templateFilePath: results[BasicConsoleAppOptions.TEMPLATE_FILE_PATH],
    outputFilePath: results[BasicConsoleAppOptions.OUTPUT],
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

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

abstract final class GenerateScreenAccessAppOptions {
  static const ADDITIONAL_SCREEN_CLASS_NAMES = "additional-screen-class-names";
}
