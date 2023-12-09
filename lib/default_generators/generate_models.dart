//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Generate Models
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

// ignore_for_file: prefer_relative_imports
import 'package:xyz_gen/default_apps/generate_all_exports_app.dart';
import 'package:xyz_gen/default_apps/generate_models_app.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

// TODO: Add your app name here:
const APP_NAME = "YOUR_APP_NAME";

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

void main(List<String> arguments) async {
  // STEP 1 - GENERATE THE MODELS
  await generateModelsApp([
    if (arguments.isNotEmpty)
      ...arguments
    else ...[
      "-r",
      [
        "$APP_NAME/lib",
      ].join(":"),
      "-s",
      "models",
    ]
  ]);
  // STEP 2 - MAKE THE MODELS FILES AVAILABLE TO THE APP
  generateAllExportsApp([
    if (arguments.isNotEmpty)
      ...arguments
    else ...[
      "-r",
      "$APP_NAME/lib",
      "-s",
      "models",
    ]
  ]);
}
