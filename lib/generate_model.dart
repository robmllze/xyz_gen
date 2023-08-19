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
  var parameters = <String, TypeCode>{};

  void onField(String fieldName, DartObject object) {
    switch (fieldName) {
      case _K_CLASS_NAME:
        className = object.toStringValue() ?? "";
        break;
      case _K_COLLECTION_PATH:
        collectionPath = object.toStringValue();
        break;
      case _K_PARAMETERS:
        parameters = object.toMapValue()?.map((k, v) {
              final t = v?.toStringValue();
              return MapEntry(
                k?.toStringValue(),
                t != null ? TypeCode(t) : null,
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

  parameters["id"] = const TypeCode("String?");
  parameters["args"] = const TypeCode("dynamic");

  final sortedEntries = parameters.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
  final sortedKeys = sortedEntries.map((e) => e.key);
  
  final keyNames = _getKeyNames(sortedKeys);
  final keyConstNames = _getKeyConstNames(sortedKeys);

  final p0 = sortedKeys.map((e) => 'static const ${keyConstNames[e]} = "${keyNames[e]}";');
  final p1 = sortedEntries.map((e) => "${e.value.getName()} ${e.key};");
  final p2 = sortedEntries.map((e) => "${e.value.nullable() ? "" : "required "}this.${e.key},");
  final p2b = sortedKeys.map((e) => "this.$e,");
  final p3 = sortedKeys.map((e) => '$e: input["${keyNames[e]}"],');

  // Replace placeholders with the actual values.
  final output = replaceAllData(
    template,
    {
      "___CLASS___": className,
      "___SOURCE_CLASS___": sourceClassName,
      "___CLASS_FILE___": classFileName,
      "___COLLECTION_PATH___": collectionPath,
      "___P0___": p0.join("\n"),
      "___P1___": p1.join("\n"),
      "___P2___": p2.join("\n"),
      "___P3___": p3.join("\n"),
      "___P2B___": p2b.join("\n"),
    },
  );

  // Write the generated Dart file.
  await writeFile(outputFilePath, output);

  // Format the generated Dart file.
  await fmtDartFile(outputFilePath);
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Map<String, String> _getKeyNames(Iterable<String> parameterKeys) {
  return Map.fromEntries(
    parameterKeys.map(
      (k) => MapEntry(
        k,
        k.toSnakeCase(),
      ),
    ),
  );
}

Map<String, String> _getKeyConstNames(Iterable<String> parameterKeys) {
  return Map.fromEntries(
    parameterKeys.map(
      (e) => MapEntry(
        e,
        "K_${e.toSnakeCase().toUpperCase()}",
      ),
    ),
  );
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

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class TypeCode {
  final String typeCode;
  const TypeCode(this.typeCode);

  String getName() => _typeCodeToTypeName(typeCode);

  bool nullable() {
    final name = this.getName();
    return name.endsWith("?") || name == "dynamic";
  }

  static String _typeCodeToTypeName(String typeCode) {
    var temp = typeCode //
        .replaceAll(" ", "")
        .replaceAll("|let", "");
    while (true) {
      final match = RegExp(r"\w+\|clean\<([\w\[\]\+]+\??)(,[\w\[\]\+]+\??)*\>").firstMatch(temp);
      if (match == null) break;
      final group0 = match.group(0);
      if (group0 == null) break;
      temp = temp.replaceAll(
        group0,
        group0
            .replaceAll("|clean", "")
            .replaceAll("?", "")
            .replaceAll("<", "[")
            .replaceAll(">", "]")
            .replaceAll(",", "+"),
      );
    }
    return temp //
        .replaceAll("[", "<")
        .replaceAll("]", ">")
        .replaceAll("+", ", ");
  }
}
