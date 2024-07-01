//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// 🇽🇾🇿 & Dev
//
// Licencing details are in the LICENSE file in the root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import '/_common.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class GenerateScreenArgs extends ValidArgsChecker {
  //
  //
  //

  final String? fallbackDartSdkPath;
  final String? outputDirPath;
  final String? screenName;
  final String? controllerTemplateFilePath;
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
  final String? makeup;
  final String? title;
  final Set<String>? partFileDirs;

  //
  //
  //

  const GenerateScreenArgs({
    required this.fallbackDartSdkPath,
    required this.outputDirPath,
    required this.screenName,
    required this.controllerTemplateFilePath,
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
    required this.makeup,
    required this.title,
    required this.partFileDirs,
  });

  //
  //
  //

  @override
  List<dynamic> get args => [
        if (fallbackDartSdkPath != null) fallbackDartSdkPath,
        outputDirPath,
        screenName,
        controllerTemplateFilePath,
        screenTemplateFilePath,
        stateTemplateFilePath,
        configurationTemplateFilePath,
        if (isAccessibleOnlyIfLoggedInAndVerified != null) isAccessibleOnlyIfLoggedInAndVerified,
        if (isAccessibleOnlyIfLoggedIn != null) isAccessibleOnlyIfLoggedIn,
        if (isAccessibleOnlyIfLoggedOut != null) isAccessibleOnlyIfLoggedOut,
        if (isRedirectable != null) isRedirectable,
        if (makeup != null) makeup,
        if (title != null) title,
        if (partFileDirs != null) partFileDirs,
      ];
}
