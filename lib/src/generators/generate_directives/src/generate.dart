//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
// 
// X|Y|Z Gen
//
// https://xyzand.dev/
//
// See LICENSE file in the root of this project for license details.
// 
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'dart:io';
import 'package:path/path.dart' as p;

import '/_common.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> generateDirectives({
  Set<String> rootDirPaths = const {},
  Set<String> subDirPaths = const {},
  Set<String> pathPatterns = const {},
}) async {
  printYellow("Starting generator. Please wait...");
  for (final dirPath in combinePathSets([rootDirPaths, subDirPaths])) {
    final results = await findFiles(
      dirPath,
      extensions: {".dart"},
      pathPatterns: pathPatterns,
      onFileFound: (_, __, filePath) async =>
          !isGeneratedDartFilePath(filePath),
    );
    for (final result in results) {
      final filePath = result.filePath;
      await handleCommentAnnotations(
        filePath: filePath,
        annotationHandlers: {
          "@GenerateDirectives": generateDirectivesHandler,
          "gd": generateDirectivesHandler,
        },
        annotationsToDelete: {
          "@GenerateDirectives",
          "gd",
        },
      );
    }
    printYellow("[DONE]");
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
    final directiveRegExp = RegExp("^(\\w+)\\s+['\"](.+)['\"];\$");
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
                case "part":
                  printGreen(
                    "Generating part file for `$relativePathToOriginal`...",
                  );
                  return "part of '$relativePathToOriginal';";
                case "import":
                  printGreen(
                    "Generating import file for `$relativePathToOriginal`...",
                  );
                  return "// Imported by $relativePathToOriginal";
                case "export":
                  printGreen(
                    "Generating export file for `$relativePathToOriginal`...",
                  );
                  return "// Exported by $relativePathToOriginal";
                default:
                  throw UnimplementedError(
                    "Unknown directive type: $directiveType",
                  );
              }
            }();
            await writeFile(directiveFilePath, directiveContent);
          }
        } else {
          return false;
        }
      } else {
        printLightGreen("Skipping `$originalFilePath`...");
      }
    }
  } catch (e) {
    printRed(e);
  }
  return true;
}