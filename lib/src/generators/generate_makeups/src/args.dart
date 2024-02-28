//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// X|Y|Z & Dev 
//
// Copyright Ⓒ Robert Mollentze, xyzand.dev
// 
// Licensing details can be found in the LICENSE file in the root directory.
// 
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import '/_common.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class GenerateMakeupsArgs extends ValidObject {
  //
  //
  //

  final String? fallbackDartSdkPath;
  final String? classTemplateFilePath;
  final String? builderTemplateFilePath;
  final String? generatedThemeTemplateFilePath;
  final String? generateTemplateFilePath;
  final Set<String>? rootPaths;
  final Set<String>? subPaths;
  final Set<String>? pathPatterns;
  final String? outputDirPath;

  //
  //
  //

  const GenerateMakeupsArgs({
    required this.fallbackDartSdkPath,
    required this.classTemplateFilePath,
    required this.builderTemplateFilePath,
    required this.generatedThemeTemplateFilePath,
    required this.generateTemplateFilePath,
    required this.rootPaths,
    required this.subPaths,
    required this.pathPatterns,
    required this.outputDirPath,
  });

  //
  //
  //

  @override
  bool get valid => ValidObject.areValid([
        if (this.fallbackDartSdkPath != null) this.fallbackDartSdkPath,
        this.classTemplateFilePath,
        this.builderTemplateFilePath,
        this.generatedThemeTemplateFilePath,
        this.rootPaths,
        if (this.subPaths != null) this.subPaths,
        if (this.pathPatterns != null) this.pathPatterns,
        this.outputDirPath,
      ]);
}