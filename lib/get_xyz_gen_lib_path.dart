//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:xyz_utils/io.dart' show getPackageLibPath;

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Returns the full path of the `xyz_gen\lib` directory.
Future<String> getXyzGenLibPath() async {
  return (await getPackageLibPath("xyz_gen"))!;
}

/// Returns the path of the default template file with the given [templateName].
Future<String> getXyzGenDefaultTemplateFilePath(String templateName) async {
  final libPath = await getXyzGenLibPath();
  final templatePath = p.join(libPath, "templates", templateName);
  print(templatePath);
  return templatePath;
}

/// Returns the content of the default template file with the given [templateName].
Future<String> getXyzGenDefaultTemplate(String templateName) async {
  final templatePath = await getXyzGenDefaultTemplateFilePath(templateName);
  final file = File(templatePath);
  final content = await file.readAsString();
  return content;
}
