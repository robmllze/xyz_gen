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
    inclClassAnnotations: {GenerateModel.CLASS_NAME},
    inclMemberAnnotations: {Field.CLASS_NAME},
    onClassAnnotationField: (p) async => temp = _updateFromClassAnnotationField(temp, p),
    onAnnotatedMember: (p) async => temp = _updateFromAnnotatedMember(temp, p),
    onPreAnalysis: (_, className) => temp = const GenerateModel(fields: {}),
    onPostAnalysis: (params) {
      final fullPathName = params.fullFilePath;
      final fileName = p.basename(fullPathName);
      final dirPath = p.dirname(fullPathName);
      final insight = _ClassInsight(
        className: params.className,
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
  switch (params.fieldName) {
    case GenerateModelFieldNames.className:
      return annotation.copyWith(
        GenerateModel(
          className: params.fieldValue.toStringValue(),
        ),
      );
    case GenerateModelFieldNames.fields:
      return annotation.copyWith(
        GenerateModel(
          fields: {
            ...?annotation.fields,
            ...?params.fieldValue.toSetValue()?.map((e) {
              final field = Field(
                fieldPath: e.fieldPathFromRecord()!,
                fieldType: e.fieldTypeFromRecord()!,
                nullable: e.nullableFromRecord()!,
              );
              return field.toRecord;
            }),
          },
        ),
      );
    case GenerateModelFieldNames.shouldInherit:
      return annotation.copyWith(
        GenerateModel(
          shouldInherit: params.fieldValue.toBoolValue(),
        ),
      );
    case GenerateModelFieldNames.inheritanceConstructor:
      return annotation.copyWith(
        GenerateModel(
          inheritanceConstructor: params.fieldValue.toStringValue(),
        ),
      );
    case GenerateModelFieldNames.keyStringCase:
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
  if (params.memberAnnotationName == Field.CLASS_NAME) {
    final a1 = xyz.dartObjToList(params.memberAnnotationFields[FieldFieldNames.fieldPath]);
    final a2 = [params.memberName];
    final b1 = params.memberAnnotationFields[FieldFieldNames.fieldType]?.toStringValue();

    final b2 = params.memberType.getDisplayString();
    final c1 = params.memberAnnotationFields[FieldFieldNames.nullable]?.toBoolValue();
    final field = xyz.DartField(
      fieldPath: a1 ?? a2,
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
