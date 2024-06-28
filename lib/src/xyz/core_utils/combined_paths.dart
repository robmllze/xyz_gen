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

import 'package:xyz_gen_annotations/xyz_gen_annotations.dart';
// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// A mechanism to combine root and subdirectory paths to form combined
/// directory paths that adhere to specific path patterns.
class CombinedPaths extends Equatable {
  //
  //
  //

  final Set<String> paths;

  //
  //
  //

  /// Patterns for filtering paths of interest.
  final Set<String> pathPatterns;

  //
  //
  //

  CombinedPaths(
    Set<String> rootPaths, {
    Set<String> subPaths = const {},
    this.pathPatterns = const {},
  }) : paths = _combine([rootPaths, subPaths], pathPatterns);

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

  //
  //
  //

  @override
  List<Object?> get props => this.paths.toList();
}
