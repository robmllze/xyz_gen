//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// 🇽🇾🇿 & Dev
//
// Licencing details are in the LICENSE file in the root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'dart:io';

import 'package:path/path.dart' as p;

import 'combined_paths.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// A mechanism to explore files and folders from specified [dirPathGroups].
class PathExplorer {
  //
  //
  //

  final Set<CombinedPaths> dirPathGroups;
  final Iterable<CategorizedPattern> pathPatterns;

  //
  //
  //

  const PathExplorer({
    this.pathPatterns = const [
      CategorizedPattern(
        pattern: r'.*',
        category: 'any',
      ),
    ],
    required this.dirPathGroups,
  });

  //
  //
  //

  _TExplorerResult explore({
    void Function(DirPathExplorerResult result)? onDirPath,
    void Function(FilePathExplorerResult result)? onFilePath,
  }) async {
    final dirPathResults = <DirPathExplorerResult>[];
    final filePathResults = <FilePathExplorerResult>[];

    Future<void> exploreDir(String dirPath) async {
      final contentPaths = await _listNormalizedDirContentPaths(dirPath);

      final filePaths = <String>[];
      final dirPaths = <String>[];

      for (final contentPath in contentPaths) {
        if (await _isDirectory(contentPath)) {
          dirPaths.add(contentPath);
        } else {
          filePaths.add(contentPath);
        }
      }

      final fileResults = filePaths.map(
        (e) {
          final result = FilePathExplorerResult._(
            category: CategorizedPattern.categorize(e, pathPatterns),
            path: e,
          );
          onFilePath?.call(result);
          return result;
        },
      );

      filePathResults.addAll(fileResults);

      final dirResults = dirPaths.map(
        (e) async {
          await exploreDir(e);
        },
      );

      await Future.wait(dirResults);

      final dirResult = DirPathExplorerResult._(
        category: CategorizedPattern.categorize(dirPath, pathPatterns),
        path: dirPath,
        files: fileResults,
      );
      dirPathResults.add(dirResult);
      onDirPath?.call(dirResult);
    }

    for (final dirPathGroup in this.dirPathGroups) {
      for (final dirPath in dirPathGroup.paths) {
        await exploreDir(dirPath);
      }
    }
    return (
      dirPathResults: dirPathResults,
      filePathResults: filePathResults,
    );
  }

  //
  //
  //

  Future<Map<String, String>> readAll({int? limit}) async {
    final explorerResults = await this.explore();
    final results = <String, String>{};
    var ee = explorerResults.filePathResults;
    if (limit != null) {
      ee.take(limit);
    }
    for (final e in ee) {
      try {
        final filePath = e.path;
        final file = File(filePath);
        final contents = await file.readAsString();
        if (contents.isNotEmpty) {
          results[filePath] = contents;
        }
      } catch (_) {}
    }
    return results;
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

typedef _TExplorerResult = Future<
    ({
      List<DirPathExplorerResult> dirPathResults,
      List<FilePathExplorerResult> filePathResults,
    })>;

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

final class CategorizedPattern {
  //
  //
  //

  final String pattern;
  final dynamic category;

  //
  //
  //

  const CategorizedPattern({
    required this.pattern,
    required this.category,
  });

  //
  //
  //

  RegExp get regExp => RegExp(this.pattern);

  //
  //
  //

  static dynamic categorize(String value, Iterable<CategorizedPattern> patterns) {
    for (final e in patterns) {
      final expression = RegExp(e.pattern);
      if (expression.hasMatch(value)) {
        return e.category;
      }
    }
    return null;
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

final class FilePathExplorerResult extends _PathExplorerResult {
  //
  //
  //

  const FilePathExplorerResult._({
    required super.category,
    required super.path,
  });
}

final class DirPathExplorerResult extends _PathExplorerResult {
  //
  //
  //

  final Iterable<FilePathExplorerResult> files;

  //
  //
  //

  const DirPathExplorerResult._({
    required super.category,
    required super.path,
    required this.files,
  });
}

abstract base class _PathExplorerResult {
  //
  //
  //

  final String path;
  final dynamic category;

  //
  //
  //

  const _PathExplorerResult({
    required this.path,
    required this.category,
  });
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Lists all contents of the given directory path.
Future<List<String>> _listNormalizedDirContentPaths(String dirPath) async {
  final dir = Directory(dirPath);
  if (!await dir.exists()) {
    return [];
  }
  return dir.list(recursive: false).map((e) => p.normalize(e.path)).toList();
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Checks if the given path is a directory.
Future<bool> _isDirectory(String path) async {
  final entity = FileSystemEntity.typeSync(path);
  return entity == FileSystemEntityType.directory;
}
