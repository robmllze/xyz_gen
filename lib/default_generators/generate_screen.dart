//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'dart:io';

// ignore_for_file: prefer_relative_imports
import 'package:xyz_gen/default_apps/generate_all_exports_app.dart';
import 'package:xyz_gen/default_apps/generate_screen_access_app.dart';
import 'package:xyz_gen/default_apps/generate_screen_app.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

// TODO: Add your app name here:
// 1. Specify which app to generate the screen for:
const APP_NAME = "YOUR_APP_NAME";

// 2. Give the screen a name.
const SCREEN_NAME = "ScreenYourScreenName";

// 3. Provide a title for the screen.
const SCREEN_TITLE = "Your Screen Title";

// 4. Specify the screen's accessibility:
const IS_ONLY_ACCESSIBLE_IF_LOGGED_IN_AND_VERIFIED = false;
const IS_ONLY_ACCESSIBLE_IF_LOGGED_IN = false;
const IS_ONLY_ACCESSIBLE_IF_LOGGED_OUT = false;
const IS_REDIRECTABLE = true;

// 5. [Optional] Provide a makeup class for the screen:
const MAKEUP = "null";

// 6. [Optional] Provide a navigation control class for the screen:
const NAVIGATION_CONTROLS = "null";

// 7. [Optional] Specify parameters for the screen:
const INTERNAL_PARAMETERS = <String, String>{
  // "title": "String?",
};

// 8. [Optional] Specify query parameters:
const QUERY_PARAMETERS = <String>{
  // "value1",
  // "value2",
};

// 9. [Optional] Specify path segments for the screen:
const PATH_SEGMENTS = <String>[
  // "segment1",
  // "segment2",
];

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

void main(List<String> arguments) async {
  // STEP 0 - GET THE DART SDK PATH
  final dartSdk = Directory(Platform.resolvedExecutable).parent.parent.path;

  // STEP 1 - GENERATE THE SCREEN FILES
  await generateScreenApp([
    if (arguments.isNotEmpty)
      ...arguments
    else ...[
      "--dart-sdk",
      dartSdk,
      "--name",
      SCREEN_NAME,
      "--title",
      SCREEN_TITLE,
      "--output",
      "$APP_NAME/lib/screens",
      "--is-only-accessible-if-logged-in-and-verified",
      "$IS_ONLY_ACCESSIBLE_IF_LOGGED_IN_AND_VERIFIED",
      "--is-only-accessible-if-logged-in",
      "$IS_ONLY_ACCESSIBLE_IF_LOGGED_IN",
      "--is-only-accessible-if-logged-out",
      "$IS_ONLY_ACCESSIBLE_IF_LOGGED_OUT",
      "--is-redirectable",
      "$IS_REDIRECTABLE",
      "--makeup",
      MAKEUP,
      "--navigation-controls",
      NAVIGATION_CONTROLS,
      "--internal-parameters",
      INTERNAL_PARAMETERS.entries.map((e) => "${e.key}:${e.value}").join("::"),
      "--query-parameters",
      QUERY_PARAMETERS.join(":"),
      "--path-segments",
      PATH_SEGMENTS.join(":"),
    ],
  ]);

  // STEP 2 - CONNECT THE SCREEN TO THE ROUTER
  await generateScreenAccessApp([
    if (arguments.isNotEmpty)
      ...arguments
    else ...[
      "-r",
      [
        "$APP_NAME/lib",
      ].join(":"),
      "-s",
      "screens",
      "-o",
      "$APP_NAME/lib/screens/screen_access.g.dart",
    ],
  ]);

  // STEP 3 - MAKE THE SCREEN FILES AVAILABLE TO THE APP
  generateAllExportsApp([
    if (arguments.isNotEmpty)
      ...arguments
    else ...[
      "-r",
      "$APP_NAME/lib",
      "-s",
      "screens",
    ],
  ]);
}
