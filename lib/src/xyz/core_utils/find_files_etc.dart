//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// 🇽🇾🇿 & Dev
//
// Licencing details are in the LICENSE file in the root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:path/path.dart' as p;
import 'package:xyz_utils/xyz_utils_non_web.dart';

import 'core_utils_on_lang_x.dart';

import '../language_support_utils/lang.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Finds all source files in [rootDirPath] that for the given [lang].
///
/// If [pathPatterns] is specified, only file paths that match all
/// [pathPatterns] are added to the results.
///
/// The [onFileFound] callback is invoked for each file, allowing for custom
/// filtering, i.e. if the it returns `true`, the file is added, if it returns
/// `false`, the file is not added.
Future<List<FileFoundResult>> findSourceFiles(
  String rootDirPath, {
  required Lang lang,
  Set<String> pathPatterns = const {},
  _TOnFileFound? onFileFound,
}) async {
  return findFilesFromDir(
    rootDirPath,
    pathPatterns: pathPatterns,
    onFileFound: (result) async {
      final a = await onFileFound?.call(result) ?? true;
      final b = lang.isValidSrcFilePath(result.filePath);
      return a && b;
    },
  );
}

/// Finds all generated files in [rootDirPath] that for the given [lang].
///
/// If [pathPatterns] is specified, only file paths that match all
/// [pathPatterns] are added to the results.
///
/// The [onFileFound] callback is invoked for each file, allowing for custom
/// filtering, i.e. if the it returns `true`, the file is added, if it returns
/// `false`, the file is not added.
Future<List<FileFoundResult>> findGeneratedFiles(
  String rootDirPath, {
  required Lang lang,
  Set<String> pathPatterns = const {},
  _TOnFileFound? onFileFound,
}) async {
  return findFilesFromDir(
    rootDirPath,
    pathPatterns: pathPatterns,
    onFileFound: (result) async {
      final a = await onFileFound?.call(result) ?? true;
      final b = lang.isValidGenFilePath(result.filePath);
      return a && b;
    },
  );
}

/// Finds all files in [rootDirPath], including sub-directories if [recursive]
/// is `true`.
///
/// The [onFileFound] callback is invoked for each file, allowing for custom
/// filtering, i.e. if the it returns `true`, the file is added, if it returns
/// `false`, the file is not added.
Future<List<FileFoundResult>> findFilesFromDir(
  String rootDirPath, {
  Set<String> pathPatterns = const {},
  _TOnFileFound? onFileFound,
  bool recursive = true,
}) async {
  final results = <FileFoundResult>[];
  final filePaths = await listFilePaths(
    rootDirPath,
    recursive: recursive,
  );
  if (filePaths != null) {
    filePaths.sort();
    for (final filePath in filePaths) {
      final a = matchesAnyPathPattern(filePath, pathPatterns);
      if (!a) continue;
      final dirPath = getDirPath(filePath);
      final folderName = getBaseName(dirPath);
      final result = FileFoundResult._(
        dirPath: dirPath,
        folderName: folderName,
        filePath: filePath,
      );
      final b = (await onFileFound?.call(result)) ?? true;
      if (!b) continue;
      results.add(result);
    }
  }
  return results;
}

/// The `onFileFound` function structure for [findFilesFromDir],
/// [findSourceFiles] and [findGeneratedFiles].
typedef _TOnFileFound = Future<bool> Function(FileFoundResult result);

/// Represents a file discovery result with details about its path, folder, and
/// directory.
final class FileFoundResult {
  //
  //
  //

  final String dirPath;
  final String folderName;
  final String filePath;

  //
  //
  //

  const FileFoundResult._({
    required this.dirPath,
    required this.folderName,
    required this.filePath,
  });

  //
  //
  //

  /// The extension of [filePath].
  String get extension => p.extension(filePath);

  /// The extension of [filePath], in lower case.
  String get lowerCaseExt => extension.toLowerCase();
}
