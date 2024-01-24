//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import '/utils/all_utils.g.dart';
import '/xyz_utils/all_xyz_utils.g.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> generateScreenAccess({
  required String templateFilePath,
  required String outputFilePath,
  Set<String> rootDirPaths = const {},
  Set<String> subDirPaths = const {},
  Set<String> pathPatterns = const {},
  Set<String> screenClassNames = const {},
}) async {
  final screenClassNames1 = Set.of(screenClassNames);
  for (final dirPath in combinePathSets([rootDirPaths, subDirPaths])) {
    final filePaths = await listFilePaths(dirPath);
    if (filePaths != null) {
      filePaths.sort();
      for (final filePath in filePaths) {
        if (isGeneratedDartFilePath(filePath) && matchesAnyPathPattern(filePath, pathPatterns)) {
          var screenFileKey = getBaseName(filePath).replaceAll(".g.dart", "");
          screenFileKey =
              screenFileKey.startsWith("_") ? screenFileKey.substring(1) : screenFileKey;
          if (screenFileKey.startsWith("screen_")) {
            final contents = await readFile(filePath);
            if (contents != null) {
              final x = RegExp("const +_CLASS += +[\"'](\\w+)[\"'];");
              final match = x.firstMatch(contents);
              if (match != null && match.groupCount == 1) {
                final screenClassName = match.group(1);
                if (screenClassName != null) {
                  final screenClassKey = screenClassName.toSnakeCase();
                  if (screenFileKey != screenClassKey) {
                    printLightYellow(
                      "Key mismatch $screenFileKey != $screenClassKey",
                    );
                  }
                  screenClassNames1.add(screenClassName);
                }
              }
            }
          }
        }
      }
    }
  }
  final sorted = screenClassNames1.toList()..sort();
  final keys = sorted.map((e) => e.toSnakeCase().toUpperCase());
  final a = sorted.map((e) => "maker$e").join(",");
  final b = keys.map((e) => "...PATH_$e").join(",");
  final c = keys.map((e) => "...PATH_NOT_REDIRECTABLE_$e").join(",");
  final d = keys.map((e) => "...PATH_ALWAYS_ACCESSIBLE_$e").join(",");
  final e = keys.map((e) => "...PATH_ACCESSIBLE_ONLY_IF_LOGGED_IN_AND_VERIFIED_$e").join(",");
  final f = keys.map((e) => "...PATH_ACCESSIBLE_ONLY_IF_LOGGED_IN_$e").join(",");
  final g = keys.map((e) => "...PATH_ACCESSIBLE_ONLY_IF_LOGGED_OUT_$e").join(",");
  final h = sorted.map((e) => "...cast${e}Configuration").join(",");
  final i = sorted.map((e) => "generated${e}Route").join(",");
  final template = (await readDartSnippetsFromMarkdownFile(templateFilePath)).join("\n");
  final outputContent = replaceAllData(template, {
    "___SCREEN_MAKERS___": a,
    "___PATHS___": b,
    "___PATHS_NOT_REDIRECTABLE___": c,
    "___PATHS_ALWAYS_ACCESSIBLE___": d,
    "___PATHS_ACCESSIBLE_ONLY_IF_LOGGED_IN_AND_VERIFIED___": e,
    "___PATHS_ACCESSIBLE_ONLY_IF_LOGGED_IN___": f,
    "___PATHS_ACCESSIBLE_ONLY_IF_LOGGED_OUT___": g,
    "___SCREEN_CONFIGURATION_CASTS___": h,
    "___GENERATED_SCREEN_ROUTES___": i,
  });
  await writeFile(outputFilePath, outputContent);
  printGreen(
    "Generated screen access for ${sorted.map((e) => "`$e`").joinWithLastSeparator()} in `${getBaseName(outputFilePath)}`",
  );
}