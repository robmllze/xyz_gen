//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Screen Access - MediKinect Access App
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

// ignore_for_file: prefer_relative_imports
import 'package:xyz_gen/default_apps/generate_all_exports_app.dart';
import 'package:xyz_gen/default_apps/generate_screen_access_app.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

// TODO: Add your app name here:
const APP_NAME = "YOUR_APP_NAME";

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

void main(List<String> arguments) async {
  final libs = [
    "$APP_NAME/lib",
  ].join(":");
  await generateScreenAccessApp([
    if (arguments.isNotEmpty)
      ...arguments
    else ...[
      "-r",
      libs,
      "-s",
      "screens",
      "-o",
      "$APP_NAME/lib/screens/screen_access.g.dart",
    ],
  ]);
  await generateAllExportsApp([
    if (arguments.isNotEmpty)
      ...arguments
    else ...[
      "-r",
      libs,
      "-s",
      "screens",
    ],
  ]);
}
