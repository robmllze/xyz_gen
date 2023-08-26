// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

import 'package:path/path.dart' as p;
import 'package:xyz_utils/xyz_utils_non_web.dart';

import '../generate_screen_configurations/generate_screen_configurations.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> generateScreen({
  required String outputDirPath,
  required String screenName,
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
  final screenFolder = p.join(outputDirPath, screenClassKey);
  final screenFilePath = p.join(screenFolder, screenFileName);
  await _writeScreenFile(
    "./templates/screen/screen.dart.md",
    screenFilePath,
    data,
  );
  printGreen("Generated `$screenClassName` in `$screenFilePath`");
  final logicFilePath = p.join(screenFolder, logicFileName);
  await _writeFile(
    "./templates/screen/logic.dart.md",
    logicFilePath,
    data,
  );
  printGreen("Generated `_Logic` in `$logicFilePath`");
  final stateFilePath = p.join(screenFolder, stateFileName);
  await _writeFile(
    "./templates/screen/state.dart.md",
    stateFilePath,
    data,
  );
  printGreen("Generated `_State` in `$stateFilePath`");
  await generateScreenConfigurations(
    rootDirPath: screenFolder,
    templateFilePath: "./templates/screen_configuration_template.md",
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
  final configurationArgs = [
    if (isOnlyAccessibleIfSignedIn) "isOnlyAccessibleIfSignedIn: true",
    if (isOnlyAccessibleIfSignedInAndVerified) "isOnlyAccessibleIfSignedInAndVerified: true",
    if (isOnlyAccessibleIfSignedOut) "isOnlyAccessibleIfSignedOut: true",
    if (isRedirectable) "isRedirectable: true",
    if (internalParameters.isNotEmpty) "internalParameters: $internalParameters",
    if (queryParameters.isNotEmpty) "queryParameters: $queryParameters",
    if (pathSegments.isNotEmpty) "pathSegments: $pathSegments",
  ].join(",");

  final superArgs = [
    if (makeup.isNotEmpty) "makeup: $makeup",
    if (title.isNotEmpty) 'title: "$title||title".screenTr()',
    if (navigator.isNotEmpty) "navigator: $navigator",
  ].join(",");

  await _writeFile(templateFilePath, outputFilePath, {
    ...data,
    "___CONFIGURATION_ARGS___": configurationArgs,
    "___SUPER_ARGS___": superArgs,
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
