//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
//  XYZ Generate All Exports App
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:path/path.dart' as p;
import '/xyz_gen.dart';
import '/get_xyz_gen_lib_path.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> generateAllExportsApp(List<String> arguments) async {
  final defaultTemplatesPath = p.join(await getXyzGenLibPath(), "templates");
  await basicConsoleAppBody<BasicTemplateArgs>(
    appTitle: "XYZ Generate All Exports",
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
        defaultsTo:
            "app:components:configs:lib:makeups:managers:models:routing:screens:services:src:themes:utils:widgets",
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
        defaultsTo: toLocalPathFormat(p.join(defaultTemplatesPath, "all_exports_template.dart.md")),
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
  await generateAllExports(
    templateFilePath: args.templateFilePath!,
    rootPaths: args.rootPaths!,
    subPaths: args.subPaths ?? const {},
    pathPatterns: args.pathPatterns ?? const {},
  );
}
