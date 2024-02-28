//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
// 
// X|Y|Z Gen
//
// https://xyzand.dev/
//
// See LICENSE file in the root of this project for license details.
// 
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import '/_common.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class GenerateScreenArgs extends ValidObject {
  //
  //
  //

  final String? fallbackDartSdkPath;
  final String? outputDirPath;
  final String? screenName;
  final String? logicTemplateFilePath;
  final String? screenTemplateFilePath;
  final String? stateTemplateFilePath;
  final String? configurationTemplateFilePath;
  final String? path;
  final bool? isAccessibleOnlyIfLoggedIn;
  final bool? isAccessibleOnlyIfLoggedInAndVerified;
  final bool? isAccessibleOnlyIfLoggedOut;
  final bool? isRedirectable;
  final Map<String, String>? internalParameters;
  final Set<String>? queryParameters;
  final List<String>? pathSegments;
  final String? makeup;
  final String? title;
  final String? navigationControlWidget;
  final Set<String>? partFileDirs;

  //
  //
  //

  const GenerateScreenArgs({
    required this.fallbackDartSdkPath,
    required this.outputDirPath,
    required this.screenName,
    required this.logicTemplateFilePath,
    required this.screenTemplateFilePath,
    required this.stateTemplateFilePath,
    required this.configurationTemplateFilePath,
    required this.path,
    required this.isAccessibleOnlyIfLoggedIn,
    required this.isAccessibleOnlyIfLoggedInAndVerified,
    required this.isAccessibleOnlyIfLoggedOut,
    required this.isRedirectable,
    required this.internalParameters,
    required this.queryParameters,
    required this.pathSegments,
    required this.makeup,
    required this.title,
    required this.navigationControlWidget,
    required this.partFileDirs,
  });

  //
  //
  //

  @override
  bool get valid => ValidObject.areValid([
        if (fallbackDartSdkPath != null) fallbackDartSdkPath,
        outputDirPath,
        screenName,
        logicTemplateFilePath,
        screenTemplateFilePath,
        stateTemplateFilePath,
        configurationTemplateFilePath,
        if (isAccessibleOnlyIfLoggedInAndVerified != null)
          isAccessibleOnlyIfLoggedInAndVerified,
        if (isAccessibleOnlyIfLoggedIn != null) isAccessibleOnlyIfLoggedIn,
        if (isAccessibleOnlyIfLoggedOut != null) isAccessibleOnlyIfLoggedOut,
        if (isRedirectable != null) isRedirectable,
        if (makeup != null) makeup,
        if (title != null) title,
        if (navigationControlWidget != null) navigationControlWidget,
        if (partFileDirs != null) partFileDirs,
      ]);
}