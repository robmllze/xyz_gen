//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'dart:async';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/element/element.dart';

import 'package:path/path.dart' as p;

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Analyzes all enums in a Dart file.
Future<void> analyzeAnnotatedEnums({
  required String filePath,
  required AnalysisContextCollection collection,
  RegExp? enumNamePattern,
  Set<String>? enumAnnotations,
  FutureOr<void> Function(
    String enumAnnotationName,
    String enumName,
  )? onAnnotatedEnum,
}) async {
  final absoluteFilePath = p.absolute(filePath);
  final normalizedFilePath = p.normalize(absoluteFilePath);
  final fileUri = Uri.file(absoluteFilePath).toString();
  final context = collection.contextFor(normalizedFilePath);
  final library = await context.currentSession.getLibraryByUri(fileUri);
  if (library is LibraryElementResult) {
    final enumElements =
        library.element.topLevelElements.whereType<EnumElement>();
    for (final enumElement in enumElements) {
      final className = enumElement.displayName;
      if (enumNamePattern == null || enumNamePattern.hasMatch(className)) {
        await _processEnumAnnotations(
          enumElement,
          onAnnotatedEnum,
          enumAnnotations,
        );
      }
    }
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

FutureOr<void> _processEnumAnnotations(
  EnumElement enumElement,
  FutureOr<void> Function(String, String)? onAnnotatedEnum,
  Set<String>? enumAnnotations,
) async {
  for (final metadata in enumElement.metadata) {
    final element = metadata.element;
    final classAnnotationName = element?.displayName;
    if (classAnnotationName != null &&
        enumAnnotations?.contains(classAnnotationName) != false) {
      await onAnnotatedEnum?.call(
        classAnnotationName,
        enumElement.displayName,
      );
    }
  }
}
