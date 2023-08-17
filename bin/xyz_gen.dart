import 'package:xyz_gen/utils/analyze_source_classes.dart';

Future<void> main() async {
  await analyzeSourceClasses(
      filePath: "./screen_test.dart",
      annotationDisplayName: "GenerateScreenBlahBlah",
      fieldNames: {"options"},
      onField: (final classDisplayName, final fieldName, final object) {
        switch (fieldName) {
          case "options":
            final options = object.toSetValue()!.map((e) => e.toStringValue()).toSet();
            print("classDisplayName: $classDisplayName");
            print("fieldName: $fieldName");
            print("options: $options");
            break;
        }
      });
}
