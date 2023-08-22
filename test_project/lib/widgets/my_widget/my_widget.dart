import 'package:xyz_gen/generate_makeups/annotation.dart';

@GenerateMakeups(
  names: {
    "default",
    "primary",
    "secondary",
  },
  parameters: {
    "value": "int?",
    "colorCode": "String",
  },
)
class MyWidget {
  int? value;
}
