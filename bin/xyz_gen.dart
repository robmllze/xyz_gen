// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

import 'package:xyz_gen/generate_all_exports.dart';
import 'package:xyz_gen/utils/file_io.dart';
import 'package:xyz_gen/utils/helpers.dart';
import 'package:xyz_gen/utils/list_file_paths.dart';
import 'package:path/path.dart' as p;

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> main() async {
  await generateAllExports("./test_project/", {"screen_test"});

  //print(await sourceAndGeneratedFileExists("./screen_test.g.dart"));
  // await analyzeSourceClasses(
  //     filePath: "./screen_test.dart",
  //     annotationDisplayName: "GenerateScreenBlahBlah",
  //     fieldNames: {"options"},
  //     onField: (final classDisplayName, final fieldName, final object) {
  //       switch (fieldName) {
  //         case "options":
  //           final options = object.toSetValue()!.map((e) => e.toStringValue()).toSet();
  //           print("classDisplayName: $classDisplayName");
  //           print("fieldName: $fieldName");
  //           print("options: $options");
  //           break;
  //       }
  //     });
}
