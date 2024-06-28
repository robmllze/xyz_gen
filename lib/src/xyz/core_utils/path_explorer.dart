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
  final Iterable<CategorizedPattern> categorizedPathPatterns;

  //
  //
  //

  const PathExplorer({
    this.categorizedPathPatterns = const [
      CategorizedPattern(
        pattern: r'.*',
        category: '',
      ),
    ],
    required this.dirPathGroups,
  });

  //
  //
  //

  _TExplorerResult explore() async {
    final dirPathResults = <DirPathExplorerResult>[];
    final filePathResults = <FilePathExplorerResult>[];

    Future<void> exploreDir(String dirPath) async {
      final contentPaths = await _listNormalizedDirContentPaths(dirPath);

      final filePaths = <String>[];
      final dirPaths = <String>[];

      for (final contentPath in contentPaths) {
        if (await FileSystemEntity.isDirectory(contentPath)) {
          dirPaths.add(contentPath);
        }

        if (await FileSystemEntity.isFile(contentPath)) {
          filePaths.add(contentPath);
        }
      }

      for (final filePath in filePaths) {
        final temp = FilePathExplorerResult._(
          category: CategorizedPattern.categorize(filePath, categorizedPathPatterns),
          path: filePath,
        );

        filePathResults.add(temp);
      }

      for (final dirPath in dirPaths) {
        final temp = DirPathExplorerResult._(
          category: CategorizedPattern.categorize(dirPath, categorizedPathPatterns),
          path: dirPath,
          files: filePathResults,
        );

        dirPathResults.add(temp);
        await exploreDir(dirPath);
      }
    }

    for (final dirPathGroup in dirPathGroups) {
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

/// Filters [paths] by extracting only the topmost paths.
List<String> extractTopmostPaths(List<String> paths) {
  paths.sort((a, b) => a.length.compareTo(b.length));
  final topmostPaths = <String>[];
  for (final path in paths) {
    if (topmostPaths.every((topmostPath) => !path.startsWith('$topmostPath/'))) {
      topmostPaths.add(path);
    }
  }

  return topmostPaths;
}

/// Filters [results] by extracting only the topmost directory paths. Use
/// [toPath] to specify how to map [T] to the path String.
List<T> extractTopmostDirPathResults<T>(
  List<T> results, {
  required String Function(T) toPath,
}) {
  results.sort((a, b) => toPath(a).length.compareTo(toPath(b).length));
  final topmostResults = <T>[];

  for (final result in results) {
    if (topmostResults
        .every((topmostResult) => !toPath(result).startsWith('${toPath(topmostResult)}/'))) {
      topmostResults.add(result);
    }
  }

  return topmostResults;
}
