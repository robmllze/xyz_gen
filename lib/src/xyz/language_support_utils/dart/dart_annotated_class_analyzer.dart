//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// 🇽🇾🇿 & Dev
//
// Licencing details are in the LICENSE file in the root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'dart:async';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';

import 'package:path/path.dart' as p;

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Provides a mechanism to analyze Dart classes from a file path.
final class DartAnnotatedClassAnalyzer {
  //
  //
  //

  final String filePath;
  final AnalysisContextCollection analysisContextCollection;

  //
  //
  //

  const DartAnnotatedClassAnalyzer({
    required this.filePath,
    required this.analysisContextCollection,
  });

  //
  //
  //

  /// Analyzes the Dart file at [filePath] via [analysisContextCollection].
  ///
  /// This method triggers callbacks when encountering annotated classes, methods, or members.
  /// - [classNameFilter] Includes classes whose names match this regular expression, if specified.
  /// - [methodNameFilter] Includes methods whose names match this regular expression, if specified.
  /// - [memberNameFilter] Includes members whose names match this regular expression, if specified.
  /// - [inclClassAnnotations] Targets classes with these annotations for analysis.
  /// - [inclMethodAnnotations] Targets methods with these annotations for analysis.
  /// - [inclMemberAnnotations] Targets members with these annotations for analysis.
  /// - [onAnnotatedClass] Invoked for each class matching [inclClassAnnotations].
  /// - [onClassAnnotationField] Invoked for each field in an annotated class.
  /// - [onAnnotatedMethod] Invoked for each method matching [inclMethodAnnotations].
  /// - [onMethodAnnotationField] Invoked for fields in an annotated method.
  /// - [onAnnotatedMember] Invoked for each member matching [inclMemberAnnotations].
  /// - [onMemberAnnotationField] Invoked for fields in an annotated member.  d
  Future<void> analyze({
    RegExp? classNameFilter,
    RegExp? methodNameFilter,
    RegExp? memberNameFilter,
    Set<String>? inclClassAnnotations,
    Set<String>? inclMethodAnnotations,
    Set<String>? inclMemberAnnotations,
    _TOnAnnotatedClassCallback? onAnnotatedClass,
    _TOnClassAnnotationFieldCallback? onClassAnnotationField,
    _TOnAnnotatedMethodCallback? onAnnotatedMethod,
    _TOnMethodAnnotationFieldCallback? onMethodAnnotationField,
    _TOnAnnotatedMemberCallback? onAnnotatedMember,
    _TOnMemberAnnotationFieldCallback? onMemberAnnotationField,
    _TOnAnalysis? onPreAnalysis,
    _TOnAnalysis? onPostAnalysis,
  }) async {
    final fullFilePath = p.normalize(p.absolute(filePath));
    final fullFileUri = Uri.file(fullFilePath);
    final context = this.analysisContextCollection.contextFor(fullFilePath);
    final library = await context.currentSession.getLibraryByUri(fullFileUri.toString());
    if (library is LibraryElementResult) {
      final classElements = library.element.topLevelElements.whereType<ClassElement>();
      for (final classElement in classElements) {
        final className = classElement.displayName;
        if (classNameFilter == null || classNameFilter.hasMatch(className)) {
          onPreAnalysis?.call(
            fullFilePath,
            className,
          );
          await _processMemberAnnotations(
            fullFilePath,
            classElement,
            memberNameFilter,
            onAnnotatedMember,
            onMemberAnnotationField,
            inclMemberAnnotations,
          );
          await _processMethodAnnotations(
            fullFilePath,
            classElement,
            methodNameFilter,
            onAnnotatedMethod,
            onMethodAnnotationField,
            inclMethodAnnotations,
          );
          await _processClassAnnotations(
            fullFilePath,
            classElement,
            onAnnotatedClass,
            onClassAnnotationField,
            inclClassAnnotations,
          );
        }
        onPostAnalysis?.call(
          fullFilePath,
          className,
        );
      }
    }
  }

  //
  //
  //

  FutureOr<void> _processMemberAnnotations(
    String fullFilePath,
    ClassElement classElement,
    RegExp? memberNameFilter,
    _TOnAnnotatedMemberCallback? onAnnotatedMember,
    _TOnMemberAnnotationFieldCallback? onMemberAnnotationField,
    Set<String>? inclMemberAnnotations,
  ) async {
    for (final fieldElement in classElement.fields) {
      if (memberNameFilter == null || memberNameFilter.hasMatch(fieldElement.displayName)) {
        for (final fieldMetadata in fieldElement.metadata) {
          final memberAnnotationName = fieldMetadata.element?.displayName;
          if (memberAnnotationName != null &&
              inclMemberAnnotations?.contains(memberAnnotationName) != false) {
            await onAnnotatedMember?.call(
              (
                fullFilePath: fullFilePath,
                memberAnnotationName: memberAnnotationName,
                memberName: fieldElement.displayName,
                memberType: fieldElement.type.getDisplayString(withNullability: true),
              ),
            );

            if (onMemberAnnotationField != null) {
              final element = fieldMetadata.element;
              final fieldNames = element?.children.map((e) => e.displayName);
              if (fieldNames != null) {
                for (final fieldName in fieldNames) {
                  final fieldValue = fieldMetadata.computeConstantValue()?.getField(fieldName);
                  if (fieldValue != null) {
                    await onMemberAnnotationField(
                      (
                        fullFilePath: fullFilePath,
                        fieldName: fieldName,
                        fieldValue: fieldValue,
                      ),
                    );
                  }
                }
              }
            }
          }
        }
      }
    }
  }

//
//
//

