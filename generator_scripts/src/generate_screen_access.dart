// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Screen Access
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

import 'package:xyz_gen/_dependencies.dart';
import 'package:xyz_gen/xyz_gen.dart';

const _OUTPUT_DIR_PATH_OPTION = "output";
const _SCREEN_CLASSES_OPTION = "screens-classes";

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> main(List<String> arguments) async {
  await basicConsoleAppBody<GenerateScreenAccessArgs>(
    appTitle: "XYZ Generate Screen Access",
    arguments: arguments,
    parser: argParserForBasicGenerator(
      rDefaultsTo: "${toLocalPathFormat(LIB_PATH)}:${toLocalPathFormat(SHARED_LIB_PATH)}",
      sDefaultsTo: "screens",
      tDefaultsTo: toLocalPathFormat(SCREEN_ACCESS_TEMPLATE_PATH),
    )
      ..addOption(
        _SCREEN_CLASSES_OPTION,
        abbr: "c",
        help: "Screen class names separated by `$SEPARATOR`.",
      )
      ..addOption(
        _OUTPUT_DIR_PATH_OPTION,
        abbr: "o",
        help: "Output directory path.",
        defaultsTo: toLocalPathFormat("$SCREENS_PATH/screen_access_g.dart"),
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
    screenClassNames: splitArg(results[_SCREEN_CLASSES_OPTION])?.toSet(),
    templateFilePath: results[TEMPLATE_FILE_PATH_OPTION],
    outputFilePath: results[_OUTPUT_DIR_PATH_OPTION],
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
