// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

import 'package:path/path.dart' as p;
import 'package:xyz_utils/xyz_utils_non_web.dart';

import '/generate_screen_configurations/generate_screen_configurations.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> generateScreen({
  required String outputDirPath,
  required String screenName,
  required String logicTemplateFilePath,
  required String screenTemplateFilePath,
  required String stateTemplateFilePath,
  required String configurationTemplateFilePath,
  bool isOnlyAccessibleIfSignedIn = false,
  bool isOnlyAccessibleIfSignedInAndVerified = false,
  bool isOnlyAccessibleIfSignedOut = false,
  bool isRedirectable = false,
  Map<String, String> internalParameters = const {},
  Set<String> queryParameters = const {},
  List<String> pathSegments = const [],
  String makeup = "",
  String title = "",
  String navigator = "",
}) async {
  final screenClassKey = screenName.toSnakeCase();
  final screenClassName = screenName.toCamelCase();
  final configurationFileName = "_$screenClassKey.g.dart";
  final logicFileName = "_$screenClassKey.logic.dart";
  final screenFileName = "$screenClassKey.dart";
  final stateFileName = "_$screenClassKey.state.dart";
  final data = {
    "___SCREEN_CLASS___": screenClassName,
    "___CONFIGURATION_FILE___": configurationFileName,
    "___LOGIC_FILE___": logicFileName,
    "___SCREEN_FILE___": screenFileName,
    "___STATE_FILE___": logicFileName,
  };
  final folderDirPath = p.join(outputDirPath, screenClassKey);
  final logicFilePath = p.join(folderDirPath, logicFileName);
  await _writeFile(
    logicTemplateFilePath,
    logicFilePath,
    data,
  );
  printGreen("Generated `_Logic` in `$logicFilePath`");
  final screenFilePath = p.join(folderDirPath, screenFileName);
  await _writeScreenFile(
    screenTemplateFilePath,
    screenFilePath,
    data,
    isOnlyAccessibleIfSignedIn: isOnlyAccessibleIfSignedIn,
    isOnlyAccessibleIfSignedInAndVerified: isOnlyAccessibleIfSignedInAndVerified,
    isOnlyAccessibleIfSignedOut: isOnlyAccessibleIfSignedOut,
    isRedirectable: isRedirectable,
    internalParameters: internalParameters,
    queryParameters: queryParameters,
    pathSegments: pathSegments,
    makeup: makeup,
    title: title,
    navigator: navigator,
  );
  printGreen("Generated `$screenClassName` in `$screenFilePath`");
  final stateFilePath = p.join(folderDirPath, stateFileName);
  await _writeFile(
    stateTemplateFilePath,
    stateFilePath,
    data,
  );
  printGreen("Generated `_State` in `$stateFilePath`");
  await generateScreenConfigurations(
    rootDirPath: folderDirPath,
    templateFilePath: configurationTemplateFilePath,
  );
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> _writeScreenFile(
  String templateFilePath,
  String outputFilePath,
  Map<String, String> data, {
  bool isOnlyAccessibleIfSignedIn = false,
  bool isOnlyAccessibleIfSignedInAndVerified = false,
  bool isOnlyAccessibleIfSignedOut = false,
  bool isRedirectable = false,
  Map<String, String> internalParameters = const {},
  Set<String> queryParameters = const {},
  List<String> pathSegments = const [],
  String makeup = "",
  String title = "",
  String navigator = "",
}) async {
  final a = internalParameters.entries.map((e) => '"${e.key}": "${e.value}"').join(",");
  final b = queryParameters.map((v) => '"$v"').join(",");
  final c = pathSegments.map((v) => '"$v"').join(",");
  final configurationArgs = [
    if (isOnlyAccessibleIfSignedIn) "isOnlyAccessibleIfSignedIn: true",
    if (isOnlyAccessibleIfSignedInAndVerified) "isOnlyAccessibleIfSignedInAndVerified: true",
    if (isOnlyAccessibleIfSignedOut) "isOnlyAccessibleIfSignedOut: true",
    if (isRedirectable) "isRedirectable: true",
    if (internalParameters.isNotEmpty) "internalParameters: {$a,}",
    if (queryParameters.isNotEmpty) "queryParameters: {$b,}",
    if (pathSegments.isNotEmpty) "pathSegments: [$c,]",
  ].join(",");

  final superArgs = [
    if (makeup.isNotEmpty) "makeup: $makeup",
    if (title.isNotEmpty) 'title: "$title||title".screenTr()',
    if (navigator.isNotEmpty) "navigator: $navigator",
  ].join(",");

  await _writeFile(templateFilePath, outputFilePath, {
    ...data,
    "___CONFIGURATION_ARGS___": configurationArgs.isNotEmpty ? "$configurationArgs," : "",
    "___SUPER_ARGS___": superArgs.isNotEmpty ? "$superArgs," : "",
  });
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> _writeFile(
  String templateFilePath,
  String outputFilePath,
  Map<String, String> data,
) async {
  final template = await readDartTemplate(templateFilePath);
  final output = replaceExpressions(template, data);
  await writeFile(outputFilePath, output);
  await fmtDartFile(outputFilePath);
}
