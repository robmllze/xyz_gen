//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:xyz_gen/generators/generate_exports/all_generate_exports.g.dart';
import 'package:xyz_gen/generators/generate_screen/all_generate_screens.g.dart';
import 'package:xyz_gen/generators/generate_screen_access/all_generate_screen_access.g.dart';
import 'package:xyz_gen/xyz_utils/all_xyz_utils.g.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

// 1. Specify the root folder in your project to start generating from.
const APP_FOLDER = "test";

// 2. Give the screen class a name. Always start it with "Screen".
const CLASS_NAME = "ScreenExample";

// 3. Provide a title for the screen.
const DEFAULT_TITLE = "Example";

// 4. Specify the screen's accessibility:
const bool? IS_ONLY_ACCESSIBLE_IF_LOGGED_IN_AND_VERIFIED = false;
const bool? IS_ONLY_ACCESSIBLE_IF_LOGGED_IN = false;
const bool? IS_ONLY_ACCESSIBLE_IF_LOGGED_OUT = false;
const bool? IS_REDIRECTABLE = true;

// 5. Provide a makeup class for the screen:
const MAKEUP = "";

// 6. Provide a navigation control widget for the screen:
const NAVIGATION_CONTROL_WIDGET = "";

// 7. Specify parameters for the screen:
const INTERNAL_PARAMETERS = <String, String>{
  // "title": "String?",
};

// 8. Specify query parameters:
const QUERY_PARAMETERS = <String>{
  // "value1",
  // "value2",
};

// 9. Specify path segments for the screen:
const PATH_SEGMENTS = <String>[
  // "segment1",
  // "segment2",
];

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

const SCREENS_FOLDER = "$APP_FOLDER/lib/screens";

void main() async {
  // STEP 1 - GENERATE THE SCREEN FILES
  await generateScreensApp(
    {
      // Templates.
      "--configuration-template":
          "___generators/templates/generate_screen_configurations/default_screen_configuration_template.dart.md",
      "--logic-template":
          "___generators/templates/generate_screen/default_screen_logic_template.dart.md",
      "--state-template":
          "___generators/templates/generate_screen/default_screen_state_template.dart.md",
      "--screen-template":
          "___generators/templates/generate_screen/default_screen_template.dart.md",

      // Output.
      "--output": SCREENS_FOLDER,

      // Class name.
      "--class-name": CLASS_NAME,

      // Title.
      "--default-title": DEFAULT_TITLE,

      // Access control.
      "--is-only-accessible-if-logged-in-and-verified":
          IS_ONLY_ACCESSIBLE_IF_LOGGED_IN_AND_VERIFIED?.toString(),
      "--is-only-accessible-if-logged-in":
          IS_ONLY_ACCESSIBLE_IF_LOGGED_IN?.toString(),
      "--is-only-accessible-if-logged-out":
          IS_ONLY_ACCESSIBLE_IF_LOGGED_OUT?.toString(),
      "--is-redirectable": IS_REDIRECTABLE?.toString(),

      // Makeup.
      "--makeup": MAKEUP,

      // Navigation control widget.
      "--navigation-control-widget": NAVIGATION_CONTROL_WIDGET,

      // Parameters.
      "--internal-parameters": INTERNAL_PARAMETERS.entries
          .map((e) => "${e.key}:${e.value}")
          .join("::"),
      "--query-parameters": QUERY_PARAMETERS.join(":"),
      "--path-segments": PATH_SEGMENTS.join(":"),
    }
        .map((k, v) => MapEntry(k, v?.nullIfEmpty))
        .nonNulls
        .entries
        .map((e) => [e.key, e.value])
        .reduce((a, b) => [...a, ...b]),
  );
  // STEP 2 - CONNECT THE SCREEN TO THE APP
  await generateScreenAccessApp([
    "-t",
    "___generators/templates/generate_screen_access/default_screen_access_template.dart.md",
    "-r",
    SCREENS_FOLDER,
    "--output",
    "$SCREENS_FOLDER/screen_access.g.dart",
  ]);
  // STEP 3 - INCLUDE SCREEN FILES TO DART EXPORTS
  generateExportsApp([
    "-t",
    "___generators/templates/generate_exports/default_exports_template.dart.md",
    "-r",
    SCREENS_FOLDER,
  ]);
}
