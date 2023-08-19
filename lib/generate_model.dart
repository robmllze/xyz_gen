// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

// ignore_for_file: unnecessary_this, avoid_print

import 'package:analyzer/dart/constant/value.dart';
import 'package:equatable/equatable.dart';
import 'package:path/path.dart' as p;
import 'package:xyz_utils/xyz_utils.dart';

import 'utils/file_io.dart';
import 'utils/analyze_source_classes.dart';
import 'utils/helpers.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

const _ANNOTATION_NAME = "GenerateModel";
const _K_CLASS_NAME = "className";
const _K_COLLECTION_PATH = "collectionPath";
const _K_PARAMETERS = "parameters";

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> generateModelFile(
  String fixedFilePath,
  String template,
) async {
  var sourceClassName = "";
  var className = "";
  String? collectionPath;
  var parameters = <String, String>{};

  void onField(String fieldName, DartObject object) {
    switch (fieldName) {
      case _K_CLASS_NAME:
        className = object.toStringValue() ?? "";
        break;
      case _K_COLLECTION_PATH:
        collectionPath = object.toStringValue();
        break;
      case _K_PARAMETERS:
        parameters = object
                .toMapValue()
                ?.map((k, v) => MapEntry(k?.toStringValue(), v?.toStringValue()))
                .nonNulls ??
            {};
        break;
    }
  }

  // Analyze the annotated class to get the field values.
  await analyzeAnnotatedClasses(
    filePath: fixedFilePath,
    annotationName: _ANNOTATION_NAME,
    fieldNames: {
      _K_CLASS_NAME,
      _K_COLLECTION_PATH,
      _K_PARAMETERS,
    },
    onClass: (e) {
      sourceClassName = e;
      print("- Generating model for $e");
    },
    onField: onField,
  );

  // Create the actual values to replace the placeholders with.
  final classFileName = getFileName(fixedFilePath);
  final classFileDirPath = getDirPath(fixedFilePath);
  final classKey = getFileNameWithoutExtension(classFileName);
  final outputFileName = "$classKey.g.dart";
  final outputFilePath = p.join(classFileDirPath, outputFileName);

  // Replace placeholders with the actual values.
  final output = replaceAllData(
    template,
    {
      "___CLASS___": className,
      "___SOURCE_CLASS___": sourceClassName,
      "___CLASS_FILE___": classFileName,
    },
  );

  // Write the generated Dart file.
  await writeFile(outputFilePath, output);

  // Format the generated Dart file.
  await fmtDartFile(outputFilePath);
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

abstract class ModelBody extends Equatable {
  Map<String, dynamic> toJMap();
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class GenerateModel {
  final String className;
  final String? collectionPath;
  final Map<String, String> parameters;
  const GenerateModel({
    required this.className,
    this.parameters = const {},
    this.collectionPath,
  });
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class _ParameterType {
  final String value;
  const _ParameterType(this.value);
  bool get nullable => this.value.endsWith("?");
}
