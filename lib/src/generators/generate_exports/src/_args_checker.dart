//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// 🇽🇾🇿 & Dev
//
// Licencing details are in the LICENSE file in the root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import '/src/core_utils/valid_args_checker.dart';
import '/src/utils/split_arg.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class ArgsChecker extends ValidArgsChecker {
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

  ArgsChecker({
    this.fallbackDartSdkPath,
    required dynamic templateFilePaths,
    required dynamic rootPaths,
    required dynamic subPaths,
    required dynamic pathPatterns,
    this.output,
  })  : this.templateFilePaths = splitArg(templateFilePaths)?.toSet(),
        this.rootPaths = splitArg(rootPaths)?.toSet(),
        this.subPaths = splitArg(subPaths)?.toSet(),
        this.pathPatterns = splitArg(pathPatterns)?.toSet();

  //
  //
  //

  @override
  List get args => [
        if (this.fallbackDartSdkPath != null) this.fallbackDartSdkPath,
        this.templateFilePaths,
        this.rootPaths,
        if (this.subPaths != null) this.subPaths,
        if (this.pathPatterns != null) this.pathPatterns,
        if (this.output != null) this.output,
      ];
}
