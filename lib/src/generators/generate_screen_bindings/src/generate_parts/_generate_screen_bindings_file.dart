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

Future<Set<String>> _generateForFile(
  AnalysisContextCollection collection,
  String fixedFilePath,
  Map<String, String> templates,
) async {
  // ---------------------------------------------------------------------------

  var annotation = const GenerateScreenBindings();

  // ---------------------------------------------------------------------------

  // Define the function to call for each annotated class.
  Future<void> onAnnotatedClass(String _, String annotatedClassName) async {
    // Create the actual values to replace the placeholders with.
    final className = annotation.className?.nullIfEmpty ?? annotatedClassName;
    final classFileName = getBaseName(fixedFilePath);
    final classFileDirPath = getDirPath(fixedFilePath);
    final screenKey = annotation.screenKey?.nullIfEmpty ??
        className.replaceFirst('Screen', '').toSnakeCase();
    final screenConstKey = screenKey.toUpperCase();
    final configurationClassName = '${className}Configuration';
    final screenSegment = p.joinAll(
      [
        annotation.path.isNotEmpty &&
                annotation.path.startsWith(RegExp(r'[\\/]'))
            ? annotation.path.substring(1)
            : annotation.path,
        screenKey,
      ],
    );
    final screenPath = '/$screenSegment';
    assert(
      !annotation.isAccessibleOnlyIfLoggedInAndVerified ||
          !annotation.isAccessibleOnlyIfLoggedIn,
      'Cannot set both `isAccessibleOnlyIfLoggedInAndVerified` and `isAccessibleOnlyIfLoggedIn` to `true`.',
    );
    assert(
      !annotation.isAccessibleOnlyIfLoggedInAndVerified ||
          !annotation.isAccessibleOnlyIfLoggedOut,
      'Cannot set both `isAccessibleOnlyIfLoggedInAndVerified` and `isAccessibleOnlyIfLoggedOut` to `true`.',
    );
    assert(
      !annotation.isAccessibleOnlyIfLoggedIn ||
          !annotation.isAccessibleOnlyIfLoggedOut,
      'Cannot set both `isAccessibleOnlyIfLoggedIn` and `isAccessibleOnlyIfLoggedOut` to `true`.',
    );
    final isAlwaysAccessible =
        (!annotation.isAccessibleOnlyIfLoggedInAndVerified &&
            !annotation.isAccessibleOnlyIfLoggedIn &&
            !annotation.isAccessibleOnlyIfLoggedOut);
    const OUTPUT_FILE_NAME = '_bindings.g.dart';
    final outputFilePath = p.join(classFileDirPath, OUTPUT_FILE_NAME);

    // Replace placeholders with the actual values.
    final template = templates.values.first;
    final output = replaceData(
      template,
      {
        '___CLASS___': className,
        '___CONFIGURATION_CLASS___': configurationClassName,
        '___CLASS_FILE___': classFileName,
        '___SCREEN_KEY___': screenKey,
        '___SCREEN_CONST_KEY___': screenConstKey,
        '___SCREEN_SEGMENT___': screenSegment,
        '___SCREEN_PATH___': screenPath,
        '___IS_ACCESSIBLE_ONLY_IF_LOGGED_IN_AND_VERIFIED___':
            annotation.isAccessibleOnlyIfLoggedInAndVerified,
        '___IS_ACCESSIBLE_ONLY_IF_LOGGED_IN___':
            annotation.isAccessibleOnlyIfLoggedIn,
        '___IS_ACCESSIBLE_ONLY_IF_LOGGED_OUT___':
            annotation.isAccessibleOnlyIfLoggedOut,
        '___IS_ALWAYS_ACCESSIBLE___': isAlwaysAccessible,
        '___IS_REDIRECTABLE___': annotation.isRedirectable,
        '___IP0___': _ip0(annotation.internalParameters),
        '___IP1___': _ip1(annotation.internalParameters),
        '___IP2___': _ip2(annotation.internalParameters),
        '___QP0___': _qp0(annotation.queryParameters),
        '___QP1___': _qp1(annotation.queryParameters),
        '___QP2___': _qp2(annotation.queryParameters),
        '___DEFAULT_TITLE___': annotation.defaultTitle,
        '___MAKEUP___': annotation.makeup,
      }.nonNulls,
    );

    // Write the generated Dart file.
    await writeFile(outputFilePath, output);

    // Format the generated Dart file.
    await fmtDartFile(outputFilePath);
  }

  // ---------------------------------------------------------------------------

  final classNames = <String>{};

  // Analyze the annotated class and generate the screen bindings file.
  await analyzeAnnotatedClasses(
    filePath: fixedFilePath,
    collection: collection,
    classAnnotations: {'GenerateScreenBindings'},
    onAnnotatedClass: (classAnnotationName, className) async {
      await onAnnotatedClass(classAnnotationName, className);
      // Get all the class names to use later.
      classNames.add(className);
    },
    onClassAnnotationField: (fieldName, fieldValue) {
      annotation = _updateFromClassAnnotationField(
        annotation,
        fieldName,
        fieldValue,
      );
    },
  );

  // Return the class names to use later.
  return classNames;
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

// Define the function to call for each annotation field.
GenerateScreenBindings _updateFromClassAnnotationField(
  GenerateScreenBindings annotation,
  String fieldName,
  DartObject memberValue,
) {
  switch (fieldName) {
    case 'path':
      return annotation.copyWith(
        path: memberValue.toStringValue()?.nullIfEmpty ?? annotation.path,
      );
    case 'isAccessibleOnlyIfLoggedInAndVerified':
      return annotation.copyWith(
        isAccessibleOnlyIfLoggedInAndVerified:
            memberValue.toBoolValue() ?? false,
      );
    case 'isAccessibleOnlyIfLoggedIn':
      return annotation.copyWith(
        isAccessibleOnlyIfLoggedIn: memberValue.toBoolValue() ?? false,
      );
    case 'isAccessibleOnlyIfLoggedOut':
      return annotation.copyWith(
        isAccessibleOnlyIfLoggedOut: memberValue.toBoolValue() ?? false,
      );
    case 'isRedirectable':
      return annotation.copyWith(
        isRedirectable: memberValue.toBoolValue() ?? false,
      );
    case 'internalParameters':
      return annotation.copyWith(
        internalParameters: {
          ...annotation.internalParameters,
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
    case 'queryParameters':
      // These all have a String type.
      return annotation.copyWith(
        queryParameters: {
          ...annotation.queryParameters,
          ...?memberValue.toSetValue()?.map((e) {
            var fieldName = () {
              final fieldName1 = e.getField('\$1')?.toStringValue();
              final fieldName2 = e.getField('fieldName')?.toStringValue();
              return (fieldName1 ?? fieldName2)!;
            }();
            return (
              fieldName: fieldName.toCamelCase(),
              fieldType: 'String',
              nullable: true,
            );
          }),
        },
      );
    case 'defaultTitle':
      return annotation.copyWith(
        defaultTitle:
            memberValue.toStringValue()?.nullIfEmpty ?? annotation.defaultTitle,
      );
    case 'makeup':
      return annotation.copyWith(
        makeup: memberValue.toStringValue()?.nullIfEmpty ?? annotation.makeup,
      );
    case 'className':
      return annotation.copyWith(
        className:
            memberValue.toStringValue()?.nullIfEmpty ?? annotation.className,
      );
    case 'screenKey':
      return annotation.copyWith(
        screenKey:
            memberValue.toStringValue()?.nullIfEmpty ?? annotation.screenKey,
      );
  }
  return annotation;
}
