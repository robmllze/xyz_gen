// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Generate Models
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

import 'package:xyz_gen/xyz_gen.dart';
import 'package:xyz_utils/xyz_utils.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> main(List<String> arguments) async {
  await basicConsoleAppBody<BasicTemplateArgs>(
    appTitle: "XYZ Generate Models",
    arguments: arguments,
    parser: argParserForBasicGenerator(
      rDefaultsTo: "${toLocalPathFormat(LIB_PATH)}:${toLocalPathFormat(SHARED_LIB_PATH)}",
      sDefaultsTo: "models",
      tDefaultsTo: toLocalPathFormat(MODEL_TEMPLATE_PATH),
    ),
    onResults: onResults,
    action: action,
  );
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

BasicTemplateArgs onResults(_, dynamic results) {
  return BasicTemplateArgs(
    templateFilePath: results[TEMPLATE_FILE_PATH_OPTION],
    rootPaths: splitArg(results[ROOTS_OPTION])?.toSet(),
    subPaths: splitArg(results[SUBS_OPTION])?.toSet(),
    pathPatterns: splitArg(results[PATTERNS_OPTION])?.toSet(),
  );
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> action(_, __, BasicTemplateArgs args) async {
  await generateModels(
    templateFilePath: args.templateFilePath!,
    rootPaths: args.rootPaths!,
    subPaths: args.subPaths ?? const {},
    pathPatterns: args.pathPatterns ?? const {},
  );
}
