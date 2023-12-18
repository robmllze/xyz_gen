//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

// ignore_for_file: prefer_relative_imports
import 'package:xyz_gen/_internal_dependencies.dart';
import 'package:xyz_gen/default_apps/generate_all_exports_app.dart';
import 'package:xyz_gen/default_apps/generate_screen_access_app.dart';
import 'package:xyz_gen/default_apps/generate_screen_app.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

// 1. Specify which app to generate the screen for:
const APP_NAME = "YOUR_APP_NAME";

// 2. Give the screen class a name. Always start it with "Screen".
const CLASS_NAME = "ScreenYourScreen";

// 3. Provide a title for the screen.
const DEFAULT_TITLE = "Your Screen Title";

// 4. Specify the screen's accessibility:
const IS_ONLY_ACCESSIBLE_IF_LOGGED_IN_AND_VERIFIED = false;
const IS_ONLY_ACCESSIBLE_IF_LOGGED_IN = false;
const IS_ONLY_ACCESSIBLE_IF_LOGGED_OUT = false;
const IS_REDIRECTABLE = true;

// 5. [Optional] Provide a makeup class for the screen:
const MAKEUP = "null";

// 6. [Optional] Provide a navigation control widget for the screen:
const NAVIGATION_CONTROL_WIDGET = "null";

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
  await generateScreenApp(
    arguments.isNotEmpty
        ? arguments
        : [
            ..._option(
              GenerateScreenAppOptions.DART_SDK_PATH,
              dartSdk,
            ),
            ..._option(
              GenerateScreenAppOptions.CLASS_NAME,
              CLASS_NAME,
            ),
            ..._option(
              GenerateScreenAppOptions.DEFAULT_TITLE,
              DEFAULT_TITLE,
            ),
            ..._option(
              GenerateScreenAppOptions.OUTPUT,
              "$APP_NAME/lib/screens",
            ),
            ..._option(
              GenerateScreenAppOptions.IS_ONLY_ACCESSIBLE_IF_LOGGED_IN_AND_VERIFIED,
              "$IS_ONLY_ACCESSIBLE_IF_LOGGED_IN_AND_VERIFIED",
            ),
            ..._option(
              GenerateScreenAppOptions.IS_ONLY_ACCESSIBLE_IF_LOGGED_IN,
              "$IS_ONLY_ACCESSIBLE_IF_LOGGED_IN",
            ),
            ..._option(
              GenerateScreenAppOptions.IS_ONLY_ACCESSIBLE_IF_LOGGED_OUT,
              "$IS_ONLY_ACCESSIBLE_IF_LOGGED_OUT",
            ),
            ..._option(
              GenerateScreenAppOptions.IS_REDIRECTABLE,
              "$IS_REDIRECTABLE",
            ),
            ..._option(
              GenerateScreenAppOptions.MAKEUP,
              MAKEUP,
            ),
            ..._option(
              GenerateScreenAppOptions.NAVIGATION_CONTROL_WIDGET,
              NAVIGATION_CONTROL_WIDGET,
            ),
            ..._option(
              GenerateScreenAppOptions.INTERNAL_PARAMETERS,
              INTERNAL_PARAMETERS.entries
                  .map((e) => "${e.key}$PARAM_SEPARATOR${e.value}")
                  .join(PARAM_SEPARATOR * 2),
            ),
            ..._option(
              GenerateScreenAppOptions.QUERY_PARAMETERS,
              QUERY_PARAMETERS.join(PARAM_SEPARATOR),
            ),
            ..._option(
              GenerateScreenAppOptions.PATH_SEGMENTS,
              PATH_SEGMENTS.join(PARAM_SEPARATOR),
            ),
          ],
  );

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

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

List<String> _option(String key, String value) {
  return ["--$key", value];
}
