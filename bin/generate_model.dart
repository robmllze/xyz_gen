// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

// ignore_for_file: avoid_print

import 'package:xyz_gen/generate_model_file.dart';
import 'package:xyz_gen/type_codes/loose_type_mappers.dart';
import 'package:xyz_gen/utils/here.dart';
import 'package:xyz_gen/utils/generate.dart';
import 'package:xyz_gen/utils/helpers.dart';
import 'package:xyz_gen/type_codes/type_codes.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

void main() {
  // final parts = decomposeCollectionTypeCode("Map<int, List<List<String>>>");
  // print(parts);

  final result = mapWithLooseToMappers(
    fieldName: "someData",
    typeCode: "List<String>",
  );

  print(result);

  // mapWithLooseFromMappers(
  //   fieldName: "someData",
  //   typeCode: "Map<int, int>",
  // ); //List<Map<String>?>?
  //runObjectFromTests();

  // await generate(
  //   begType: "model",
  //   rootDirPath: "./test_project/lib/models/",
  //   templateFilePath: "./templates/model_template.md",
  //   deleteGeneratedFiles: true,
  //   generateForFile: generateModelFile,
  // );
}
