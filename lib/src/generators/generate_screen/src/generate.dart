//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// 🇽🇾🇿 & Dev
//
// Licencing details are in the LICENSE file in the root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:path/path.dart' as p;

import '/_common.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> generateScreen({
  String? fallbackDartSdkPath,
  required String outputDirPath,
  required String screenName,
  required String controllerTemplateFilePath,
  required String screenTemplateFilePath,
  required String viewTemplateFilePath,
  required String bindingsTemplateFilePath,
  String path = '',
  bool isAccessibleOnlyIfLoggedIn = false,
  bool isAccessibleOnlyIfLoggedInAndVerified = false,
  bool isAccessibleOnlyIfLoggedOut = false,
  bool isRedirectable = false,
  Map<String, String> internalParameters = const {},
  Set<String> queryParameters = const {},
  List<String> pathSegments = const [],
  String makeup = '',
  String title = '',
  String navigationControlWidget = '',
  Set<String> partFileDirs = const {},
}) async {
  Here().debugLogStart('Starting generator. Please wait...');
  final screenClassKey = screenName.toSnakeCase();
  final screenClassName = screenName.toPascalCase();
  const BINDINGS_FILE_NAME = '_bindings.g.dart';
  const CONTROLLER_FILE_NAME = '_controller.dart';
  final screenFileName = '$screenClassKey.dart';
  const VIEW_FILE_NAME = '_view.dart';
  final data = {
    '___SCREEN_CLASS___': screenClassName,
    '___BINDINGS_FILE___': BINDINGS_FILE_NAME,
    '___CONTROLLER_FILE___': CONTROLLER_FILE_NAME,
    '___SCREEN_FILE___': screenFileName,
    '___VIEW_FILE___': VIEW_FILE_NAME,
  };
  final folderDirPath = p.joinAll(
    [
      outputDirPath,
      if (path.isNotEmpty) path.startsWith(RegExp(r'[\\/]')) ? path.substring(1) : path,
      screenClassKey,
    ],
  );
  final controllerFilePath = p.join(folderDirPath, CONTROLLER_FILE_NAME);
  await _writeFile(
    controllerTemplateFilePath,
    controllerFilePath,
    data,
  );
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
    partFileDirs: partFileDirs,
  );
  final stateFilePath = p.join(folderDirPath, VIEW_FILE_NAME);
  await _writeFile(
    viewTemplateFilePath,
    stateFilePath,
    data,
  );
  await generateScreenBindings(
    fallbackDartSdkPath: fallbackDartSdkPath,
    rootDirPaths: {folderDirPath},
    templateFilePath: bindingsTemplateFilePath,
  );
  Here().debugLogStop('Done!');
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> _writeScreenFile(
  String templateFilePath,
  String outputFilePath,
  Map<String, String> data, {
  String path = '',
  bool isAccessibleOnlyIfLoggedIn = false,
  bool isAccessibleOnlyIfLoggedInAndVerified = false,
  bool isAccessibleOnlyIfLoggedOut = false,
  bool isRedirectable = false,
  Map<String, String> internalParameters = const {},
  Set<String> queryParameters = const {},
  List<String> pathSegments = const [],
  String makeup = '',
  String title = '',
  String navigationControlWidget = '',
  Set<String> partFileDirs = const {},
}) async {
  final a = internalParameters.entries
      .map((e) {
        final k = e.key;
        final v = e.value;
        return k.isNotEmpty && v.isNotEmpty ? "'$k': '$v'" : null;
      })
      .nonNulls
      .join(',');
  final b = queryParameters.map((e) => e.isNotEmpty ? "'$e'" : null).nonNulls.join(',');
  final c = pathSegments.map((e) => e.isNotEmpty ? "'$e'" : null).nonNulls.join(',');
  final generateScreenBindingsArgs = [
    if (path.isNotEmpty) "path: '$path'",
    if (title.isNotEmpty) "defaultTitle: '$title'",
    if (navigationControlWidget.isNotEmpty) "navigationControlWidget: '$navigationControlWidget'",
    if (makeup.isNotEmpty) "makeup: '$makeup'",
    if (isAccessibleOnlyIfLoggedIn) 'isAccessibleOnlyIfLoggedIn: true',
    if (isAccessibleOnlyIfLoggedInAndVerified) 'isAccessibleOnlyIfLoggedInAndVerified: true',
    if (isAccessibleOnlyIfLoggedOut) 'isAccessibleOnlyIfLoggedOut: true',
    if (isRedirectable) 'isRedirectable: true',
    if (internalParameters.isNotEmpty && a.isNotEmpty) 'internalParameters: {$a,}',
    if (queryParameters.isNotEmpty && b.isNotEmpty) 'queryParameters: {$b,}',
    if (pathSegments.isNotEmpty && c.isNotEmpty) 'pathSegments: [$c,]',
  ].join(',');
  await _writeFile(templateFilePath, outputFilePath, {
    ...data,
    '___GENERATE_SCREEN_BINDINGS_ARGS___':
        generateScreenBindingsArgs.isNotEmpty ? '$generateScreenBindingsArgs,' : '',
    '___PARTS___': partFileDirs.isNotEmpty
        ? '// @GenerateDirectives\n${partFileDirs.map((e) => e.toLowerCase().endsWith('.dart') ? e : '$e.dart').map((e) => "part '$e';'").join('\n')}'
        : '',
  });
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> _writeFile(
  String templateFilePath,
  String outputFilePath,
  Map<String, String> data,
) async {
  final template = (await readSnippetsFromMarkdownFile(templateFilePath)).join('\n');
  final output = replaceData(template, data);
  await writeFile(outputFilePath, output);
  await fmtDartFile(outputFilePath);
}
