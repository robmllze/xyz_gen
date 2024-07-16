//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// 🇽🇾🇿 & Dev
//
// Licencing details are in the LICENSE file in the root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:path/path.dart' as p;
import 'package:xyz_gen_annotations/xyz_gen_annotations.dart';
import 'package:xyz_utils/xyz_utils_non_web.dart' as utils;

import '/src/xyz/_index.g.dart' as xyz;

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Analyzes the Dart file at [filePath] using [analysisContextCollection], and
/// and extracts class insights from it.
///
/// Each item in the list consists of the name of the analyzed class and the
/// annotation applied to that class.
Future<List<_ClassInsight>> extractClassInsightsFromDartFile(
  AnalysisContextCollection analysisContextCollection,
  String filePath,
) async {
  final analyzer = xyz.DartAnnotatedClassAnalyzer(
    filePath: filePath,
    analysisContextCollection: analysisContextCollection,
  );

  final insights = <_ClassInsight>[];
  late GenerateModel temp;
  await analyzer.analyze(
    inclClassAnnotations: {GenerateModel.CLASS},
    inclMemberAnnotations: {Field.CLASS},
    onClassAnnotationField: (p) async => temp = _updateFromClassAnnotationField(temp, p),
    onAnnotatedMember: (p) async => temp = _updateFromAnnotatedMember(temp, p),
    onPreAnalysis: (_, className) => temp = const GenerateModel(fields: {}),
    onPostAnalysis: (fullFilePath, className) {
      final fileName = p.basename(fullFilePath);
      final dirPath = p.dirname(fullFilePath);
      final insight = _ClassInsight(
        className: className,
        annotation: temp,
        dirPath: dirPath,
        fileName: fileName,
      );
      insights.add(insight);
    },
  );
  return insights;
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Updates [annotation] by incorporating the field from [params] into its
/// "fields" property.
GenerateModel _updateFromClassAnnotationField(
  GenerateModel annotation,
  xyz.OnClassAnnotationFieldParams params,
) {
  final x = GenerateModelFields.values.valueOf(params.fieldName);
  switch (x) {
    case GenerateModelFields.className:
      return annotation.copyWith(
        GenerateModel(
          className: params.fieldValue.toStringValue(),
        ),
      );
    case GenerateModelFields.fields:
      return annotation.copyWith(
        GenerateModel(
          fields: {
            ...?annotation.fields,
            ...?params.fieldValue.toSetValue()?.map((e) {
              final field = Field(
                fieldName: e.fieldNameFromRecord()!,
                fieldType: e.fieldTypeFromRecord()!,
                nullable: e.nullableFromRecord()!,
              );
              return field.toRecord;
            }),
          },
        ),
      );
    case GenerateModelFields.shouldInherit:
      return annotation.copyWith(
        GenerateModel(
          shouldInherit: params.fieldValue.toBoolValue(),
        ),
      );
    case GenerateModelFields.inheritanceConstructor:
      return annotation.copyWith(
        GenerateModel(
          inheritanceConstructor: params.fieldValue.toStringValue(),
        ),
      );
    case GenerateModelFields.keyStringCase:
      return annotation.copyWith(
        GenerateModel(
          keyStringCase: params.fieldValue.toStringValue(),
        ),
      );
    default:
  }
  return GenerateModel.of(annotation);
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Updates [annotation] by incorporating all members tagged with the @[Field]
/// annotation into its "fields" property.
GenerateModel _updateFromAnnotatedMember(
  GenerateModel annotation,
  xyz.OnAnnotatedMemberParams params,
) {
  if (params.memberAnnotationName == Field.CLASS) {
    final a1 = params.memberAnnotationFields[FieldFields.fieldName.field.fieldName]?.toStringValue();
    final a2 = params.memberName;
    final b1 = params.memberAnnotationFields[FieldFields.fieldType.field.fieldName]?.toStringValue();
    final b2 = params.memberType.getDisplayString();
    final c1 = params.memberAnnotationFields[FieldFields.nullable.field.fieldName]?.toBoolValue();
    final field = xyz.DartField(
      fieldName: a1 ?? a2,
      fieldType: b1 ?? b2,
      nullable: c1,
    );
    annotation = annotation.copyWith(
      GenerateModel(
        fields: {
          ...?annotation.fields,
          field.toRecord,
        },
      ),
    );
  }
  return annotation;
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

typedef _ClassInsight = xyz.ClassInsight<GenerateModel>;
