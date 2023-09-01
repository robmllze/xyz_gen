// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Generate Makeup
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

import 'package:xyz_gen/xyz_gen.dart';
import 'package:xyz_utils/xyz_utils.dart';

const _BUILDER_TEMPLATE_FILE_PATH_OPTION = "builder-template";
const _CLASS_TEMPLATE_FILE_PATH_OPTION = "class-template";
const _EXPORTS_TEMPLATE_FILE_PATH_OPTION = "exports-template";
const _OUTPUT_DIR_PATH_OPTION = "output";

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

void main(List<String> arguments) async {
  await basicConsoleAppBody<GenerateMakeupsArgs>(
    appTitle: "XYZ Generate Makeups",
    arguments: arguments,
    parser: argParserForBasicGenerator(
      rDefaultsTo: "${toLocalPathFormat(LIB_PATH)}:${toLocalPathFormat(SHARED_LIB_PATH)}",
      sDefaultsTo: "widgets",
    )
      ..addOption(
        _OUTPUT_DIR_PATH_OPTION,
        abbr: "o",
        help: "Output directory path.",
        defaultsTo: toLocalPathFormat("$LIB_PATH/makeups"),
      )
      ..addOption(
        _BUILDER_TEMPLATE_FILE_PATH_OPTION,
        abbr: "b",
        help: "Builder template file path.",
        defaultsTo: toLocalPathFormat(MAKEUP_BUILDER_TEMPLATE_PATH),
      )
      ..addOption(
        _CLASS_TEMPLATE_FILE_PATH_OPTION,
        abbr: "c",
        help: "Class template file path.",
        defaultsTo: toLocalPathFormat(MAKEUP_CLASS_TEMPLATE_PATH),
      )
      ..addOption(
        _EXPORTS_TEMPLATE_FILE_PATH_OPTION,
        abbr: "e",
        help: "Exports template file path.",
        defaultsTo: toLocalPathFormat(MAKEUP_EXPORTS_TEMPLATE_PATH),
      ),
    onResults: onResults,
    action: action,
  );
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

GenerateMakeupsArgs onResults(_, dynamic results) {
  return GenerateMakeupsArgs(
    classTemplateFilePath: results[_CLASS_TEMPLATE_FILE_PATH_OPTION],
    builderTemplateFilePath: results[_BUILDER_TEMPLATE_FILE_PATH_OPTION],
    exportsTemplateFilePath: results[_EXPORTS_TEMPLATE_FILE_PATH_OPTION],
    rootPaths: splitArg(results[ROOTS_OPTION])?.toSet(),
    subPaths: splitArg(results[SUBS_OPTION])?.toSet(),
    pathPatterns: splitArg(results[PATTERNS_OPTION])?.toSet(),
    outputDirPath: results[_OUTPUT_DIR_PATH_OPTION],
  );
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> action(_, __, GenerateMakeupsArgs args) async {
  await generateMakeups(
    rootPaths: args.rootPaths!,
    subPaths: args.subPaths ?? const {},
    pathPatterns: args.pathPatterns ?? const {},
    outputDirPath: args.outputDirPath!,
    classTemplateFilePath: args.classTemplateFilePath!,
    builderTemplateFilePath: args.builderTemplateFilePath!,
    exportsTemplateFilePath: args.exportsTemplateFilePath!,
  );
}
