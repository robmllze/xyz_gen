//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// 🇽🇾🇿 & Dev
//
// Copyright Ⓒ Robert Mollentze, xyzand.dev
//
// Licensing details can be found in the LICENSE file in the root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:path/path.dart' as p;

import '/_common.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> generateDirectives({
  Set<String> rootDirPaths = const {},
  Set<String> subDirPaths = const {},
  Set<String> pathPatterns = const {},
}) async {
  Here().debugLogStart('Starting generator. Please wait...');
  // Loop through all possible directories.
  final combinedDirPaths = combinePathSets([rootDirPaths, subDirPaths]);
  for (final dirPath in combinedDirPaths) {
    final results = await findFiles(
      dirPath,
      extensions: {'.dart'},
      pathPatterns: pathPatterns,
      onFileFound: (_, __, filePath) async =>
          !isGeneratedDartFilePath(filePath),
    );
    for (final result in results) {
      final filePath = result.filePath;
      await handleCommentAnnotations(
        filePath: filePath,
        annotationHandlers: {
          '@GenerateDirectives': generateDirectivesHandler,
          'gd': generateDirectivesHandler,
        },
        annotationsToDelete: {
          '@GenerateDirectives',
          'gd',
        },
      );
    }
    Here().debugLogStop('Done!');
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Handles the case where the code is annotated with @GenerateDirectives.
Future<bool> generateDirectivesHandler(
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
          final directiveFilePath =
              Uri.file(originalDirPath).resolve(relativePath).toFilePath();
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
