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

import 'core_utils_on_lang_extension.dart';

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
Future<List<FindFilesFromDirResult>> findSourceFiles(
  String rootDirPath, {
  required Lang lang,
  Set<String> pathPatterns = const {},
  _TOnFileFound? onFileFound,
}) async {
  return findFilesFromDir(
    rootDirPath,
    onFileFound: (dirPath, folderName, filePath) async {
      final a = await onFileFound?.call(dirPath, folderName, filePath) ?? true;
      final b = lang.isValidSrcFilePath(filePath);
      final c = matchesAnyPathPattern(filePath, pathPatterns);
      return a && b && c;
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
Future<List<FindFilesFromDirResult>> findGeneratedFiles(
  String rootDirPath, {
  required Lang lang,
  Set<String> pathPatterns = const {},
  _TOnFileFound? onFileFound,
}) async {
  return findFilesFromDir(
    rootDirPath,
    onFileFound: (dirPath, folderName, filePath) async {
      final a = await onFileFound?.call(dirPath, folderName, filePath) ?? true;
      final b = lang.isValidGenFilePath(filePath);
      final c = matchesAnyPathPattern(filePath, pathPatterns);
      return a && b && c;
    },
  );
}

/// Finds all files in [rootDirPath], including sub-directories if [recursive]
/// is `true`.
///
/// The [onFileFound] callback is invoked for each file, allowing for custom
/// filtering, i.e. if the it returns `true`, the file is added, if it returns
/// `false`, the file is not added.
Future<List<FindFilesFromDirResult>> findFilesFromDir(
  String rootDirPath, {
  _TOnFileFound? onFileFound,
  bool recursive = true,
}) async {
  final results = <FindFilesFromDirResult>[];
  final filePaths = await listFilePaths(
    rootDirPath,
    recursive: recursive,
  );
  if (filePaths != null) {
    filePaths.sort();
    for (final filePath in filePaths) {
      final dirPath = getDirPath(filePath);
      final folderName = getBaseName(dirPath);

      final shouldAdd = (await onFileFound?.call(dirPath, folderName, filePath)) ?? true;
      if (shouldAdd) {
        final result = FindFilesFromDirResult._(
          dirPath: dirPath,
          folderName: folderName,
          filePath: filePath,
        );
        results.add(result);
      }
    }
  }
  return results;
}

/// The `onFileFound` function structure for [findFilesFromDir],
/// [findSourceFiles] and [findGeneratedFiles].
typedef _TOnFileFound = Future<bool> Function(
  String dirPath,
  String folderName,
  String filePath,
);

/// Result returned by [findFilesFromDir].
final class FindFilesFromDirResult {
  //
  //
  //

  final String dirPath;
  final String folderName;
  final String filePath;

  //
  //
  //

  const FindFilesFromDirResult._({
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
