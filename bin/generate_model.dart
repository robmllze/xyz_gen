// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

import 'package:xyz_gen/generate_model_file.dart';
import 'package:xyz_gen/utils/call_details.dart';
import 'package:xyz_gen/utils/genrate.dart';
import 'package:xyz_gen/utils/helpers.dart';
import 'package:xyz_gen/utils/type_code_compiler.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class AAA {
  asdasd() {
    CallDetails().debugLogAlert("Hello world!");
  }
}

Future<void> main() async {
  AAA().asdasd();

  final name = "data";
  final typeCode = "List<String>?";
  final compiled = TypeCodeMapper(defaultFromMappers).map(typeCode, name);
  print(compiled);

  // await generate(
  //   begType: "model",
  //   rootDirPath: "./test_project/lib/models/",
  //   templateFilePath: "./templates/model_template.md",
  //   deleteGeneratedFiles: true,
  //   generateForFile: generateModelFile,
  // );
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░


