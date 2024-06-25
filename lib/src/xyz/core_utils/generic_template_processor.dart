//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// 🇽🇾🇿 & Dev
//
// Licencing details are in the LICENSE file in the root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:meta/meta.dart';
import 'package:xyz_utils/xyz_utils.dart';

import '/src/xyz/core_utils/find_files_etc.dart';
import '/src/xyz/core_utils/placeholder_on_enum_extension.dart';
import '/src/xyz/core_utils/read_code_snippets_from_markdown_file.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// A mechanism to process code templates.
base class GenericTemplateProcessor<TPlaceholder extends Enum, TContext> {
  //
  //
  //

  /// The target paths to search for source files.
  final Set<String> targetDirPaths;

  /// Patterns for filtering paths of interest.
  final Set<String> pathPatterns;

  /// A mapper to map template placeholders to actual data.
  final Map<TPlaceholder, dynamic> Function(FileFoundResult result)? placeholdersToDataMapper;

  //
  //
  //

  GenericTemplateProcessor({
    required Set<String> rootDirPaths,
    Set<String> subDirPaths = const {},
    this.pathPatterns = const {},
    this.placeholdersToDataMapper,
  }) : targetDirPaths = _getTargetDirPaths(
          [rootDirPaths, subDirPaths],
          pathPatterns,
        );

  //
  //
  //

  /// Processes the provided templates from [templateFilePaths] and calls
  /// the appropriate callbacks:
  /// - [onTemplatesRead] is called once the templates at [templateFilePaths] are read.
  /// - [onTargetDirPathBegin] is called for each target dir path, right before the first [onSourceFile] gets called.
  /// - [onSourceFile] is called for each source file found in the target dir paths.
  /// - [onTargetDirPathBegin] is called for each target dir path, right after the last [onSourceFile] gets called.
  /// - [onDeleteGenFile] is called for each generated file deleted, and calls [clean] if specified.
  @nonVirtual
  Future<void> processTemplates({
    required Set<String> templateFilePaths,
    _TOnTemplatesReadCallback? onTemplatesRead,
    _TOnTargetDirPathCallback? onTargetDirPathBegin,
    _TOnSourceFileCallback<TContext>? onSourceFile,
    _TOnTargetDirPathCallback? onTargetDirPathEnd,
    _TOnGenFilePathCallback? onDeleteGenFile,
  }) async {
    // Create an arbitrary context.
    final context = await this.createContext();

    // Create a template map from the provided template file paths.
    final templates = await readCodeFromMarkdownFileSet(
      templateFilePaths,
    );

    onTemplatesRead?.call(templates);

    // Delete all previous generated files if required.
    if (onDeleteGenFile != null) {
      await this.clean(onDelete: onDeleteGenFile);
    }

    // Loop through target paths.
    for (final targetDirPath in this.targetDirPaths) {
      await onTargetDirPathBegin?.call(targetDirPath);

      // Invoke for each souce file within the target directory.
      if (onSourceFile != null) {
        // Find all files in the current path and its sub-paths.
        final children = await findFilesFromDir(
          targetDirPath,
          pathPatterns: pathPatterns,
        );

        for (final source in children) {
          final data = templates.map((k, v) {
            final v1 = v.replaceData(
              this.placeholdersToDataMapper?.call(source).map((k, v) {
                    return MapEntry(k.placeholder, v.toString());
                  }) ??
                  {},
            );
            return MapEntry(k, v1);
          });
          final result = TemplateProcessorResult<TContext>._(
            context: context,
            templates: templates,
            data: data,
            targetDirPath: targetDirPath,
            source: source,
          );
          await onSourceFile(result);
        }
      }
      await onTargetDirPathEnd?.call(targetDirPath);
    }
  }

  //
  //
  //

  /// Creates context for the generator.
  @mustBeOverridden
  Future<TContext?> createContext() async {
    return null;
  }

  //
  //
  //

  /// Deletes all generated files within [targetDirPaths]. Calls [onDelete]
  /// for each file deleted.
  @mustBeOverridden
  Future<void> clean({
    Future<bool> Function(String genFilePath)? onDelete,
  }) async {}
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Set<String> _getTargetDirPaths(
  List<Set<String>> pathSets,
  Set<String> pathPatterns,
) {
  return combinePathSets(pathSets).where((e) {
    return matchesAnyPathPattern(e, pathPatterns);
  }).toSet();
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

///
final class TemplateProcessorResult<T> {
  //
  //
  //

  final T? context;
  final Map<String, String> templates;
  final Map<String, String> data;
  final String targetDirPath;
  final FileFoundResult source;

  //
  //
  //

  const TemplateProcessorResult._({
    required this.context,
    required this.templates,
    required this.data,
    required this.targetDirPath,
    required this.source,
  });
}

typedef _TOnTemplatesReadCallback = Future<void> Function(
  Map<String, String> templates,
);

typedef _TOnTargetDirPathCallback = Future<void> Function(
  String targetDirPath,
);

typedef _TOnSourceFileCallback<TContext> = Future<void> Function(
  TemplateProcessorResult<TContext> result,
);

typedef _TOnGenFilePathCallback = Future<bool> Function(String genFilePath);
