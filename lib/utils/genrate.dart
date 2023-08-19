import 'find_files.dart';
import 'read_template.dart';
import 'helpers.dart';

Future<void> generate({
  required String rootDirPath,
  required Future<void> Function(String, String) generateForFile,
  required String templateFilePath,
  required String begType,
  Set<String> pathPatterns = const {},
  bool deleteGeneratedFiles = false,
}) async {
  if (deleteGeneratedFiles) {
    await deleteGeneratedDartFiles(rootDirPath, pathPatterns);
  }
  final template = await readTemplate(templateFilePath);
  await findFiles(
    rootDirPath: rootDirPath,
    pathPatterns: pathPatterns,
    onFileFound: (final dirName, final folderName, final filePath) async {
      final a = isMatchingFileName(filePath, begType, "dart").$1;
      final b = isSourceDartFilePath(filePath);
      if (a && b) {
        await generateForFile(filePath, template);
      }
    },
  );
}
