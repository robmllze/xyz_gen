//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// 🇽🇾🇿 & Dev
//
// Licencing details are in the LICENSE file in the root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import '../core_utils/valid_args_checker.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class BasicCmdAppArgs extends ValidArgsChecker {
  //
  //
  //

  final String? fallbackDartSdkPath;
  final Set<String>? templateFilePaths;
  final Set<String>? rootPaths;
  final Set<String>? subPaths;
  final Set<String>? pathPatterns;
  final String? output;

  //
  //
  //

  const BasicCmdAppArgs({
    this.fallbackDartSdkPath,
    required this.templateFilePaths,
    required this.rootPaths,
    required this.subPaths,
    required this.pathPatterns,
    this.output,
  });

  //
  //
  //

  @override
  bool get isValid => ValidArgsChecker.isNotNullAndNotEmptyCheck([
        if (this.fallbackDartSdkPath != null) this.fallbackDartSdkPath,
        this.templateFilePaths,
        this.rootPaths,
        if (this.subPaths != null) this.subPaths,
        if (this.pathPatterns != null) this.pathPatterns,
        if (this.output != null) this.output,
      ]);
}
