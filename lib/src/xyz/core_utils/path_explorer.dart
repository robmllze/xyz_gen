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
import 'package:xyz_gen_annotations/xyz_gen_annotations.dart';

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
    final dirPathResults = <DirPathExplorerResult>{};
    final filePathResults = <FilePathExplorerResult>{};

    Future<DirPathExplorerResult> $exploreDir(String dirPath, DirPathExplorerResult? parent) async {
      // 1. Find all dirPaths and filePaths in dirPath.
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

      // 2. Create a local filePathResults for the current directory.
      final currentDirFilePathResults = <FilePathExplorerResult>{};
      for (final filePath in filePaths) {
        final x = FilePathExplorerResult._(
          category: CategorizedPattern.categorize(filePath, categorizedPathPatterns),
          path: filePath,
        );
        currentDirFilePathResults.add(x);
      }
      filePathResults.addAll(currentDirFilePathResults);

      // 3. Recursively explore subdirectories.
      final subDirResults = <DirPathExplorerResult>{};
      for (final subDirPath in dirPaths) {
        final subDirResult = await $exploreDir(subDirPath, parent);
        subDirResults.add(subDirResult);
      }

      // 4. Create the current directory result.
      final dirResult = DirPathExplorerResult._(
        category: CategorizedPattern.categorize(dirPath, categorizedPathPatterns),
        path: dirPath,
        files: currentDirFilePathResults,
        dirs: subDirResults,
        parentDir: parent,
      );

      dirPathResults.add(dirResult);
      return dirResult;
    }

    final rootDirPathResults = <DirPathExplorerResult>{};

    // 0. Explore each dirPath in all dirPathGroups.
    for (final dirPathGroup in dirPathGroups) {
      for (final dirPath in dirPathGroup.paths) {
        final dirResult = await $exploreDir(dirPath, null);
        rootDirPathResults.add(dirResult);
      }
    }

    return (
      rootDirPathResults: rootDirPathResults,
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
      Set<DirPathExplorerResult> rootDirPathResults,
      Set<DirPathExplorerResult> dirPathResults,
      Set<FilePathExplorerResult> filePathResults,
    })>;

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class FileReadResult extends Equatable {
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

  //
  //
  //

  @override
  List<Object?> get props => [this.path, this.content];
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
  final Iterable<DirPathExplorerResult> dirs;
  final DirPathExplorerResult? parentDir;

  //
  //
  //

  const DirPathExplorerResult._({
    required super.category,
    required super.path,
    required this.files,
    required this.dirs,
    required this.parentDir,
  });

  //
  //
  //

  Set<DirPathExplorerResult> getSubDirs() {
    final subDirs = <DirPathExplorerResult>{};
    void $traverse(DirPathExplorerResult dir) {
      subDirs.addAll(dir.dirs);
      for (final subDir in dir.dirs) {
        $traverse(subDir);
      }
    }

    $traverse(this);
    return subDirs;
  }

  //
  //
  //

  Set<FilePathExplorerResult> getSubFiles() {
    final subFiles = <FilePathExplorerResult>{};
    void $traverse(DirPathExplorerResult dir) {
      subFiles.addAll(dir.files);
      for (final subDir in dir.dirs) {
        $traverse(subDir);
      }
    }

    $traverse(this);
    return subFiles;
  }

  //
  //
  //

  @override
  List<Object?> get props =>
      [this.path, this.category, ...this.files, ...this.dirs, this.parentDir];
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

abstract base class PathExplorerResult extends Equatable {
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

  //
  //
  //

  @override
  List<Object?> get props => [this.path, this.category];
}
