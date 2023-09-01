// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Generate Screen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

import 'package:xyz_gen/xyz_gen.dart';
import 'package:xyz_utils/xyz_utils.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

// RENAME THESE TO MATCH THE SCRIPT:

const _NAME_OPTION = "name";
const _TITLE_OPTION = "title";
const _OUTPUT_OPTION = "output";
const _IS_ONLY_ACCESSIBLE_IF_SIGNED_IN_AND_VERIFIED_OPTION =
    "is-only-accessible-if-signed-in-and-verified";
const _IS_ONLY_ACCESSIBLE_IF_SIGNED_IN_OPTION = "is-only-accessible-if-signed-in";
const _IS_ONLY_ACCESSIBLE_IF_SIGNED_OUT_OPTION = "is-only-accessible-if-signed-out";
const _IS_REDIRECTABLE_OPTION = "is-redirectable";
const _INTERNAL_PARAMETERS_OPTION = "internal-parameters";
const _PATH_SEGMENTS_OPTION = "path-segments";
const _QUERY_PARAMETERS_OPTION = "query-parameters";
const _MAKEUP_OPTION = "makeup";
const _NAVIGATOR_OPTION = "navigator";
const _CONFIGURATION_TEMPLATE_OPTION = "configuration-template";
const _LOGIC_TEMPLATE_OPTION = "logic-template";
const _SCREEN_TEMPLATE_OPTION = "screen-template";
const _STATE_TEMPLATE_OPTION = "state-template";

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> main(List<String> arguments) async {
  await basicConsoleAppBody<GenerateScreenArgs>(
    appTitle: "XYZ Generate Screen",
    arguments: arguments,
    parser: argParserWithHelp
      ..addOption(
        _OUTPUT_OPTION,
        help: "Output directory path.",
        defaultsTo: toLocalPathFormat(SCREENS_PATH),
      )
      ..addOption(
        _NAME_OPTION,
        help: "Screen name.",
        defaultsTo: "ScreenTemplate",
      )
      ..addOption(
        _INTERNAL_PARAMETERS_OPTION,
        help: "Internal parameters.",
      )
      ..addOption(
        _QUERY_PARAMETERS_OPTION,
        help: "Query parameters.",
      )
      ..addOption(
        _PATH_SEGMENTS_OPTION,
        help: "Path segments.",
      )
      ..addOption(
        _LOGIC_TEMPLATE_OPTION,
        help: "Logic template file path.",
        defaultsTo: toLocalPathFormat(SCREEN_LOGIC_TEMPLATE_PATH),
      )
      ..addOption(
        _SCREEN_TEMPLATE_OPTION,
        help: "Screen template file path.",
        defaultsTo: toLocalPathFormat(SCREEN_TEMPLATE_PATH),
      )
      ..addOption(
        _STATE_TEMPLATE_OPTION,
        help: "State template file path.",
        defaultsTo: toLocalPathFormat(SCREEN_STATE_TEMPLATE_PATH),
      )
      ..addOption(
        _CONFIGURATION_TEMPLATE_OPTION,
        help: "Configuration template file path.",
        defaultsTo: toLocalPathFormat(SCREEN_CONFIGURATION_TEMPLATE_PATH),
      )
      ..addOption(
        _IS_ONLY_ACCESSIBLE_IF_SIGNED_IN_OPTION,
        help: "Is screen accessible if signed in?",
        defaultsTo: false.toString(),
      )
      ..addOption(
        _IS_ONLY_ACCESSIBLE_IF_SIGNED_IN_AND_VERIFIED_OPTION,
        help: "Is screen accessible if signed in and verified?",
        defaultsTo: false.toString(),
      )
      ..addOption(
        _IS_ONLY_ACCESSIBLE_IF_SIGNED_OUT_OPTION,
        help: "Is screen accessible if signed out?",
        defaultsTo: false.toString(),
      )
      ..addOption(
        _IS_REDIRECTABLE_OPTION,
        help: "Is screen redirectable?",
        defaultsTo: false.toString(),
      )
      ..addOption(
        _MAKEUP_OPTION,
        help: "Screen makeup.",
      )
      ..addOption(
        _TITLE_OPTION,
        help: "Screen title.",
      )
      ..addOption(
        _NAVIGATOR_OPTION,
        help: "Screen navigator.",
      ),
    onResults: onResults,
    action: action,
  );
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

GenerateScreenArgs onResults(_, final results) {
  Map<String, String>? toOptionsMap(String option) {
    final entries = splitArg(results[_INTERNAL_PARAMETERS_OPTION], "$SEPARATOR$SEPARATOR")
        ?.map((e) {
          final a = e.split(SEPARATOR);
          return a.length == 2 ? MapEntry(a[0], a[1]) : null;
        })
        .nonNulls
        .toSet();
    return entries != null ? Map<String, String>.fromEntries(entries) : null;
  }

  return GenerateScreenArgs(
    outputDirPath: results[_OUTPUT_OPTION],
    screenName: results[_NAME_OPTION],
    logicTemplateFilePath: results[_LOGIC_TEMPLATE_OPTION],
    screenTemplateFilePath: results[_SCREEN_TEMPLATE_OPTION],
    stateTemplateFilePath: results[_STATE_TEMPLATE_OPTION],
    configurationTemplateFilePath: results[_CONFIGURATION_TEMPLATE_OPTION],
    isOnlyAccessibleIfSignedIn: results[_IS_ONLY_ACCESSIBLE_IF_SIGNED_IN_OPTION] == "true",
    isOnlyAccessibleIfSignedInAndVerified:
        results[_IS_ONLY_ACCESSIBLE_IF_SIGNED_IN_AND_VERIFIED_OPTION] == "true",
    isOnlyAccessibleIfSignedOut: results[_IS_ONLY_ACCESSIBLE_IF_SIGNED_OUT_OPTION] == "true",
    isRedirectable: results[_IS_REDIRECTABLE_OPTION] == "true",
    internalParameters: toOptionsMap(_INTERNAL_PARAMETERS_OPTION),
    queryParameters: splitArg(results[_QUERY_PARAMETERS_OPTION])?.toSet(),
    pathSegments: splitArg(results[_PATH_SEGMENTS_OPTION])?.toList(),
    makeup: results[_MAKEUP_OPTION],
    title: results[_TITLE_OPTION],
    navigator: results[_NAVIGATOR_OPTION],
  );
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> action(_, __, GenerateScreenArgs args) async {
  await generateScreen(
    outputDirPath: args.outputDirPath!,
    screenName: args.screenName!,
    logicTemplateFilePath: args.logicTemplateFilePath!,
    screenTemplateFilePath: args.screenTemplateFilePath!,
    stateTemplateFilePath: args.stateTemplateFilePath!,
    configurationTemplateFilePath: args.configurationTemplateFilePath!,
    isOnlyAccessibleIfSignedIn: args.isOnlyAccessibleIfSignedIn!,
    isOnlyAccessibleIfSignedInAndVerified: args.isOnlyAccessibleIfSignedInAndVerified!,
    isOnlyAccessibleIfSignedOut: args.isOnlyAccessibleIfSignedOut!,
    isRedirectable: args.isRedirectable ?? true,
    internalParameters: args.internalParameters ?? const {},
    queryParameters: args.queryParameters ?? const {},
    pathSegments: args.pathSegments ?? const [],
    makeup: args.makeup ?? "",
    title: args.title ?? "",
    navigator: args.navigator ?? "",
  );
}
