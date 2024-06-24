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
import 'package:xyz_utils/xyz_utils_non_web.dart';

import '/src/core_utils/find_files_etc.dart';
import '/src/core_utils/process_comment_annots.dart';
import '/src/language_support_utils/lang.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> generateDartDirectives({
  Set<String> rootDirPaths = const {},
  Set<String> subDirPaths = const {},
  Set<String> pathPatterns = const {},
}) async {
  Here().debugLogStart('Starting generator. Please wait...');
  final combinedDirPaths = combinePathSets([rootDirPaths, subDirPaths]);
  for (final dirPath in combinedDirPaths) {
    final srcFiles = await findSourceFiles(
      dirPath,
      lang: Lang.DART,
      pathPatterns: pathPatterns,
    );
    final annotations = {
      '@GenerateDirectives',
      'gd',
    };
    for (final scrFile in srcFiles) {
      final filePath = scrFile.filePath;
      await processCommentAnnots(
        filePath: filePath,
        onAnnotCallbacks: annotations.map((e) => MapEntry(e, _onAnnot)).toMap(),
        annotsToDelete: annotations,
      );
    }
    Here().debugLogStop('Done!');
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Handles the case where the code is annotated with @GenerateDirectives.
Future<bool> _onAnnot(
  int startIndex,
  List<String> lines,
  String filePath,
) async {
  try {
    final originalFilePath = Uri.file(filePath);
    final originalDirPath = originalFilePath.resolve('.').toFilePath();
    final directiveRegExp = RegExp('^(\\w+)\\s+[\'"](.+)[\'"];\$');
    for (var n = startIndex + 1; n < lines.length; n++) {
      final line = lines[n].trim();
      final match = directiveRegExp.firstMatch(line);
      if (match != null) {
        final relativePath = match.group(2);
        if (relativePath != null) {
          final directiveFilePath = Uri.file(originalDirPath).resolve(relativePath).toFilePath();
          final fileDoesntExist = !await fileExists(directiveFilePath);
          if (fileDoesntExist) {
            final directiveContent = () {
              final directiveType = match.group(1);
              final directiveFileDir = File(directiveFilePath).parent.uri;
              final relativePathToOriginal = p.relative(
                originalFilePath.toFilePath(),
                from: directiveFileDir.toFilePath(),
              );
              switch (directiveType) {
                case 'part':
                  return "part of '$relativePathToOriginal';";
                case 'import':
                  return '// Imported by $relativePathToOriginal';
                case 'export':
                  return '// Exported by $relativePathToOriginal';
                default:
                  throw UnimplementedError(
                    'Unknown directive type: $directiveType',
                  );
              }
            }();
            await writeFile(directiveFilePath, directiveContent);
          }
        } else {
          return false;
        }
      }
    }
  } catch (e) {
    Here().debugLogError(e);
  }
  return true;
}
