//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Generate Screen Configurations App
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import '/xyz_gen.dart';
import '/get_xyz_gen_lib_path.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> generateScreenConfigurationsApp(List<String> arguments) async {
  final defaultTemplatesPath = "templates/${await getXyzGenLibPath()}";
  await basicConsoleAppBody<BasicTemplateArgs>(
    appTitle: "XYZ Generate Screen Configurations",
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
        defaultsTo: "screens",
      )
      ..addOption(
        PATTERNS_OPTION,
        abbr: "p",
        help: "Path patterns separated by `$SEPARATOR`.",
      )
      ..addOption(
        TEMPLATE_FILE_PATH_OPTION,
        abbr: "t",
        help: "Template file path.",
        defaultsTo: toLocalPathFormat("$defaultTemplatesPath/screen_access_template.dart.md"),
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

BasicTemplateArgs onResults(_, dynamic results) {
  return BasicTemplateArgs(
    fallbackDartSdkPath: results[DART_SDK_PATH_OPTION],
    templateFilePath: results[TEMPLATE_FILE_PATH_OPTION],
    rootPaths: splitArg(results[ROOTS_OPTION])?.toSet(),
    subPaths: splitArg(results[SUBS_OPTION])?.toSet(),
    pathPatterns: splitArg(results[PATTERNS_OPTION])?.toSet(),
  );
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> action(_, __, BasicTemplateArgs args) async {
  await generateScreenConfigurations(
    fallbackDartSdkPath: args.fallbackDartSdkPath,
    templateFilePath: args.templateFilePath!,
    rootPaths: args.rootPaths!,
    subPaths: args.subPaths ?? const {},
    pathPatterns: args.pathPatterns ?? const {},
  );
}
