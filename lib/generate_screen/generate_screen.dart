// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

import '/_dependencies.dart';
import '/generate_screen_configurations/generate_screen_configurations.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> generateScreen({
  String? fallbackDartSdkPath,
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
  final screenClassName = screenName.toPascalCase();
  final configurationFileName = "$screenClassKey.g.dart";
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
  final folderDirPath = join(outputDirPath, screenClassKey);
  final logicFilePath = join(folderDirPath, logicFileName);
  await _writeFile(
    logicTemplateFilePath,
    logicFilePath,
    data,
  );
  printGreen("Generated `_Logic` in `${getBaseName(logicFilePath)}");
  final screenFilePath = join(folderDirPath, screenFileName);
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
  printGreen("Generated `$screenClassName` in `${getBaseName(screenFilePath)}`");
  final stateFilePath = join(folderDirPath, stateFileName);
  await _writeFile(
    stateTemplateFilePath,
    stateFilePath,
    data,
  );
  printGreen("Generated `_State` in `${getBaseName(stateFilePath)}`");
  await generateScreenConfigurations(
    fallbackDartSdkPath: fallbackDartSdkPath,
    rootPaths: {folderDirPath},
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
  final a = internalParameters.entries
      .map((e) {
        final k = e.key;
        final v = e.value;
        return k.isNotEmpty && v.isNotEmpty ? '"$k": "$v"' : null;
      })
      .nonNulls
      .join(",");
  final b = queryParameters.map((v) => v.isNotEmpty ? '"$v"' : null).nonNulls.join(",");
  final c = pathSegments.map((v) => v.isNotEmpty ? '"$v"' : null).nonNulls.join(",");
  final configurationArgs = [
    if (isOnlyAccessibleIfSignedIn) "isOnlyAccessibleIfSignedIn: true",
    if (isOnlyAccessibleIfSignedInAndVerified) "isOnlyAccessibleIfSignedInAndVerified: true",
    if (isOnlyAccessibleIfSignedOut) "isOnlyAccessibleIfSignedOut: true",
    if (isRedirectable) "isRedirectable: true",
    if (internalParameters.isNotEmpty && a.isNotEmpty) "internalParameters: {$a,}",
    if (queryParameters.isNotEmpty && b.isNotEmpty) "queryParameters: {$b,}",
    if (pathSegments.isNotEmpty && c.isNotEmpty) "pathSegments: [$c,]",
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
  final output = replaceAllData(template, data);
  await writeFile(outputFilePath, output);
  await fmtDartFile(outputFilePath);
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class GenerateScreenArgs extends ValidObject {
  final String? fallbackDartSdkPath;
  final String? outputDirPath;
  final String? screenName;
  final String? logicTemplateFilePath;
  final String? screenTemplateFilePath;
  final String? stateTemplateFilePath;
  final String? configurationTemplateFilePath;
  final bool? isOnlyAccessibleIfSignedIn;
  final bool? isOnlyAccessibleIfSignedInAndVerified;
  final bool? isOnlyAccessibleIfSignedOut;
  final bool? isRedirectable;
  final Map<String, String>? internalParameters;
  final Set<String>? queryParameters;
  final List<String>? pathSegments;
  final String? makeup;
  final String? title;
  final String? navigator;

  const GenerateScreenArgs({
    required this.fallbackDartSdkPath,
    required this.outputDirPath,
    required this.screenName,
    required this.logicTemplateFilePath,
    required this.screenTemplateFilePath,
    required this.stateTemplateFilePath,
    required this.configurationTemplateFilePath,
    required this.isOnlyAccessibleIfSignedIn,
    required this.isOnlyAccessibleIfSignedInAndVerified,
    required this.isOnlyAccessibleIfSignedOut,
    required this.isRedirectable,
    required this.internalParameters,
    required this.queryParameters,
    required this.pathSegments,
    required this.makeup,
    required this.title,
    required this.navigator,
  });

  @override
  bool get valid => ValidObject.areValid([
        if (fallbackDartSdkPath != null) fallbackDartSdkPath,
        outputDirPath,
        screenName,
        logicTemplateFilePath,
        screenTemplateFilePath,
        stateTemplateFilePath,
        configurationTemplateFilePath,
        if (isOnlyAccessibleIfSignedInAndVerified != null) isOnlyAccessibleIfSignedInAndVerified,
        if (isOnlyAccessibleIfSignedIn != null) isOnlyAccessibleIfSignedIn,
        if (isOnlyAccessibleIfSignedOut != null) isOnlyAccessibleIfSignedOut,
        if (isRedirectable != null) isRedirectable,
        if (internalParameters != null) internalParameters,
        if (queryParameters != null) queryParameters,
        if (pathSegments != null) pathSegments,
        if (makeup != null) makeup,
        if (title != null) title,
        if (navigator != null) navigator,
      ]);
}
