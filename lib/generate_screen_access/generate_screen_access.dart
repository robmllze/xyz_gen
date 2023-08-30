// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

import '/_dependencies.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> generateScreenAccess({
  required String templateFilePath,
  required String outputFilePath,
  Set<String> rootPaths = const {},
  Set<String> subPaths = const {},
  Set<String> pathPatterns = const {},
  Set<String> screenClassNames = const {},
}) async {
  //

  final combinedPaths = combinePaths([rootPaths, subPaths]);
  final screenClassNames1 = Set.of(screenClassNames);

  //

  for (final path in combinedPaths) {
    final filePaths = await listFilePaths(path);
    if (filePaths != null) {
      filePaths.sort();
      for (final filePath in filePaths) {
        if (isGeneratedDartFilePath(filePath, pathPatterns)) {
          final screenFileKey = getBaseName(filePath).replaceAll(".g.dart", "");
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
                    printLightYellow("Key mismatch $screenFileKey != $screenClassKey");
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

  //

  final sorted = screenClassNames1.toList()..sort();
  final keys = sorted.map((e) => e.toSnakeCase().toUpperCase());
  final a = sorted.map((e) => "maker$e").join(",");
  final b = keys.map((e) => "...PATH_NOT_REDIRECTABLE_$e").join(",");
  final c = keys.map((e) => "...PATH_ACCESSIBLE_$e").join(",");
  final d = keys.map((e) => "...PATH_ACCESSIBLE_ONLY_IF_SIGNED_IN_AND_VERIFIED_$e").join(",");
  final e = keys.map((e) => "...PATH_ACCESSIBLE_ONLY_IF_SIGNED_IN_$e").join(",");
  final f = keys.map((e) => "...PATH_ACCESSIBLE_ONLY_IF_SIGNED_OUT_$e").join(",");
  final template = await readDartTemplate(templateFilePath);
  final outputContent = replaceAllData(template, {
    "___SCREEN_MAKERS___": a,
    "___PATHS_NOT_REDIRECTABLE___": b,
    "___PATHS_ACCESSIBLE___": c,
    "___PATHS_ACCESSIBLE_ONLY_IF_SIGNED_IN_AND_VERIFIED___": d,
    "___PATHS_ACCESSIBLE_ONLY_IF_SIGNED_IN___": e,
    "___PATHS_ACCESSIBLE_ONLY_IF_SIGNED_OUT___": f,
  });
  await writeFile(outputFilePath, outputContent);
  final joined = sorted.map((e) => "`$e`").joinWithLastSeparator(lastSeparator: " and ");
  printGreen(
    "Generated screen access for $joined in `${getBaseName(outputFilePath)}`",
  );
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class GenerateScreenAccessArgs extends ValidObject {
  final Set<String>? rootPaths;
  final Set<String>? subPaths;
  final Set<String>? pathPatterns;
  final Set<String>? screenClassNames;
  final String? templateFilePath;
  final String? outputFilePath;

  const GenerateScreenAccessArgs({
    required this.rootPaths,
    required this.subPaths,
    required this.pathPatterns,
    required this.screenClassNames,
    required this.templateFilePath,
    required this.outputFilePath,
  });

  @override
  bool get valid {
    final a = [
      if (this.rootPaths != null) this.rootPaths,
      if (this.subPaths != null) this.subPaths,
      if (this.screenClassNames != null) this.screenClassNames,
    ];
    return ValidObject.areValid([
      a,
      ...a,
      if (this.pathPatterns != null) this.pathPatterns,
      this.templateFilePath,
      this.outputFilePath,
    ]);
  }
}
