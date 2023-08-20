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


Future<void> main() async {

  /*
  final a = parseTypeCode("String?");
  print(a);
   */
  // final name = "data";
  // final typeCode = "List<String>?";
  // final compiled = TypeCodeCompiler.withDefaultFromMappers().compile(typeCode, name).replaceFirst(
  //       "#x0",
  //       _subEventReplacement(
  //         typeCode,
  //         name,
  //         {
  //           ...defaultFromMappers,
  //         },
  //       ),
  //     );

  // await generate(
  //   begType: "model",
  //   rootDirPath: "./test_project/lib/models/",
  //   templateFilePath: "./templates/model_template.md",
  //   deleteGeneratedFiles: true,
  //   generateForFile: generateModelFile,
  // );
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

String _subEventReplacement(
  String type,
  String fieldName,
  TMappers mappers,
) {
  // Get all mappers that match the type.
  final results = filterMappersByType(
    mappers,
    type,
  );
  // If there are any matches, take the first one.
  if (results.isNotEmpty) {
    final result = results.entries.first;

    final typePattern = result.key;

    final match = RegExp(typePattern).firstMatch(type);
    if (match != null) {
      final event = ObjectMapperEvent.custom(
        fieldName,
        Iterable.generate(match.groupCount + 1, (i) => match.group(i)!),
      );
      final eventMapper = result.value;
      return eventMapper(event);
    }
  }
  return "null /* ERROR: Unsupported type and/or only nullable types supported */";
}
