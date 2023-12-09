//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Generate All Exports
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

// ignore_for_file: prefer_relative_imports
import 'package:xyz_gen/default_apps/generate_all_exports_app.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

void main(List<String> arguments) async {
  await generateAllExportsApp([
    if (arguments.isNotEmpty)
      ...arguments
    else ...[
      "-r",
      [
        // TODO: Add your app name here:
        "YOUR_APP_NAME/lib",
      ].join(":"),
      "-s",
      [
        "app",
        "components",
        "configs",
        "firebase_options",
        "lib",
        "makeups",
        "managers",
        "model_filters",
        "models",
        "routing",
        "screens",
        "service_brokers",
        "services",
        "src",
        "themes",
        "types",
        "utils",
        "widgets",
      ].join(":"),
    ]
  ]);
}
