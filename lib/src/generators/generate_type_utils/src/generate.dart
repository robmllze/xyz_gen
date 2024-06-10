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

import '/_common.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> generateTypeUtils({
  String? fallbackDartSdkPath,
  required Set<String> rootDirPaths,
  Set<String> subDirPaths = const {},
  Set<String> pathPatterns = const {},
  required String templateFilePath,
}) async {
  Here().debugLogStart('Starting generator. Please wait...');
  await generateFromTemplates(
    fallbackDartSdkPath: fallbackDartSdkPath,
    rootDirPaths: rootDirPaths,
    subDirPaths: subDirPaths,
    pathPatterns: pathPatterns,
    templateFilePaths: {templateFilePath},
    generateForFile: _generateForFile,
  );
  Here().debugLogStop('Done!');
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> _generateForFile(
  AnalysisContextCollection collection,
  String fixedFilePath,
  Map<String, String> templates,
  String? _,
) async {
  await analyzeAnnotatedEnums(
    filePath: fixedFilePath,
    collection: collection,
    enumAnnotations: {'GenerateTypeUtils'},
    onAnnotatedEnum: (enumAnnotationName, enumName) async {
      // Get the enum file name from the file path.
      final enumFileName = getBaseName(fixedFilePath);

      // Replace placeholders with the actual values.
      final template = templates.values.first;
      final output = replaceData(
        template,
        {
          '___ENUM_FILE_NAME___': enumFileName,
          '___ENUM___': enumName,
        },
      );

      // Get the output file path.
      final outputFilePath = () {
        final classFileDirPath = getDirPath(fixedFilePath);
        final classKey = getFileNameWithoutExtension(enumFileName);
        final outputFileName = '_$classKey.g.dart';
        return p.join(classFileDirPath, outputFileName);
      }();

      // Write the generated Dart file.
      await writeFile(outputFilePath, output);

      // Format the generated Dart file.
      await fmtDartFile(outputFilePath);
    },
  );
}
