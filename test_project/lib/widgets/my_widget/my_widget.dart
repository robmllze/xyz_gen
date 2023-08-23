import 'package:xyz_gen/generate_makeups/annotation.dart';

@GenerateMakeups(
  names: {
    "default",
    "primary",
    "secondary",
  },
  parameters: {
    "value": "int?",
    "colorCode": "String?",
  },
)
class MyWidget {
  int? value;
  @Include()
  bool? primary;
}

class Include {
  const Include();
}

class Exclude {
  const Exclude();
}
