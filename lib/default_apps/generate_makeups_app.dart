//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Generate Makeups App
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:path/path.dart' as p;
import '/xyz_gen.dart';
import '/get_xyz_gen_lib_path.dart';

const _BUILDER_TEMPLATE_FILE_PATH_OPTION = "builder-template";
const _CLASS_TEMPLATE_FILE_PATH_OPTION = "class-template";
const _EXPORTS_TEMPLATE_FILE_PATH_OPTION = "exports-template";
const _GENERATED_THEME_TEMPLATE_FILE_PATH_OPTION = "theme-template";
const _OUTLINE_TEMPLATE_FILE_PATH_OPTION = "outline-template";
const _OUTPUT_DIR_PATH_OPTION = "output";

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> generateMakeupsApp(List<String> arguments) async {
  final defaultTemplatesPath = p.join(await getXyzGenLibPath(), "templates", "makeup");
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
        defaultsTo: "components:widgets:makeups",
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
        defaultsTo:
            toLocalPathFormat(p.join(defaultTemplatesPath, "makeup_builder_template.dart.md")),
      )
      ..addOption(
        _CLASS_TEMPLATE_FILE_PATH_OPTION,
        abbr: "c",
        help: "Class template file path.",
        defaultsTo:
            toLocalPathFormat(p.join(defaultTemplatesPath, "makeup_class_template.dart.md")),
      )
      ..addOption(
        _EXPORTS_TEMPLATE_FILE_PATH_OPTION,
        abbr: "e",
        help: "Exports template file path.",
        defaultsTo:
            toLocalPathFormat(p.join(defaultTemplatesPath, "makeup_exports_template.dart.md")),
      )
      ..addOption(
        _GENERATED_THEME_TEMPLATE_FILE_PATH_OPTION,
        abbr: "t",
        help: "Theme template file path.",
        defaultsTo:
            toLocalPathFormat(p.join(defaultTemplatesPath, "generated_theme_template.dart.md")),
      )
      ..addOption(
        _OUTLINE_TEMPLATE_FILE_PATH_OPTION,
        abbr: "l",
        help: "Outline template file path.",
        defaultsTo:
            toLocalPathFormat(p.join(defaultTemplatesPath, "makeup_outline_template.dart.md")),
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
    generatedThemeTemplateFilePath: results[_GENERATED_THEME_TEMPLATE_FILE_PATH_OPTION],
    outlineTemplateFilePath: results[_OUTLINE_TEMPLATE_FILE_PATH_OPTION],
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
    generatedThemeTemplateFilePath: args.generatedThemeTemplateFilePath!,
    outlineTemplateFilePath: args.outlineTemplateFilePath!,
  );
}
