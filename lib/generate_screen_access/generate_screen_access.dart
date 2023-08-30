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
  final screenClassNames1 = Set.from(screenClassNames);

  //

  for (final path in combinedPaths) {
    final filePaths = await listFilePaths(path);
    if (filePaths != null) {
      filePaths.sort();
      for (final filePath in filePaths) {
        if (isGeneratedDartFilePath(filePath, pathPatterns)) {
          final screenFileName = getBaseName(filePath).replaceAll(".g", "");
          if (screenFileName.startsWith("screen_")) {
            final contents = await readFile(filePath);
            if (contents != null) {
              final x = RegExp("const +_CLASS += +[\"'](\\w+)[\"'];");
              final match = x.firstMatch(contents);
              if (match != null && match.groupCount == 2) {
                final screenClassName = match.group(1);
                if (screenClassName != null) {
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
  final b = keys.map((e) => "...PATHS_NOT_REDIRECTABLE_$e").join(",");
  final c = keys.map((e) => "...PATHS_ACCESSIBLE_$e").join(",");
  final d = keys.map((e) => "...PATHS_ACCESSIBLE_ONLY_IF_SIGNED_IN_AND_VERIFIED_$e").join(",");
  final e = keys.map((e) => "...PATHS_ACCESSIBLE_ONLY_IF_SIGNED_IN_$e").join(",");
  final f = keys.map((e) => "...PATHS_ACCESSIBLE_ONLY_IF_SIGNED_OUT_$e").join(",");
  final g = sorted.map((e) => "...cast$e").join(",");
  final aa = "const SCREEN_MAKERS = [$a,];";
  final bb = "const PATHS_NOT_REDIRECTABLE = [$b,];";
  final cc = "const PATHS_ACCESSIBLE = [$c,];";
  final dd = "const PATHS_ACCESSIBLE_ONLY_IF_SIGNED_IN_AND_VERIFIED = [$d,];";
  final ee = "const PATHS_ACCESSIBLE_ONLY_IF_SIGNED_IN = [$e,];";
  final ff = "const PATHS_ACCESSIBLE_ONLY_IF_SIGNED_OUT = [$f,];";
  final gg =
      "final configurationCasts = Map<Type, MyRouteConfiguration Function(MyRouteConfiguration)>.unmodifiable({$g});";
  final all = [aa, bb, cc, dd, ee, ff, gg].join("\n\n");
  final template = await readDartTemplate(templateFilePath);
  final outputContent = template.replaceAll("___BODY___", all);
  await writeFile(outputFilePath, outputContent);
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class GenerateScreenAccessArgs extends ValidObject {
  final String? templateFilePath;
  final String? outputFilePath;
  final Set<String>? screenClassNames;
  const GenerateScreenAccessArgs({
    required this.templateFilePath,
    required this.outputFilePath,
    required this.screenClassNames,
  });

  @override
  bool get valid => ValidObject.areValid([
        this.templateFilePath,
        this.outputFilePath,
        this.screenClassNames,
      ]);
}
