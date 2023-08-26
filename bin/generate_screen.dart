// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

import 'package:args/args.dart';

import 'package:xyz_gen/generate_screen/generate_screen.dart';
import 'package:xyz_utils/xyz_utils.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

const ACCESS_SIGNED_IN_OPTION = "access-signed-in";
const ACCESS_SIGNED_IN_VERIFIED_OPTION = "access-signed-in-verified";
const ACCESS_SIGNED_OUT_OPTION = "access-signed-out";
const CONFIG_TEMPLATE_OPTION = "configuration-template";
const HELP_FLAG = "help";
const INTERNAL_PARAMETERS_OPTION = "internal-parameters";
const LOGIC_TEMPLATE_OPTION = "logic-template";
const MAKEUP_OPTION = "makeup";
const NAVIGATOR_OPTION = "navigator";
const OUTPUT_OPTION = "output";
const PATH_SEGMENTS_OPTION = "path-segments";
const QUERY_PARAMETERS_OPTION = "query-parameters";
const REDIRECTABLE_OPTION = "redirectable";
const SCREEN_NAME_OPTION = "screen-name";
const SCREEN_TEMPLATE_OPTION = "screen-template";
const STATE_TEMPLATE_OPTION = "state-template";
const TITLE_OPTION = "title";

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

void main(List<String> arguments) async {
  final parser = ArgParser();
  parser
    ..addOption(
      OUTPUT_OPTION,
      abbr: 'o',
      help: "Path to the output directory.",
      mandatory: true,
    )
    ..addOption(
      SCREEN_NAME_OPTION,
      abbr: 's',
      help: "Name of the screen.",
      mandatory: true,
    )
    ..addOption(
      INTERNAL_PARAMETERS_OPTION,
      help: "Internal parameters.",
    )
    ..addOption(
      QUERY_PARAMETERS_OPTION,
      help: "Query parameters.",
    )
    ..addOption(
      PATH_SEGMENTS_OPTION,
      help: "Path segments.",
    )
    ..addOption(
      LOGIC_TEMPLATE_OPTION,
      defaultsTo: "../templates/screen/screen_logic_template.dart.md",
      help: "Path to logic template file.",
    )
    ..addOption(
      SCREEN_TEMPLATE_OPTION,
      defaultsTo: "../templates/screen/screen_template.dart.md",
      help: "Path to screen template file.",
    )
    ..addOption(
      STATE_TEMPLATE_OPTION,
      defaultsTo: "../templates/screen/screen_state_template.dart.md",
      help: "Path to state template file.",
    )
    ..addOption(
      CONFIG_TEMPLATE_OPTION,
      defaultsTo: "../templates/screen/screen_configuration_template.dart.md",
      help: "Path to configuration template file.",
    )
    ..addOption(
      ACCESS_SIGNED_IN_OPTION,
      defaultsTo: "false",
      help: "Is screen accessible if signed in?",
    )
    ..addOption(
      ACCESS_SIGNED_IN_VERIFIED_OPTION,
      defaultsTo: "false",
      help: "Is screen accessible if signed in and verified?",
    )
    ..addOption(
      ACCESS_SIGNED_OUT_OPTION,
      defaultsTo: "false",
      help: "Is screen accessible if signed out?",
    )
    ..addOption(
      REDIRECTABLE_OPTION,
      defaultsTo: "false",
      help: "Is screen redirectable?",
    )
    ..addOption(
      MAKEUP_OPTION,
      defaultsTo: "",
      help: "Screen makeup.",
    )
    ..addOption(
      TITLE_OPTION,
      defaultsTo: "",
      help: "Screen title.",
    )
    ..addOption(
      NAVIGATOR_OPTION,
      defaultsTo: "",
      help: "Navigator for the screen.",
    )
    ..addFlag(
      HELP_FLAG,
      abbr: 'h',
      negatable: false,
      help: "Displays the help information.",
    );
  try {
    late ArgResults results;
    try {
      results = parser.parse(arguments);
    } catch (e) {
      print(e);
      printRed("Error: Failed to parse arguments.");
      return;
    }
    if (results["help"]) {
      printUsage(parser);
      return;
    }

    if (results[HELP_FLAG]) {
      printUsage(parser);
      return;
    }

    final outputDirPath = results[OUTPUT_OPTION];
    final screenName = results[SCREEN_NAME_OPTION];

    final internalParametersEntries =
        (results[INTERNAL_PARAMETERS_OPTION]?.toString().split(":").map((e) {
              final a = e.split("|");
              return a.length == 2 ? MapEntry(a[0], a[1]) : null;
            }).nonNulls ??
            []);

    final internalParameters = Map.fromEntries(internalParametersEntries);
    final queryParameters = results[QUERY_PARAMETERS_OPTION]?.toString().split(":").toSet() ?? {};
    final pathSegments = results[PATH_SEGMENTS_OPTION]?.toString().split(":").toList() ?? [];

    await generateScreen(
      outputDirPath: outputDirPath,
      screenName: screenName,
      logicTemplateFilePath: results[LOGIC_TEMPLATE_OPTION],
      screenTemplateFilePath: results[SCREEN_TEMPLATE_OPTION],
      stateTemplateFilePath: results[STATE_TEMPLATE_OPTION],
      configurationTemplateFilePath: results[CONFIG_TEMPLATE_OPTION],
      isOnlyAccessibleIfSignedIn: results[ACCESS_SIGNED_IN_OPTION] == "true",
      isOnlyAccessibleIfSignedInAndVerified: results[ACCESS_SIGNED_IN_VERIFIED_OPTION] == "true",
      isOnlyAccessibleIfSignedOut: results[ACCESS_SIGNED_OUT_OPTION] == "true",
      isRedirectable: results[REDIRECTABLE_OPTION] == "true",
      internalParameters: internalParameters,
      queryParameters: queryParameters,
      pathSegments: pathSegments,
      makeup: results[MAKEUP_OPTION],
      title: results[TITLE_OPTION],
      navigator: results[NAVIGATOR_OPTION],
    );
  } catch (e) {
    printRed("Error: $e");
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

void printUsage(ArgParser parser) {
  print(
    [
      "XYZ Screen Generator",
      "Usage:",
      parser.usage,
      // dart generate_screen.dart -o ../my_xyz_project/lib/screens -s ScreenHello
    ].join("\n"),
  );
}
