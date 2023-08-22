// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

// ignore_for_file: unnecessary_this, avoid_print

import 'package:analyzer/dart/constant/value.dart';
import 'package:path/path.dart' as p;
import 'package:xyz_utils/xyz_utils.dart';

import 'type_codes/type_codes.dart';
import 'utils/deep_map.dart';
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
  var parameters = <String, _TypeCode>{};

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
                t != null ? _TypeCode(t) : null,
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

  // Replace placeholders with the actual values.
  final output = replaceAllData(
    template,
    {
      "___CLASS___": className,
      "___SOURCE_CLASS___": sourceClassName,
      "___CLASS_FILE___": classFileName,
      "___COLLECTION_PATH___": collectionPath,
      ..._p(parameters),
    },
  );

  // Write the generated Dart file.
  await writeFile(outputFilePath, output);

  // Format the generated Dart file.
  await fmtDartFile(outputFilePath);
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Map<String, String> _p(Map<String, _TypeCode> input) {
  final parameters = Map<String, _TypeCode>.from(input);

  final id = parameters["id"] ??= const _TypeCode("String?");
  final args = parameters["args"] ??= const _TypeCode("dynamic");
  final allEntries = parameters.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
  final allIds = allEntries.map((e) => e.key);
  final ids = allIds.where((e) => !const ["id", "args"].contains(e));
  final entries = ids.map((i) => MapEntry(i, parameters[i]));
  final nonNullableIds = allIds.where((e) => !parameters[e]!.nullable());
  final keys = _getKeyNames(allIds);
  final keyConsts = _getKeyConstNames(allIds);

  final p = <Iterable>[
    // ___P0___
    allIds.map((e) => 'static const ${keyConsts[e]} = "${keys[e]}";'),
    // ___P1___
    entries.map((e) => "${e.value!.getNullableName()} ${e.key};"),
    // ___P2___
    [
      () {
        assert(id.getNullableName() == "String?");
        return id.nullable() ? "String? id" : "required String id,";
      }(),
      "${args.nullable() ? "" : "required "}${args.getName()} args,",
      ...entries.map((e) => "${e.value!.nullable() ? "" : "required "}this.${e.key},"),
    ],
    // ___P3___
    ["this.id = id;", "this.args = args;"],
    // ___P4___
    [
      "String? id,",
      "${args.getNullableName()} args,",
      ...ids.map((e) => "this.$e,"),
    ],
    // ___P5___
    nonNullableIds.map((e) => "assert(this.$e != null);"),
    // ___P6___
    allIds.map((e) {
      final fieldName = "input[${keyConsts[e]}]";
      final parameter = parameters[e]!;
      final typeCode = parameter.typeCode;
      final value = mapWithLooseFromMappers(
        fieldName: fieldName,
        typeCode: typeCode,
      );
      return "$e: $value,";
    }),

    // ___P7___
    allIds.map((e) {
      final keyConst = keyConsts[e];
      final parameter = parameters[e]!;
      final typeCode = parameter.typeCode;
      final value = mapWithLooseToMappers(
        fieldName: e,
        typeCode: typeCode,
      );
      return "$keyConst: $value,";
    }),
    // 8
    allIds.map((e) => 'this.$e = other.$e ?? this.$e;'),
  ];

  final output = <String, String>{};
  for (var n = 0; n < p.length; n++) {
    output["___P${n}___"] = p[n].join("\n");
  }
  return output;
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
  final Map<String, dynamic> parameters;
  const GenerateModel({
    required this.className,
    this.parameters = const {},
    this.collectionPath,
  });
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

// ignore: must_be_immutable
abstract class Model {
  String? id;

  dynamic args;

  String? collectionPath;

  Map<String, dynamic> toJMap();

  T copy<T extends Model>();

  T copyWith<T extends Model>({T? other});

  void updateWith<T extends Model>(T other);

  @override
  String toString() => this.toJMap().toString();

  bool equals<T extends Model>(T other) => this.toJMap().deep == other.toJMap().deep;

  FirestoreRef? defaultFirestoreRef(dynamic firestore) {
    return collectionPath != null && this.id != null
        ? FirestoreRef._(firestore, this.collectionPath!, this.id!)
        : null;
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class FirestoreRef {
  final dynamic firestore;
  final String collectionPath;
  final String id;
  const FirestoreRef._(this.firestore, this.collectionPath, this.id);
  dynamic get collectionRef => this.firestore.collection(this.collectionPath);
  dynamic get docRef => this.collectionRef().doc(this.id);
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class _TypeCode {
  final String typeCode;

  const _TypeCode(this.typeCode);

  bool nullable() {
    final name = this.getName();
    return name.endsWith("?") || name == "dynamic";
  }

  String getName() => _typeCodeToName(typeCode);
  String getNullableName() => this.nullable() ? this.getName() : "${this.getName()}?";

  static String _typeCodeToName(String typeCode) {
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

  @override
  int get hashCode => this.typeCode.hashCode;

  @override
  bool operator ==(Object other) {
    return other.runtimeType == _TypeCode && other.hashCode == this.hashCode;
  }
}
