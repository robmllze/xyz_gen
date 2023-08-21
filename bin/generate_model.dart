// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

import 'package:xyz_gen/generate_model_file.dart';
import 'package:xyz_gen/utils/here.dart';
import 'package:xyz_gen/utils/generate.dart';
import 'package:xyz_gen/utils/helpers.dart';
import 'package:xyz_gen/utils/type_code_mapper.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

void main() {
  runTypeCodeMapperTests();

  // await generate(
  //   begType: "model",
  //   rootDirPath: "./test_project/lib/models/",
  //   templateFilePath: "./templates/model_template.md",
  //   deleteGeneratedFiles: true,
  //   generateForFile: generateModelFile,
  // );
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

// ignore_for_file: avoid_print

void runTypeCodeMapperTests() {
  final mapper = TypeCodeMapper(looseObjectFromMappers);
  test(mapper, "String?", "firstName");
  test(mapper, "bool", "registered");
  test(mapper, "int?", "age");
  test(mapper, "double?", "height");
  test(mapper, "num", "lucky");
  test(mapper, "Timestamp?", "firestoreTimestamp");
  test(mapper, "_Timestamp?", "timestamp");
  test(mapper, "DateTime?", "dob");
  test(mapper, "Duration", "period");
  test(mapper, "Uri", "websiteUrl");
  test(mapper, "UserType?", "userType");
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

void test(TypeCodeMapper mapper, String typeCode, String fieldName) {
  final mappedFirstName = mapper.mapObject(typeCode, fieldName);
  print("`$fieldName` with `$typeCode` ---> $mappedFirstName");
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

final looseObjectFromMappers = newTypeMappers({
  r"^String[\?]?$": (e) {
    if (e is! ObjectMapperEvent) throw TypeError();
    return "${e.name}?.toTrimmedStringOrNull()";
  },
  r"^bool[\?]?$": (e) {
    if (e is! ObjectMapperEvent) throw TypeError();
    return "letBool(${e.name})";
  },
  r"^int[\?]?$": (e) {
    if (e is! ObjectMapperEvent) throw TypeError();
    return "letInt(${e.name})";
  },
  r"^double[\?]?$": (e) {
    if (e is! ObjectMapperEvent) throw TypeError();
    return "letDouble(${e.name})";
  },
  r"^num[\?]?$": (e) {
    if (e is! ObjectMapperEvent) throw TypeError();
    return "letNum(${e.name})";
  },
  r"^Timestamp[\?]?$": (e) {
    if (e is! ObjectMapperEvent) throw TypeError();
    return "(${e.name} is Timestamp ? ${e.name}: null)";
  },
  r"^_Timestamp[\?]?$": (e) {
    if (e is! ObjectMapperEvent) throw TypeError();
    return "letTimestamp(${e.name})";
  },
  r"^DateTime[\?]?$": (e) {
    if (e is! ObjectMapperEvent) throw TypeError();
    return "letTimestamp(${e.name})?.toDate()?.toLocal()";
  },
  r"^Duration[\?]?$": (e) {
    if (e is! ObjectMapperEvent) throw TypeError();
    return "${e.name}?.toTrimmedStringOrNull()?.tryParseDuration()";
  },
  r"^Uri[\?]?$": (e) {
    if (e is! ObjectMapperEvent) throw TypeError();
    return "(${e.name} is String ? ${e.name}?.trim().nullIfEmpty.toUri(): null)";
  },
  r"^(\w+Type)[\?]?$": (e) {
    if (e is! ObjectMapperEvent) throw TypeError();
    final typeName = e.matchGroups?.elementAt(1);
    return "nameTo$typeName(letAs<String>(${e.name}))";
  },
});
