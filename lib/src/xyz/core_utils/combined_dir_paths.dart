//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// 🇽🇾🇿 & Dev
//
// Copyright Ⓒ Robert Mollentze, xyzand.dev
//
// Licensing details can be found in the LICENSE file in the root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:xyz_utils/xyz_utils.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// A mechanism to combine root and subdirectory paths to form combined
/// directory paths that adhere to specific path patterns.
class CombinedDirPaths {
  //
  //
  //

  /// The target paths to search for source files.
  final Set<String> combinedDirPaths;

  /// Patterns for filtering paths of interest.
  final Set<String> pathPatterns;

  //
  //
  //

  CombinedDirPaths({
    required Set<String> rootDirPaths,
    Set<String> subDirPaths = const {},
    this.pathPatterns = const {},
  }) : combinedDirPaths = _combine(
          [rootDirPaths, subDirPaths],
          pathPatterns,
        );

  //
  //
  //

  static Set<String> _combine(
    List<Set<String>> pathSets,
    Set<String> pathPatterns,
  ) {
    return combinePathSets(pathSets).where((e) {
      return matchesAnyPathPattern(e, pathPatterns);
    }).toSet();
  }
}
