//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// 🇽🇾🇿 & Dev
//
// Licencing details are in the LICENSE file in the root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';

import '/src/xyz/_all_xyz.g.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// A mechanism to process Dart code templates.
final class DartTemplateProcessor<TPlaceholder extends Enum>
    extends GenericTemplateProcessor<TPlaceholder, AnalysisContextCollection> {
  //
  //
  //

  /// The fallback Dart SDK path to use when creating an Analysis Context
  /// Collection.
  final String? fallbackDartSdkPath;

  //
  //
  //

  DartTemplateProcessor({
    this.fallbackDartSdkPath,
    required super.rootDirPaths,
    super.subDirPaths,
    super.pathPatterns,
    super.placeholdersToDataMapper,
  });

  //
  //
  //

  @override
  Future<AnalysisContextCollection> createContext() async {
    return createDartAnalysisContextCollection(
      this.targetDirPaths,
      this.fallbackDartSdkPath,
    );
  }

  //
  //
  //

  @override
  Future<void> clean({
    Future<bool> Function(String genFilePath)? onDelete,
  }) async {
    for (final dirPath in this.targetDirPaths) {
      await Lang.DART.deleteAllGenFiles(
        dirPath,
        onDelete: onDelete,
        pathPatterns: pathPatterns,
      );
    }
  }
}
