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

class GenerateScreenAccessArgs extends ValidArgsChecker {
  //
  //
  //

  final Set<String>? rootPaths;
  final Set<String>? subPaths;
  final Set<String>? pathPatterns;
  final Set<String>? screenClassNames;
  final String? templateFilePath;
  final String? outputFilePath;

  //
  //
  //

  const GenerateScreenAccessArgs({
    required this.rootPaths,
    required this.subPaths,
    required this.pathPatterns,
    required this.screenClassNames,
    required this.templateFilePath,
    required this.outputFilePath,
  });

  //
  //
  //

  @override
  List<dynamic> get args {
    final a = [
      if (this.rootPaths != null) this.rootPaths,
      if (this.subPaths != null) this.subPaths,
      if (this.screenClassNames != null) this.screenClassNames,
    ];
    return [
      a,
      ...a,
      if (this.pathPatterns != null) this.pathPatterns,
      this.templateFilePath,
      this.outputFilePath,
    ];
  }
}
