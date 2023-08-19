// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

import 'dart:io';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:path/path.dart' as p;

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> analyzeAnnotatedClasses({
  required String filePath,
  required String annotationName,
  required Set<String> fieldNames,
  required void Function(String) onClass,
  required void Function(String, DartObject) onField,
  RegExp? classNamePattern,
}) async {
  final file = File(filePath).absolute;
  final normalizedFilePath = p.normalize(file.path);
  final collection = AnalysisContextCollection(
    includedPaths: [normalizedFilePath],
    resourceProvider: PhysicalResourceProvider.INSTANCE,
  );
  final context = collection.contextFor(normalizedFilePath);
  final fileUri = file.uri.toString();
  final result = await context.currentSession.getLibraryByUri(fileUri);
  final library = result as LibraryElementResult;
  final classElements = library.element.topLevelElements.whereType<ClassElement>();

  // Loop through the class elements in the file.
  for (final classElement in classElements) {
    final className = classElement.displayName;

    if (classNamePattern == null || classNamePattern.hasMatch(className)) {
      onClass(className);

      // Loop though the class element's metadata.
      for (final metadata in classElement.metadata) {
        final metadataElement = metadata.element;
        final metadataName = metadataElement?.displayName;
        if (metadataName == annotationName) {
          final object = metadata.computeConstantValue();
          for (final fieldName in fieldNames) {
            final field = object?.getField(fieldName);
            if (field != null) {
              onField(fieldName, field);
            }
          }
        }
      }
    }
  }
}
