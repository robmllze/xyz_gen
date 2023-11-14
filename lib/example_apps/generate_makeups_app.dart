//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Generate Makeups App
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import '/xyz_gen.dart';

const _BUILDER_TEMPLATE_FILE_PATH_OPTION = "builder-template";
const _CLASS_TEMPLATE_FILE_PATH_OPTION = "class-template";
const _EXPORTS_TEMPLATE_FILE_PATH_OPTION = "exports-template";
const _OUTPUT_DIR_PATH_OPTION = "output";

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> generateMakeupsApp(List<String> arguments) async {
  await basicConsoleAppBody<GenerateMakeupsArgs>(
    appTitle: "XYZ Generate Makeups",
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
        defaultsTo: "${toLocalPathFormat(LIB_PATH)}:${toLocalPathFormat(SHARED_LIB_PATH)}",
      )
      ..addOption(
        SUBS_OPTION,
        abbr: "s",
        help: "Sub-directory paths separated by `$SEPARATOR`.",
        defaultsTo: "widgets",
      )
      ..addOption(
        PATTERNS_OPTION,
        abbr: "p",
        help: "Path patterns separated by `$SEPARATOR`.",
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
      )
      ..addOption(
        DART_SDK_PATH_OPTION,
        help: "Dart SDK path.",
      ),
    onResults: onResults,
    action: action,
  );
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

GenerateMakeupsArgs onResults(_, dynamic results) {
  return GenerateMakeupsArgs(
    fallbackDartSdkPath: results[DART_SDK_PATH_OPTION],
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
    fallbackDartSdkPath: args.fallbackDartSdkPath,
    rootPaths: args.rootPaths!,
    subPaths: args.subPaths ?? const {},
    pathPatterns: args.pathPatterns ?? const {},
    outputDirPath: args.outputDirPath!,
    classTemplateFilePath: args.classTemplateFilePath!,
    builderTemplateFilePath: args.builderTemplateFilePath!,
    exportsTemplateFilePath: args.exportsTemplateFilePath!,
  );
}