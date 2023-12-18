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

Future<void> generateMakeupsApp(List<String> arguments) async {
  final defaultTemplatesPath = join(await getXyzGenLibPath(), "templates", "makeup");
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
        BasicConsoleAppOptions.ROOTS,
        abbr: "r",
        help: "Root directory paths separated by `:`.",
        defaultsTo: toLocalPathFormat("/lib"),
      )
      ..addOption(
        BasicConsoleAppOptions.SUBS,
        abbr: "s",
        help: "Sub-directory paths separated by `:`.",
        defaultsTo: "components:makeups:widgets",
      )
      ..addOption(
        BasicConsoleAppOptions.PATTERNS,
        abbr: "p",
        help: "Path patterns separated by `:`.",
      )
      ..addOption(
        BasicConsoleAppOptions.OUTPUT,
        abbr: "o",
        help: "Output directory path.",
        defaultsTo: toLocalPathFormat("/lib/makeups"),
      )
      ..addOption(
        GenerateMakeupsAppOptions.BUILDER_TEMPLATE_FILE_PATH,
        abbr: "b",
        help: "Builder template file path.",
        defaultsTo: toLocalPathFormat(
          join(defaultTemplatesPath, "makeup_builder_template.dart.md"),
        ),
      )
      ..addOption(
        GenerateMakeupsAppOptions.CLASS_TEMPLATE_FILE_PATH,
        abbr: "c",
        help: "Class template file path.",
        defaultsTo: toLocalPathFormat(
          join(defaultTemplatesPath, "makeup_class_template.dart.md"),
        ),
      )
      ..addOption(
        GenerateMakeupsAppOptions.EXPORTS_TEMPLATE_FILE_PATH,
        abbr: "e",
        help: "Exports template file path.",
        defaultsTo: toLocalPathFormat(
          join(defaultTemplatesPath, "makeup_exports_template.dart.md"),
        ),
      )
      ..addOption(
        GenerateMakeupsAppOptions.GENERATED_THEME_TEMPLATE_FILE_PATH,
        abbr: "t",
        help: "Theme template file path.",
        defaultsTo: toLocalPathFormat(
          join(defaultTemplatesPath, "generated_theme_template.dart.md"),
        ),
      )
      ..addOption(
        GenerateMakeupsAppOptions.OUTLINE_TEMPLATE_FILE_PATH,
        abbr: "g",
        help: "Generate template file path.",
        defaultsTo: toLocalPathFormat(
          join(defaultTemplatesPath, "makeup_generate_template.dart.md"),
        ),
      )
      ..addOption(
        BasicConsoleAppOptions.DART_SDK_PATH,
        help: "Dart SDK path.",
      ),
    onResults: onResults,
    action: action,
  );
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

GenerateMakeupsArgs onResults(_, dynamic results) {
  return GenerateMakeupsArgs(
    fallbackDartSdkPath: results[BasicConsoleAppOptions.DART_SDK_PATH],
    classTemplateFilePath: results[GenerateMakeupsAppOptions.CLASS_TEMPLATE_FILE_PATH],
    builderTemplateFilePath: results[GenerateMakeupsAppOptions.BUILDER_TEMPLATE_FILE_PATH],
    exportsTemplateFilePath: results[GenerateMakeupsAppOptions.EXPORTS_TEMPLATE_FILE_PATH],
    generatedThemeTemplateFilePath:
        results[GenerateMakeupsAppOptions.GENERATED_THEME_TEMPLATE_FILE_PATH],
    outlineTemplateFilePath: results[GenerateMakeupsAppOptions.OUTLINE_TEMPLATE_FILE_PATH],
    rootPaths: splitArg(results[BasicConsoleAppOptions.ROOTS])?.toSet(),
    subPaths: splitArg(results[BasicConsoleAppOptions.SUBS])?.toSet(),
    pathPatterns: splitArg(results[BasicConsoleAppOptions.PATTERNS])?.toSet(),
    outputDirPath: results[BasicConsoleAppOptions.OUTPUT],
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

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

abstract final class GenerateMakeupsAppOptions {
  static const BUILDER_TEMPLATE_FILE_PATH = "builder-template";
  static const CLASS_TEMPLATE_FILE_PATH = "class-template";
  static const EXPORTS_TEMPLATE_FILE_PATH = "exports-template";
  static const GENERATED_THEME_TEMPLATE_FILE_PATH = "theme-template";
  static const OUTLINE_TEMPLATE_FILE_PATH = "outline-template";
}
