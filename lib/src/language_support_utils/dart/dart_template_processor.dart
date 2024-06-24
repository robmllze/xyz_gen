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
import 'package:xyz_utils/xyz_utils.dart';

import '/src/core_utils/core_utils_on_lang_extension.dart';
import '/src/core_utils/find_files_etc.dart';
import '/src/core_utils/read_code_snippets_from_markdown_file.dart';
import '/src/language_support_utils/dart/dart_support.dart';
import '/src/language_support_utils/lang.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// A mechanism to process Dart code templates.
final class DartTemplateProcessor {
  //
  //
  //

  /// The fallback Dart SDK path to use when creating an Analysis Context
  /// Collection.
  final String? fallbackDartSdkPath;

  /// The target paths to search for Dart source files.
  final Set<String> targetPaths;

  /// Patterns for filtering paths of interest.
  final Set<String> pathPatterns;

  //
  //
  //

  DartTemplateProcessor({
    this.fallbackDartSdkPath,
    required Set<String> rootDirPaths,
    Set<String> subDirPaths = const {},
    this.pathPatterns = const {},
  }) : targetPaths = _getTargetPaths(
          [rootDirPaths, subDirPaths],
          pathPatterns,
        );

  //
  //
  //

  /// Processes the provided templates from [templateFilePaths] and calls
  /// [processFileCallback] for each source file found in the target paths.
  ///
  /// Set [onDeleteGenFile] to delete all previously generated files before
  /// processing. It gets called for each file deleted.
  ///
  /// Optionally specify the [output]. It is directly fed to
  /// [processFileCallback] and does not change the workings of this function.
  Future<void> processTemplates({
    required Set<String> templateFilePaths,
    required TProcessFileCallback processFileCallback,
    Future<bool> Function(String genFilePath)? onDeleteGenFile,
    final String? output,
  }) async {
    // Delete all previous generated files if doing a clean gen.
    if (onDeleteGenFile != null) {
      await this.clean(onDelete: onDeleteGenFile);
    }

    // Create an Analysis Context Collection for targetPaths.
    final analysisContextCollection = this.createAnalysisContextCollection();

    /// Create a template map from the provided template file paths.
    final templates = await readCombinedCodeSnippetsFromMarkdownFiles(
      templateFilePaths,
    );

    for (final targetPath in this.targetPaths) {
      // Final all Dart source files.
      final srcFiles = await findSourceFiles(
        targetPath,
        lang: Lang.DART,
        pathPatterns: pathPatterns,
      );

      // Call generateForFile for each source file.
      for (final scrFile in srcFiles) {
        await processFileCallback(
          analysisContextCollection,
          scrFile.filePath,
          templates,
          output,
        );
      }
    }
  }

  //
  //
  //

  /// Creates an Analysis Context Collection for [targetPaths] to enable the
  /// analysis of Dart files within these directories.
  AnalysisContextCollection createAnalysisContextCollection() {
    return createDartAnalysisContextCollection(
      this.targetPaths,
      this.fallbackDartSdkPath,
    );
  }

  //
  //
  //

  /// Deletes all generated Dart files within [targetPaths]. Calls [onDelete]
  /// for each file deleted.
  Future<void> clean({
    Future<bool> Function(String genFilePath)? onDelete,
  }) async {
    for (final dirPath in this.targetPaths) {
      await Lang.DART.deleteAllGenFiles(
        dirPath,
        onDelete: onDelete,
        pathPatterns: pathPatterns,
      );
    }
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Set<String> _getTargetPaths(
  List<Set<String>> pathSets,
  Set<String> pathPatterns,
) {
  return combinePathSets(pathSets).where((e) {
    return matchesAnyPathPattern(e, pathPatterns);
  }).toSet();
}

typedef TProcessFileCallback = Future<void> Function(
  AnalysisContextCollection analysisContextCollection,
  String filePath,
  Map<String, String> templates,
  String? output,
);
