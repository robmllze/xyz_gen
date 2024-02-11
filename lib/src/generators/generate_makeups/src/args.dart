//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
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
  final String? exportsTemplateFilePath;
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
    required this.exportsTemplateFilePath,
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
        this.exportsTemplateFilePath,
        this.generatedThemeTemplateFilePath,
        this.rootPaths,
        if (this.subPaths != null) this.subPaths,
        if (this.pathPatterns != null) this.pathPatterns,
        this.outputDirPath,
      ]);
}
