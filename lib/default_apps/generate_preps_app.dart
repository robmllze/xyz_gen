//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import '/all.dart';

import '/_internal_dependencies.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> generatePrepsApp(List<String> arguments) async {
  await basicConsoleAppBody<PrepTemplateArgs>(
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
        BasicConsoleAppOptions.ROOTS,
        abbr: "r",
        help: "Root directory paths separated by `$PARAM_SEPARATOR`.",
        defaultsTo: toLocalPathFormat("/lib"),
      )
      ..addOption(
        BasicConsoleAppOptions.SUBS,
        abbr: "s",
        help: "Sub-directory paths separated by `$PARAM_SEPARATOR`.",
      )
      ..addOption(
        BasicConsoleAppOptions.PATTERNS,
        abbr: "p",
        help: "Path patterns separated by `$PARAM_SEPARATOR`.",
      ),
    onResults: onResults,
    action: action,
  );
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

PrepTemplateArgs onResults(_, dynamic results) {
  return PrepTemplateArgs(
    rootPaths: splitArg(results[BasicConsoleAppOptions.ROOTS])?.toSet(),
    subPaths: splitArg(results[BasicConsoleAppOptions.SUBS])?.toSet(),
    pathPatterns: splitArg(results[BasicConsoleAppOptions.PATTERNS])?.toSet(),
  );
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> action(_, __, PrepTemplateArgs args) async {
  await generatePreps(
    rootPaths: args.rootPaths ?? {},
    subPaths: args.subPaths ?? {},
    pathPatterns: args.pathPatterns ?? {},
    prepMappers: [
      // Increase the build number by 1.
      (final rawKey, final value) {
        if (rawKey == "version") {
          return Version.parse(value ?? "").increase(build: 1).toString();
        }
        return null;
      }
    ],
  );
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class PrepTemplateArgs extends ValidObject {
  final Set<String>? rootPaths;
  final Set<String>? subPaths;
  final Set<String>? pathPatterns;
  const PrepTemplateArgs({
    required this.rootPaths,
    required this.subPaths,
    required this.pathPatterns,
  });

  @override
  bool get valid => ValidObject.areValid([
        this.rootPaths,
        if (this.subPaths != null) this.subPaths,
        if (this.pathPatterns != null) this.pathPatterns,
      ]);
}
