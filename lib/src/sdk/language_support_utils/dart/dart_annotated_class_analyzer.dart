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

  Future<void> analyze({
    RegExp? classNamePattern,
    RegExp? methodNamePattern,
    RegExp? memberNamePattern,
    Set<String>? classAnnotations,
    Set<String>? methodAnnotations,
    Set<String>? memberAnnotations,
    _TOnAnnotatedClassCallback? onAnnotatedClass,
    _TOnClassAnnotationFieldCallback? onClassAnnotationField,
    _TOnAnnotatedMethodCallback? onAnnotatedMethod,
    _TOnMethodAnnotationFieldCallback? onMethodAnnotationField,
    _TOnAnnotatedMemberCallback? onAnnotatedMember,
    _TOnMemberAnnotationField? onMemberAnnotationField,
  }) async {
    final absoluteFilePath = p.absolute(filePath);
    final normalizedFilePath = p.normalize(absoluteFilePath);
    final fileUri = Uri.file(absoluteFilePath).toString();
    final context = this.analysisContextCollection.contextFor(normalizedFilePath);
    final library = await context.currentSession.getLibraryByUri(fileUri);
    if (library is LibraryElementResult) {
      final classElements = library.element.topLevelElements.whereType<ClassElement>();
      for (final classElement in classElements) {
        final className = classElement.displayName;
        if (classNamePattern == null || classNamePattern.hasMatch(className)) {
          await _processMemberAnnotations(
            classElement,
            memberNamePattern,
            onAnnotatedMember,
            onMemberAnnotationField,
            memberAnnotations,
          );
          await _processMethodAnnotations(
            classElement,
            methodNamePattern,
            onAnnotatedMethod,
            onMethodAnnotationField,
            methodAnnotations,
          );
          await _processClassAnnotations(
            classElement,
            onAnnotatedClass,
            onClassAnnotationField,
            classAnnotations,
          );
        }
      }
    }
  }

  //
  //
  //

  FutureOr<void> _processClassAnnotations(
    ClassElement classElement,
    _TOnAnnotatedClassCallback? onAnnotatedClass,
    _TOnClassAnnotationFieldCallback? onClassAnnotationField,
    Set<String>? classAnnotations,
  ) async {
    for (final metadata in classElement.metadata) {
      final element = metadata.element;
      final classAnnotationName = element?.displayName;
      if (classAnnotationName != null && classAnnotations?.contains(classAnnotationName) != false) {
        if (onClassAnnotationField != null) {
          final fieldNames = element?.children.map((e) => e.displayName);
          if (fieldNames != null) {
            for (final fieldName in fieldNames) {
              final field = metadata.computeConstantValue()?.getField(fieldName);
              if (field != null) {
                await onClassAnnotationField(fieldName, field);
              }
            }
          }
        }
        await onAnnotatedClass?.call(
          classAnnotationName,
          classElement.displayName,
        );
      }
    }
  }

  //
  //
  //

  FutureOr<void> _processMethodAnnotations(
    ClassElement classElement,
    RegExp? methodNamePattern,
    _TOnAnnotatedMethodCallback? onAnnotatedMethod,
    _TOnMethodAnnotationFieldCallback? onMethodAnnotationField,
    Set<String>? methodAnnotations,
  ) async {
    for (final method in classElement.methods) {
      if (methodNamePattern == null || methodNamePattern.hasMatch(method.displayName)) {
        for (final methodMetadata in method.metadata) {
          final methodAnnotationName = methodMetadata.element?.displayName;
          if (methodAnnotationName != null &&
              methodAnnotations?.contains(methodAnnotationName) != false) {
            await onAnnotatedMethod?.call(
              methodAnnotationName,
              method.displayName,
              method.type.getDisplayString(withNullability: false),
            );

            if (onMethodAnnotationField != null) {
              final element = methodMetadata.element;
              final fieldNames = element?.children.map((e) => e.displayName);
              if (fieldNames != null) {
                for (final fieldName in fieldNames) {
                  final field = methodMetadata.computeConstantValue()?.getField(fieldName);
                  if (field != null) {
                    await onMethodAnnotationField(fieldName, field);
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

  FutureOr<void> _processMemberAnnotations(
    ClassElement classElement,
    RegExp? memberNamePattern,
    _TOnAnnotatedMemberCallback? onAnnotatedMember,
    _TOnMemberAnnotationField? onMemberAnnotationField,
    Set<String>? memberAnnotations,
  ) async {
    for (final fieldElement in classElement.fields) {
      if (memberNamePattern == null || memberNamePattern.hasMatch(fieldElement.displayName)) {
        for (final fieldMetadata in fieldElement.metadata) {
          final memberAnnotationName = fieldMetadata.element?.displayName;
          if (memberAnnotationName != null &&
              memberAnnotations?.contains(memberAnnotationName) != false) {
            await onAnnotatedMember?.call(
              memberAnnotationName,
              fieldElement.displayName,
              fieldElement.type.getDisplayString(withNullability: true),
            );

            if (onMemberAnnotationField != null) {
              final element = fieldMetadata.element;
              final fieldNames = element?.children.map((e) => e.displayName);
              if (fieldNames != null) {
                for (final fieldName in fieldNames) {
                  final field = fieldMetadata.computeConstantValue()?.getField(fieldName);
                  if (field != null) {
                    await onMemberAnnotationField(fieldName, field);
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

typedef _TOnAnnotatedClassCallback = FutureOr<void> Function(
  String classAnnotationName,
  String className,
);

typedef _TOnAnnotatedMethodCallback = FutureOr<void> Function(
  String methodAnnotationName,
  String methodName,
  String methodType,
);

typedef _TOnClassAnnotationFieldCallback = FutureOr<void> Function(
  String fieldName,
  DartObject fieldValue,
);

typedef _TOnMethodAnnotationFieldCallback = FutureOr<void> Function(
  String fieldName,
  DartObject fieldValue,
);

typedef _TOnAnnotatedMemberCallback = FutureOr<void> Function(
  String memberAnnotationName,
  String memberName,
  String memberType,
);

typedef _TOnMemberAnnotationField = FutureOr<void> Function(
  String fieldName,
  DartObject fieldValue,
);
