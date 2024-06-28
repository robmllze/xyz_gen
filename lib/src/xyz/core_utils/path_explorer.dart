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

import 'categorize_pattern.dart';
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
      ),
    ],
    required this.dirPathGroups,
  });

  //
  //
  //

  /// Explores [dirPathGroups] while adhering to [categorizedPathPatterns].
  ///
  /// Returns the subfiles and subfolders found.
  _TExploreResult explore() async {
    final dirPathResults = <DirPathExplorerResult>[];
    final filePathResults = <FilePathExplorerResult>[];

    Future<void> $exploreDir(String dirPath) async {
      // 1. Find all dirPaths and dirPaths in dirPath
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

      // 2. For each filePath, add the exploration result x to filePathResults.
      for (final filePath in filePaths) {
        final x = FilePathExplorerResult._(
          category: CategorizedPattern.categorize(filePath, categorizedPathPatterns),
          path: filePath,
        );
        filePathResults.add(x);
      }

      // 3. For each dirPath, add the exploration result x to dirPathResults,
      // then also explore this dirPath via exploreDir.
      for (final dirPath in dirPaths) {
        final x = DirPathExplorerResult._(
          category: CategorizedPattern.categorize(dirPath, categorizedPathPatterns),
          path: dirPath,
          files: filePathResults,
        );

        dirPathResults.add(x);
        await $exploreDir(dirPath);
      }
    }

    // 0. Explore each dirPath in all dirPathGroups.
    for (final dirPathGroup in dirPathGroups) {
      for (final dirPath in dirPathGroup.paths) {
        await $exploreDir(dirPath);
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

  /// Calls [explore] then reads every file found up to [limit] files if specified.
  Future<List<FileReadResult>> readAll({int? limit}) async {
    final explorerResults = await this.explore();
    final results = <FileReadResult>[];
    var filePathResults = explorerResults.filePathResults;
    if (limit != null) {
      filePathResults.take(limit);
    }
    for (final filePathResult in filePathResults) {
      try {
        final path = filePathResult.path;
        final file = File(path);
        final contents = await file.readAsString();
        if (contents.isNotEmpty) {
          results.add(
            FileReadResult._(path: path, content: contents),
          );
        }
      } catch (_) {}
    }
    return List.unmodifiable(results);
  }

  //
  //
  //

  /// Lists all contents of the given [dirPath].
  static Future<List<String>> _listNormalizedDirContentPaths(String dirPath) async {
    final dir = Directory(dirPath);
    if (!await dir.exists()) {
      return [];
    }
    return dir.list(recursive: false).map((e) => p.normalize(e.path)).toList();
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

typedef _TExploreResult = Future<
    ({
      List<DirPathExplorerResult> dirPathResults,
      List<FilePathExplorerResult> filePathResults,
    })>;

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class FileReadResult {
  //
  //
  //

  final String path;
  final String content;

  //
  //
  //

  const FileReadResult._({
    required this.path,
    required this.content,
  });

  //
  //
  //

  String get baseName => p.basename(this.path);

  //
  //
  //

  String get rootName => this.baseName.replaceFirst(RegExp(r'\..*'), '');
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

final class FilePathExplorerResult extends PathExplorerResult {
  //
  //
  //

  const FilePathExplorerResult._({
    required super.category,
    required super.path,
  });
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

final class DirPathExplorerResult extends PathExplorerResult {
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

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

abstract base class PathExplorerResult {
  //
  //
  //

  final String path;
  final dynamic category;

  //
  //
  //

  const PathExplorerResult({
    required this.path,
    required this.category,
  });
}
