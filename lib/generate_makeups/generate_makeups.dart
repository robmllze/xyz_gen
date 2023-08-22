// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

import 'package:analyzer/dart/constant/value.dart';
import 'package:xyz_utils/xyz_utils.dart';
import 'package:path/path.dart' as p;

import '../type_codes/type_codes.dart';
import '../utils/analyze_source_classes.dart';
import '../utils/file_io.dart';
import '../utils/generate.dart';
import '../utils/helpers.dart';
import '../utils/here.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

const _ANNOTATION_NAME = "GenerateMakeups";
const _K_NAMES = "names";
const _K_PARAMETERS = "parameters";

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> generateMakeups({
  required String rootDirPath,
  required Set<String> templateFilePaths,
  Set<String> pathPatterns = const {},
}) async {
  await generate(
    rootDirPath: rootDirPath,
    templateFilePaths: templateFilePaths,
    deleteGeneratedFiles: true,
    pathPatterns: pathPatterns,
    generateForFiles: (a, b) => _generateMakeupFiles(null, a, b),
  );
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> _generateMakeupFiles(
  String? outputDirPath,
  String fixedFilePath,
  Map<String, String> templates,
) async {
  var className = "";
  var names = <String>{};
  var parameters = <String, TypeCode>{};

  void onField(String fieldName, DartObject object) {
    switch (fieldName) {
      case _K_NAMES:
        names = object.toSetValue()?.map((e) => e.toStringValue()).nonNulls.toSet() ?? <String>{};
        break;
      case _K_PARAMETERS:
        parameters = object.toMapValue()?.map((k, v) {
              final typeCode = v?.toStringValue();
              return MapEntry(
                k?.toStringValue(),
                typeCode != null ? TypeCode(typeCode) : null,
              );
            }).nonNulls ??
            {};
        break;
    }
  }

  // Analyze the annotated class to get the field values.
  await analyzeAnnotatedClasses(
    filePath: fixedFilePath,
    annotationName: _ANNOTATION_NAME,
    fieldNames: {
      _K_NAMES,
      _K_PARAMETERS,
    },
    onClass: (e) {
      Here().debugLog("Generating makeup class for $e");
      className = e;
    },
    onField: onField,
  );

  if (className.isEmpty) return;

  // Create the actual values to replace the placeholders with.
  final classFileName = getFileName(fixedFilePath);
  final classFileDirPath = getDirPath(fixedFilePath);
  final defaultOutputDirPath = p.join(classFileDirPath, "makeups");
  final classKey = className.toSnakeCase();
  final makeupClassName = "${className}Makeup";
  //final makeupClassKey = makeupClassName.toSnakeCase();
  const outputFileName0 = "_makeup.g.dart";
  final outputDirPath0 =
      outputDirPath == null ? defaultOutputDirPath : p.join(outputDirPath, classKey);
  final outputFilePath0 = p.join(outputDirPath0, outputFileName0);

  final entries = parameters.entries;
  final p0 = entries.map((e) => "${e.value.name} ${e.key};");
  final p1 = entries.map((e) => "${e.value.nullable ? "" : "required "}this.${e.key},");
  final p2 = entries.map((e) => "${e.value.nullableName} ${e.key},");
  final p3 = entries.map((e) => "${e.key}: ${e.key} ?? this.${e.key},");

  final data0 = {
    "___MAKEUP_FILE___": outputFileName0,
    "___MAKEUP_CLASS___": makeupClassName,
    "___CLASS_FILE___": classFileName,
    "___CLASS_KEY___": classKey,
    "___CLASS___": className,
    "___P0___": p0.join("\n"),
    "___P1___": p1.join("\n"),
    "___P2___": p2.join("\n"),
    "___P3___": p3.join("\n"),
  };

  final template0 = templates.values.elementAt(0);

  // Replace placeholders with the actual values.
  final output0 = replaceAllData(
    template0,
    data0,
  );

  // Write the generated Dart file.
  await writeFile(outputFilePath0, output0);

  // Format the generated Dart file.
  await fmtDartFile(outputFilePath0);

  final template1 = templates.values.elementAt(1);

  final a0 = entries.map((e) => "${e.key}: null,${e.value.nullable ? "" : "// Value required!"}");

  final exportFiles = <String>[outputFileName0];

  for (final name in names) {
    final makeupKey = "${name.toSnakeCase()}_${classKey}_makeup";
    final makeupBuilder = makeupKey.toCamelCase();
    final outputFileName1 = "_$makeupKey.dart";
    exportFiles.add(outputFileName1);
    final outputFilePath1 = p.join(outputDirPath0, outputFileName1);

    final output1 = replaceAllData(
      template1,
      {
        ...data0,
        "___MAKEUP_BUILDER___": makeupBuilder,
        "___MAKEUP_KEY___": makeupKey,
        "___A0___": a0.join("\n"),
      },
    );

    Here().debugLog("Generating makeup builder for $name");

    await writeFile(outputFilePath1, output1);
    await fmtDartFile(outputFilePath1);
  }

  final outputFilePath2 = p.join(outputDirPath0, "makeups.dart");
  final template2 = templates.values.elementAt(2);

  final output2 = replaceAllData(template2, {
    ...data0,
    "___EXPORTS___": exportFiles.map((e) => "export '$e';").join("\n"),
  });

  await writeFile(outputFilePath2, output2);
  await fmtDartFile(outputFilePath2);
}
