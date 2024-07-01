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
  String? output,
) async {
  return analyzeModelFromFile(
    collection: collection,
    inputFilePath: inputFilePath,
    generate: (classAnnotationName, annotatedClassName, annotation) async {
      annotation = await generateModel(
        inputFilePath: inputFilePath,
        templates: templates,
        annotation: annotation,
        annotatedClassName: annotatedClassName,
        output: output,
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
  )? generate,
}) async {
  var annotation = const GenerateModel(fields: {});
  var didFindAnnotation = false;
  // Analyze the annotated class and generate the files.
  await analyzeAnnotatedClasses(
    filePath: inputFilePath,
    collection: collection,
    // Call for each annotated class.
    onAnnotatedClass: (
      classAnnotationName,
      annotatedClassName,
    ) async {
      if (generate != null) {
        annotation = await generate(
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
  String? output,
  bool dryRun = false,
}) async {
  // Update the class name.
  annotation = _updateClassName(annotation, annotatedClassName);

  // Get the class file name from the file path.
  final classFileName = getBaseName(inputFilePath);

  // Define a function to generate the Dart model.
  Future<void> $generateDartModel(String template) async {
    final op = replaceData(
      template,
      {
        '___SUPER_CLASS___':
            annotation.shouldInherit ? annotatedClassName : 'Model',
        '___SUPER_CONSTRUCTOR___': annotation.shouldInherit
            ? annotation.inheritanceConstructor?.nullIfEmpty != null
                ? ': super.${annotation.inheritanceConstructor}()'
                : ''
            : '',
        '___CLASS___': annotation.className,
        '___MODEL_ID___': annotation.className?.toLowerSnakeCase(),
        '___CLASS_FILE_NAME___': classFileName,
        ..._dartReplacements(
          annotation: annotation,
          fields: annotation.fields.map((e) => _stdField(e)).nonNulls.map((e) {
            return MapEntry(
              e.fieldName,
              TypeCode.b(
                e.fieldType.toString(),
                nullable: e.nullable,
              ),
            );
          }).toMap(),
          keyStringCaseType:
              StringCaseType.values.valueOf(annotation.keyStringCase) ??
                  StringCaseType.LOWER_SNAKE_CASE,
        ),
      },
    );

    // Get the output file path.
    final outputFilePath = () {
      final classFileDirPath = getDirPath(inputFilePath);
      final classKey = getFileNameWithoutExtension(classFileName);
      final outputFileName = '_$classKey.g.dart';
      return p.joinAll(
        [
          output ?? classFileDirPath,
          outputFileName,
        ].nonNulls,
      );
    }();

    if (!dryRun) {
      // Write the generated Dart file.
      await writeFile(outputFilePath, op);

      // Format the generated Dart file.
      await fmtDartFile(outputFilePath);
    }
  }

  // Define a function to generate the Typescript model.
  Future<void> $generateTypescriptModel(String template) async {
    final op = replaceData(
      template,
      {
        '___CLASS___': annotation.className,
        ..._typescriptReplacements(
          annotation: annotation,
          fields: annotation.fields.map((e) => _stdField(e)).nonNulls.map((e) {
            return MapEntry(
              e.fieldName,
              TypeCode.b(
                e.fieldType.toString(),
                nullable: e.nullable,
              ),
            );
          }).toMap(),
          keyStringCaseType:
              StringCaseType.values.valueOf(annotation.keyStringCase) ??
                  StringCaseType.LOWER_SNAKE_CASE,
        ),
      },
    );

    // Get the output file path.
    final outputFilePath = () {
      final classKey = getFileNameWithoutExtension(classFileName);
      final outputFileName = '_$classKey.g.ts';
      return p.joinAll(
        [
          output ?? 'models',
          outputFileName,
        ].nonNulls,
      );
    }();

    if (!dryRun) {
      // Write the generated Dart file.
      await writeFile(outputFilePath, op);
    }
  }

  // Replace placeholders with the actual values.
  for (final template in templates.entries) {
    final filePath = template.key.toLowerCase();
    final content = template.value;

    if (filePath.endsWith('.dart.md')) {
      await $generateDartModel(content);
    }

    if (filePath.endsWith('.ts.md')) {
      await $generateTypescriptModel(content);
    }
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
    className:
        annotation.className?.nullIfEmpty == null ? b : annotation.className,
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
  final nullable = fieldType == 'dynamic'
      ? false
      : fieldName.endsWith('?') || fieldType.endsWith('?');
  final TStdField more = (
    fieldName: fieldName,
    fieldType: fieldType,
    nullable: nullable,
  );
  if (memberAnnotationName == 'Field') {
    annotation = annotation.copyWith(
      fields: {
        ...annotation.fields,
        more,
      },
    );
  }
  return annotation;
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

GenerateModel _updateFromClassAnnotationField(
  GenerateModel annotation,
  String memberName,
  DartObject memberValue,
) {
  switch (memberName) {
    case 'className':
      return annotation.copyWith(
        className: memberValue.toStringValue() ?? '',
      );

    case 'fields':
      return annotation.copyWith(
        fields: {
          ...annotation.fields,
          ...?memberValue.toSetValue()?.map((e) {
            var fieldName = () {
              final fieldName1 = e.getField('\$1')?.toStringValue();
              final fieldName2 = e.getField('fieldName')?.toStringValue();
              return (fieldName1 ?? fieldName2)!;
            }();
            var fieldType = () {
              final fieldType1 = e.getField('\$2')?.toStringValue();
              final fieldType2 =
                  e.getField('\$2')?.toTypeValue()?.getDisplayString();
              final fieldType3 = e.getField('fieldType')?.toStringValue();
              final fieldType4 =
                  e.getField('fieldType')?.toTypeValue()?.getDisplayString();
              return (fieldType1 ?? fieldType2 ?? fieldType3 ?? fieldType4)!;
            }();
            final nullable = () {
              if (fieldName == 'dynamic' && fieldName == 'dynamic?') {
                return false;
              }
              final nullable1 = e.getField('nullable')?.toBoolValue();
              final nullable2 = e.getField('\$3')?.toBoolValue();
              final nullable3 = fieldName.endsWith('?');
              final nullable4 = fieldType.endsWith('?');
              return nullable1 ?? nullable2 ?? (nullable3 || nullable4);
            }();
            if (fieldName.endsWith('?')) {
              fieldName = fieldName.substring(0, fieldName.length - 1);
            }
            if (fieldType.endsWith('?')) {
              fieldType = fieldType.substring(0, fieldType.length - 1);
            }
            return (
              fieldName: fieldName.toCamelCase(),
              fieldType: fieldType,
              nullable: nullable,
            );
          }),
        },
      );

    case 'shouldInherit':
      return annotation.copyWith(
        shouldInherit: memberValue.toBoolValue() ?? false,
      );
    case 'inheritanceConstructor':
      return annotation.copyWith(
        inheritanceConstructor: memberValue.toStringValue() ?? '',
      );

    case 'keyStringCase':
      return annotation.copyWith(
        keyStringCase:
            memberValue.toStringValue() ?? StringCaseType.LOWER_SNAKE_CASE.name,
      );
    default:
      return annotation;
  }
}
