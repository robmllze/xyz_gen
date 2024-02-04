//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:path/path.dart' as p;

import '/utils/src/dart_files.dart';
import 'package:xyz_utils/shared/all_shared.g.dart';

import '/generators/src/generate_screen_configurations/src/generate.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> generateScreen({
  String? fallbackDartSdkPath,
  required String outputDirPath,
  required String screenName,
  required String logicTemplateFilePath,
  required String screenTemplateFilePath,
  required String stateTemplateFilePath,
  required String configurationTemplateFilePath,
  String path = "",
  bool isAccessibleOnlyIfLoggedIn = false,
  bool isAccessibleOnlyIfLoggedInAndVerified = false,
  bool isAccessibleOnlyIfLoggedOut = false,
  bool isRedirectable = false,
  Map<String, String> internalParameters = const {},
  Set<String> queryParameters = const {},
  List<String> pathSegments = const [],
  String makeup = "",
  String title = "",
  String navigationControlWidget = "",
}) async {
  final screenClassKey = screenName.toSnakeCase();
  final screenClassName = screenName.toPascalCase();
  final configurationFileName = "_$screenClassKey.g.dart";
  final logicFileName = "_$screenClassKey.logic.dart";
  final screenFileName = "$screenClassKey.dart";
  final stateFileName = "_$screenClassKey.state.dart";
  final data = {
    "___SCREEN_CLASS___": screenClassName,
    "___CONFIGURATION_FILE___": configurationFileName,
    "___LOGIC_FILE___": logicFileName,
    "___SCREEN_FILE___": screenFileName,
    "___STATE_FILE___": stateFileName,
  };
  final folderDirPath = p.joinAll(
    [
      outputDirPath,
      if (path.isNotEmpty)
        (path.startsWith(RegExp(r"[\\/]")) ? path.substring(1) : path)
            .split(RegExp(r"[\\/]"))
            .map((e) => e.startsWith("screen_") ? e : "screen_$e")
            .join("/"),
      screenClassKey,
    ],
  );
  final logicFilePath = p.join(folderDirPath, logicFileName);
  await _writeFile(
    logicTemplateFilePath,
    logicFilePath,
    data,
  );
  printGreen("Generated `_Logic` in `${getBaseName(logicFilePath)}");
  final screenFilePath = p.join(folderDirPath, screenFileName);
  await _writeScreenFile(
    screenTemplateFilePath,
    screenFilePath,
    data,
    path: path,
    isAccessibleOnlyIfLoggedIn: isAccessibleOnlyIfLoggedIn,
    isAccessibleOnlyIfLoggedInAndVerified: isAccessibleOnlyIfLoggedInAndVerified,
    isAccessibleOnlyIfLoggedOut: isAccessibleOnlyIfLoggedOut,
    isRedirectable: isRedirectable,
    internalParameters: internalParameters,
    queryParameters: queryParameters,
    pathSegments: pathSegments,
    makeup: makeup,
    title: title,
    navigationControlWidget: navigationControlWidget,
  );
  printGreen("Generated `$screenClassName` in `${getBaseName(screenFilePath)}`");
  final stateFilePath = p.join(folderDirPath, stateFileName);
  await _writeFile(
    stateTemplateFilePath,
    stateFilePath,
    data,
  );
  printGreen("Generated `_State` in `${getBaseName(stateFilePath)}`");
  await generateScreenConfigurations(
    fallbackDartSdkPath: fallbackDartSdkPath,
    rootDirPaths: {folderDirPath},
    templateFilePath: configurationTemplateFilePath,
  );
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> _writeScreenFile(
  String templateFilePath,
  String outputFilePath,
  Map<String, String> data, {
  String path = "",
  bool isAccessibleOnlyIfLoggedIn = false,
  bool isAccessibleOnlyIfLoggedInAndVerified = false,
  bool isAccessibleOnlyIfLoggedOut = false,
  bool isRedirectable = false,
  Map<String, String> internalParameters = const {},
  Set<String> queryParameters = const {},
  List<String> pathSegments = const [],
  String makeup = "",
  String title = "",
  String navigationControlWidget = "",
}) async {
  final a = internalParameters.entries
      .map((e) {
        final k = e.key;
        final v = e.value;
        return k.isNotEmpty && v.isNotEmpty ? '"$k": "$v"' : null;
      })
      .nonNulls
      .join(",");
  final b = queryParameters.map((e) => e.isNotEmpty ? '"$e"' : null).nonNulls.join(",");
  final c = pathSegments.map((e) => e.isNotEmpty ? '"$e"' : null).nonNulls.join(",");
  final configurationArgs = [
    if (path.isNotEmpty) 'path: "$path"',
    if (title.isNotEmpty) 'defaultTitle: "$title"',
    if (navigationControlWidget.isNotEmpty) 'navigationControlWidget: "$navigationControlWidget"',
    if (makeup.isNotEmpty) 'makeup: "$makeup"',
    if (isAccessibleOnlyIfLoggedIn) "isAccessibleOnlyIfLoggedIn: true",
    if (isAccessibleOnlyIfLoggedInAndVerified) "isAccessibleOnlyIfLoggedInAndVerified: true",
    if (isAccessibleOnlyIfLoggedOut) "isAccessibleOnlyIfLoggedOut: true",
    if (isRedirectable) "isRedirectable: true",
    if (internalParameters.isNotEmpty && a.isNotEmpty) "internalParameters: {$a,}",
    if (queryParameters.isNotEmpty && b.isNotEmpty) "queryParameters: {$b,}",
    if (pathSegments.isNotEmpty && c.isNotEmpty) "pathSegments: [$c,]",
  ].join(",");
  await _writeFile(templateFilePath, outputFilePath, {
    ...data,
    "___CONFIGURATION_ARGS___": configurationArgs.isNotEmpty ? "$configurationArgs," : "",
  });
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> _writeFile(
  String templateFilePath,
  String outputFilePath,
  Map<String, String> data,
) async {
  final template = (await readDartSnippetsFromMarkdownFile(templateFilePath)).join("\n");
  final output = replaceAllData(template, data);
  await writeFile(outputFilePath, output);
  await fmtDartFile(outputFilePath);
}