  FutureOr<void> _processMethodAnnotations(
    String fullFilePath,
    ClassElement classElement,
    RegExp? methodNameFilter,
    _TOnAnnotatedMethodCallback? onAnnotatedMethod,
    _TOnMethodAnnotationFieldCallback? onMethodAnnotationField,
    Set<String>? inclMethodAnnotations,
  ) async {
    for (final method in classElement.methods) {
      if (methodNameFilter == null || methodNameFilter.hasMatch(method.displayName)) {
        for (final methodMetadata in method.metadata) {
          final methodAnnotationName = methodMetadata.element?.displayName;
          if (methodAnnotationName != null &&
              inclMethodAnnotations?.contains(methodAnnotationName) != false) {
            await onAnnotatedMethod?.call(
              (
                fullFilePath: fullFilePath,
                methodAnnotationName: methodAnnotationName,
                methodName: method.displayName,
                methodType: method.type.getDisplayString(withNullability: false),
              ),
            );

            if (onMethodAnnotationField != null) {
              final element = methodMetadata.element;
              final fieldNames = element?.children.map((e) => e.displayName);
              if (fieldNames != null) {
                for (final fieldName in fieldNames) {
                  final fieldValue = methodMetadata.computeConstantValue()?.getField(fieldName);
                  if (fieldValue != null) {
                    await onMethodAnnotationField(
                      (
                        fullFilePath: fullFilePath,
                        fieldName: fieldName,
                        fieldValue: fieldValue,
                      ),
                    );
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  //
  //
  //

  FutureOr<void> _processClassAnnotations(
    String fullFilePath,
    ClassElement classElement,
    _TOnAnnotatedClassCallback? onAnnotatedClass,
    _TOnClassAnnotationFieldCallback? onClassAnnotationField,
    Set<String>? inclClassAnnotations,
  ) async {
    for (final metadata in classElement.metadata) {
      final element = metadata.element;
      final classAnnotationName = element?.displayName;
      if (classAnnotationName != null &&
          inclClassAnnotations?.contains(classAnnotationName) != false) {
        if (onClassAnnotationField != null) {
          final fieldNames = element?.children.map((e) => e.displayName);
          if (fieldNames != null) {
            for (final fieldName in fieldNames) {
              final fieldValue = metadata.computeConstantValue()?.getField(fieldName);
              if (fieldValue != null) {
                await onClassAnnotationField(
                  (
                    fullFilePath: fullFilePath,
                    fieldName: fieldName,
                    fieldValue: fieldValue,
                  ),
                );
              }
            }
          }
        }
        await onAnnotatedClass?.call(
          (
            fullFilePath: fullFilePath,
            classAnnotationName: classAnnotationName,
            className: classElement.displayName,
          ),
        );
      }
    }
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

typedef _TOnAnnotatedClassCallback = FutureOr<void> Function(
  TOnAnnotatedClassParams params,
);

typedef TOnAnnotatedClassParams = ({
  String fullFilePath,
  String classAnnotationName,
  String className,
});

typedef _TOnAnnotatedMethodCallback = FutureOr<void> Function(
  TOnAnnotatedMethodParams params,
);

typedef TOnAnnotatedMethodParams = ({
  String fullFilePath,
  String methodAnnotationName,
  String methodName,
  String methodType,
});

typedef _TOnClassAnnotationFieldCallback = FutureOr<void> Function(
  TOnClassAnnotationFieldParams params,
);

typedef TOnClassAnnotationFieldParams = ({
  String fullFilePath,
  String fieldName,
  DartObject fieldValue,
});

typedef _TOnMethodAnnotationFieldCallback = FutureOr<void> Function(
  TOnMethodAnnotationFieldParams params,
);

typedef TOnMethodAnnotationFieldParams = ({
  String fullFilePath,
  String fieldName,
  DartObject fieldValue,
});

typedef _TOnAnnotatedMemberCallback = FutureOr<void> Function(
  TOnAnnotatedMemberParams params,
);

typedef TOnAnnotatedMemberParams = ({
  String fullFilePath,
  String memberAnnotationName,
  String memberName,
  String memberType,
});

typedef _TOnMemberAnnotationFieldCallback = FutureOr<void> Function(
  TOnMemberAnnotationFieldParams params,
);

typedef TOnMemberAnnotationFieldParams = ({
  String fullFilePath,
  String fieldName,
  DartObject fieldValue,
});

typedef _TOnAnalysis = void Function(String fullFilePath, String className);
