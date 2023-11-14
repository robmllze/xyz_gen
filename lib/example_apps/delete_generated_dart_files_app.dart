//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Delete Generated Dart Files App
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:xyz_utils/xyz_utils_non_web.dart';
import '/xyz_gen.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> deleteGeneratedDartFilesApp(List<String> arguments) async {
  await basicConsoleAppBody<Args>(
    appTitle: "XYZ Delete Generated Dart Files",
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
        defaultsTo: toLocalPathFormat(LIB_PATH),
      ),
    onResults: onResults,
    action: action,
  );
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Args onResults(_, dynamic results) {
  return Args(
    rootPaths: splitArg(results[ROOTS_OPTION])?.toSet(),
  );
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> action(_, __, Args args) async {
  for (final rootPath in args.rootPaths!) {
    await deleteGeneratedDartFiles(
      rootPath,
      onDelete: (final filePath) {
        printLightYellow("Deleted generated file `$filePath`");
      },
    );
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class Args extends ValidObject {
  final Set<String>? rootPaths;
  const Args({required this.rootPaths});

  @override
  bool get valid => ValidObject.areValid([rootPaths]);
}
