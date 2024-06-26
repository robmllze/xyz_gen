//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// 🇽🇾🇿 & Dev
//
// Licencing details are in the LICENSE file in the root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:xyz_gen_annotations/xyz_gen_annotations.dart';

import 'package:xyz_utils/xyz_utils_non_web.dart' as utils;

import '/src/xyz/_all_xyz.g.dart' as xyz;

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Analyzes the Dart file identified by [filePath] using [analysisContextCollection],
/// and returns a list of insights.
///
/// Each item in the list consists of the name of the analyzed class and the
/// annotation applied to that class.
Future<List<ClassInsight>> analyzeDartFile(
  AnalysisContextCollection analysisContextCollection,
  String filePath,
) async {
  final analyzer = xyz.DartAnnotatedClassAnalyzer(
    filePath: filePath,
    analysisContextCollection: analysisContextCollection,
  );

  final results = <ClassInsight>[];
  late GenerateModel temp;
  await analyzer.analyze(
    inclClassAnnotations: {IGenerateModel.$this.id},
    inclMemberAnnotations: {IField.$this.id},
    onAnnotatedClass: (p) => temp = _updateFromAnnotatedClass(temp, p),
    onClassAnnotationField: (p) => temp = _updateFromClassAnnotationField(temp, p),
    onAnnotatedMember: (p) => temp = _updateFromAnnotatedMember(temp, p),
    onPreAnalysis: (_, className) => temp = const GenerateModel(fields: {}),
    onPostAnalysis: (_, className) => results.add(ClassInsight(className, temp)),
  );
  return results;
}

class ClassInsight {
  final String className;
  final GenerateModel annotation;

  const ClassInsight(
    this.className,
    this.annotation,
  );
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Updates [annotation] by deciding on a new name for the generated class if
/// it clashes with the annotated class.
GenerateModel _updateFromAnnotatedClass(
  GenerateModel annotation,
  xyz.OnAnnotatedClassParams params,
) {
  return _suggestClassName(annotation, params.className);
}

GenerateModel _suggestClassName(GenerateModel annotation, String suggestedClassName) {
  final c = annotation.className?.nullIfEmpty == null
      ? _createGeneratedClassNameFromAnnotatedClassName(suggestedClassName)
      : annotation.className;
  annotation = annotation.copyWith(className: c);
  return annotation;
}

String _createGeneratedClassNameFromAnnotatedClassName(String className) {
  // Removes all leading underscores or dollar signs.
  final a = className.replaceFirst(RegExp(r'^[_$]+'), '');
  // Add 'Model' to the generated class name if it's the same as the annotated class name.
  final b = a != className ? a : '${className}Model';
  return b;
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Updates [annotation] by incorporating the field from [params] into its
/// "fields" property.
GenerateModel _updateFromClassAnnotationField(
  GenerateModel annotation,
  xyz.OnClassAnnotationFieldParams params,
) {
  final x = IGenerateModel.values.valueOf(params.fieldName);
  switch (x) {
    case IGenerateModel.className:
      return annotation.copyWith(
        className: params.fieldValue.toStringValue(),
      );
    case IGenerateModel.fields:
      return annotation.copyWith(
        fields: {
          ...annotation.fields,
          ...?params.fieldValue.toSetValue()?.map((e) {
            final field = Field(
              fieldName: e.fieldNameFromRecord()!,
              fieldType: e.fieldTypeFromRecord()!,
              nullable: e.nullableFromRecord()!,
            );
            return field.toRecord;
          }),
        },
      );
    case IGenerateModel.shouldInherit:
      return annotation.copyWith(
        shouldInherit: params.fieldValue.toBoolValue(),
      );
    case IGenerateModel.inheritanceConstructor:
      return annotation.copyWith(
        inheritanceConstructor: params.fieldValue.toStringValue(),
      );
    case IGenerateModel.keyStringCase:
      return annotation.copyWith(
        keyStringCase: params.fieldValue.toStringValue(),
      );
    default:
  }
  return annotation.copyWith();
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Updates [annotation] by incorporating all members tagged with the @[Field]
/// annotation into its "fields" property.
GenerateModel _updateFromAnnotatedMember(
  GenerateModel annotation,
  xyz.OnAnnotatedMemberParams params,
) {
  if (params.memberAnnotationName == IField.$this.id) {
    final a1 = params.memberAnnotationFields[IField.fieldName.id]?.toStringValue();
    final a2 = params.memberName;
    final b1 = params.memberAnnotationFields[IField.fieldType.id]?.toStringValue();
    final b2 = params.memberType.getDisplayString();
    final c1 = params.memberAnnotationFields[IField.nullable.id]?.toBoolValue();
    final field = xyz.DartField(
      fieldName: a1 ?? a2,
      fieldType: b1 ?? b2,
      nullable: c1,
    );
    annotation = annotation.copyWith(
      fields: {
        ...annotation.fields,
        field.toRecord,
      },
    );
  }
  return annotation;
}
