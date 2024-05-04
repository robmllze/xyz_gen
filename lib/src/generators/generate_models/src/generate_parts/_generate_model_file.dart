//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// 🇽🇾🇿 & Dev
//
// Licencing details are in the LICENSE file in the root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

part of '../generate.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<GenerateModel?> _generateModelFromFile(
  AnalysisContextCollection collection,
  String inputFilePath,
  Map<String, String> templates,
) async {
  return analyzeModelFromFile(
    collection: collection,
    inputFilePath: inputFilePath,
    generateModel: (classAnnotationName, annotatedClassName, annotation) async {
      annotation = await generateModel(
        inputFilePath: inputFilePath,
        templates: templates,
        annotation: annotation,
        annotatedClassName: annotatedClassName,
      );
      return annotation;
    },
  );
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<GenerateModel?> analyzeModelFromFile({
  required AnalysisContextCollection collection,
  required String inputFilePath,
  Future<GenerateModel> Function(
    String classAnnotationName,
    String annotatedClassName,
    GenerateModel annotation,
  )? generateModel,
}) async {
  var annotation = const GenerateModel();
  var didFindAnnotation = false;
  // Analyze the annotated class and generate the model file.
  await analyzeAnnotatedClasses(
    filePath: inputFilePath,
    collection: collection,
    // Call for each annotated class.
    onAnnotatedClass: (
      classAnnotationName,
      annotatedClassName,
    ) async {
      if (generateModel != null) {
        annotation = await generateModel(
          classAnnotationName,
          annotatedClassName,
          annotation,
        );
      } else {
        annotation = _updateClassName(
          annotation,
          annotatedClassName,
        );
      }
      didFindAnnotation = true;
    },
    // Allow the following class annotations:
    classAnnotations: {'GenerateModel'},
    // Call for each field in the annotation.
    onClassAnnotationField: (fieldName, fieldValue) {
      annotation = _updateFromClassAnnotationField(
        annotation,
        fieldName,
        fieldValue,
      );
    },
    // Call for each annotated member.
    onAnnotatedMember: (
      memberAnnotationName,
      memberName,
      memberType,
    ) {
      annotation = _updateFromAnnotatedMember(
        annotation,
        memberAnnotationName,
        memberName,
        memberType,
      );
    },
    // Allow the following member annotations.
    memberAnnotations: {'Field'},
  );
  return didFindAnnotation ? annotation : null;
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<GenerateModel> generateModel({
  required String inputFilePath,
  required Map<String, String> templates,
  required GenerateModel annotation,
  required String annotatedClassName,
  bool dryRun = false,
}) async {
  // Update the class name.
  annotation = _updateClassName(annotation, annotatedClassName);

  // Get the class file name from the file path.
  final classFileName = getBaseName(inputFilePath);

  // Replace placeholders with the actual values.
  final template = templates.values.first;
  final output = replaceData(
    template,
    {
      '___SUPER_CLASS___': annotation.shouldInherit ? annotatedClassName : 'Model',
      '___SUPER_CONSTRUCTOR___': annotation.shouldInherit
          ? annotation.inheritanceConstructor?.nullIfEmpty != null
              ? ': super.${annotation.inheritanceConstructor}()'
              : ''
          : '',
      '___CLASS___': annotation.className,
      '___MODEL_ID___': annotation.className?.toLowerSnakeCase(),
      '___CLASS_FILE_NAME___': classFileName,
      ..._replacements(
        fields: annotation.fields?.map((e) => _stdField(e)).nonNulls.map((t) {
              final fieldName = t.fieldName;
              final fieldType = t.fieldType.toString();
              final nullable = t.nullable == true || t.fieldType.endsWith('?');
              return MapEntry(
                fieldName,
                TypeCode.b(
                  fieldType,
                  nullable: nullable,
                ),
              );
            }).toMap() ??
            {},
        keyStringCaseType: StringCaseType.values.valueOf(annotation.keyStringCase) ??
            StringCaseType.LOWER_SNAKE_CASE,
      ),
    },
  );

  // Get the output file path.
  final outputFilePath = () {
    final classFileDirPath = getDirPath(inputFilePath);
    final classKey = getFileNameWithoutExtension(classFileName);
    final outputFileName = '_$classKey.g.dart';
    return p.join(classFileDirPath, outputFileName);
  }();

  if (!dryRun) {
    // Write the generated Dart file.
    await writeFile(outputFilePath, output);

    // Format the generated Dart file.
    await fmtDartFile(outputFilePath);
  }

  return annotation;
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

GenerateModel _updateClassName(
  GenerateModel annotation,
  String annotatedClassName,
) {
  final a = annotatedClassName.replaceFirst(RegExp(r'^[_$]+'), '');
  final b = a != annotatedClassName ? a : '${annotatedClassName}Model';
  annotation = annotation.copyWith(
    className: annotation.className?.nullIfEmpty == null ? b : annotation.className,
  );
  return annotation;
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

GenerateModel _updateFromAnnotatedMember(
  GenerateModel annotation,
  String memberAnnotationName,
  String fieldName,
  String fieldType,
) {
  final TStdField more = (
    fieldName: fieldName,
    fieldType: fieldType,
    nullable: fieldType.endsWith('?'),
  );
  if (memberAnnotationName == 'Field') {
    annotation = annotation.copyWith(
      fields: {
        ...?annotation.fields,
        more,
      },
    );
  }
  return annotation;
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

GenerateModel _updateFromClassAnnotationField(
  GenerateModel annotation,
  String fieldName,
  DartObject fieldValue,
) {
  switch (fieldName) {
    case 'className':
      return annotation.copyWith(
        className: fieldValue.toStringValue() ?? '',
      );

    case 'fields':
      return annotation.copyWith(
        fields: {
          ...?annotation.fields,
          ...?fieldValue.toSetValue()?.map((e) {
            final fieldName1 = e.getField('\$1')?.toStringValue();
            final fieldName2 = e.getField('fieldName')?.toStringValue();
            final fieldName = (fieldName1 ?? fieldName2)!;
            final nullable1 = e.getField('nullable')?.toBoolValue();
            final nullable2 = e.getField('\$3')?.toBoolValue();
            final nullable = (nullable1 ?? nullable2) ?? true;
            final fieldType1 = e.getField('\$2')?.toStringValue();
            final fieldType2 =
                e.getField('\$2')?.toTypeValue()?.getDisplayString(withNullability: nullable);
            final fieldType3 = e.getField('fieldType')?.toStringValue();
            final fieldType4 =
                e.getField('fieldType')?.toTypeValue()?.getDisplayString(withNullability: nullable);
            final fieldType = (fieldType1 ?? fieldType2 ?? fieldType3 ?? fieldType4)!;
            return (
              fieldName: fieldName,
              fieldType: fieldType,
              nullable: nullable,
            );
          }),
        },
      );

    case 'shouldInherit':
      return annotation.copyWith(
        shouldInherit: fieldValue.toBoolValue() ?? false,
      );
    case 'inheritanceConstructor':
      return annotation.copyWith(
        inheritanceConstructor: fieldValue.toStringValue() ?? '',
      );

    case 'keyStringCase':
      return annotation.copyWith(
        keyStringCase: fieldValue.toStringValue() ?? StringCaseType.LOWER_SNAKE_CASE.name,
      );
    default:
      return annotation;
  }
}
