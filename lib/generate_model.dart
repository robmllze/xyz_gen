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

  final parameterKeys = parameters.keys;
  final keyNames = _getKeyNames(parameters);
  final keyConstNames = _getKeyConstNames(parameters);

  final p0 = parameterKeys.map((e) {
    return 'static const ${keyConstNames[e]} = "${keyNames[e]}";';
  }).join("\n");

  final p1 = parameterKeys.map((e) => "dynamic $e;").join("\n");

  final p2 = parameterKeys.map((e) => "this.$e,").join("\n");

  final p3 = parameterKeys.map((e) {
    return '$e: input["${keyNames[e]}"],';
  }).join("\n");

  // Replace placeholders with the actual values.
  final output = replaceAllData(
    template,
    {
      "___CLASS___": className,
      "___SOURCE_CLASS___": sourceClassName,
      "___CLASS_FILE___": classFileName,
      "___COLLECTION_PATH___": collectionPath,
      "___P0___": p0,
      "___P1___": p1,
      "___P2___": p2,
      "___P3___": p3,
    },
  );

  // Write the generated Dart file.
  await writeFile(outputFilePath, output);

  // Format the generated Dart file.
  await fmtDartFile(outputFilePath);
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Map<String, String> _getKeyNames(Map<String, String> parameters) {
  return parameters.map((k, _) => MapEntry(k, k.toSnakeCase()));
}

Map<String, String> _getKeyConstNames(Map<String, String> parameters) {
  return parameters.map((k, _) => MapEntry(k, "K_${k.toSnakeCase().toUpperCase()}"));
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

// ignore: must_be_immutable
abstract class Model extends Equatable {
  String? id;

  dynamic args;

  Map<String, dynamic> toJMap();

  T copyWith<T extends Model>({T? value});

  T newFromJMap<T extends Model>(Map<String, dynamic> value) =>
      this.newEmpty()..updateWithJMap(value);

  T newOverrideJMap<T extends Model>(Map<String, dynamic> value) =>
      this.newFromJMap({...this.toJMap(), ...value});

  T newOverride<T extends Model>(T value);

  T newEmpty<T extends Model>();

  void updateWithJMap(Map<String, dynamic> value);

  void updateWith<T extends Model>(T value);

  @override
  String toString() => this.toJMap().toString();

  @override
  bool? get stringify => false;
}
