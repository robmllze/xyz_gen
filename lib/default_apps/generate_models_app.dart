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

Future<void> generateModelsApp(List<String> arguments) async {
  final defaultTemplatesPath = join(await getXyzGenLibPath(), "templates", "model");
  await basicConsoleAppBody<BasicTemplateArgs>(
    appTitle: "XYZ Generate Models",
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
        defaultsTo: "models",
      )
      ..addOption(
        BasicConsoleAppOptions.PATTERNS,
        abbr: "p",
        help: "Path patterns separated by `:`.",
      )
      ..addOption(
        BasicConsoleAppOptions.TEMPLATE_FILE_PATH,
        abbr: "t",
        help: "Template file path.",
        defaultsTo: toLocalPathFormat(
          join(defaultTemplatesPath, "model_template.dart.md"),
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

BasicTemplateArgs onResults(_, dynamic results) {
  return BasicTemplateArgs(
    fallbackDartSdkPath: results[BasicConsoleAppOptions.DART_SDK_PATH],
    templateFilePath: results[BasicConsoleAppOptions.TEMPLATE_FILE_PATH],
    rootPaths: splitArg(results[BasicConsoleAppOptions.ROOTS])?.toSet(),
    subPaths: splitArg(results[BasicConsoleAppOptions.SUBS])?.toSet(),
    pathPatterns: splitArg(results[BasicConsoleAppOptions.PATTERNS])?.toSet(),
  );
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> action(_, __, BasicTemplateArgs args) async {
  await generateModels(
    fallbackDartSdkPath: args.fallbackDartSdkPath,
    templateFilePath: args.templateFilePath!,
    rootPaths: args.rootPaths!,
    subPaths: args.subPaths ?? const {},
    pathPatterns: args.pathPatterns ?? const {},
  );
}
