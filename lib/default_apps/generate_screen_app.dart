//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Generate Screen App
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:path/path.dart' as p;
import '/xyz_gen.dart';
import '/get_xyz_gen_lib_path.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

const _NAME_OPTION = "name";
const _TITLE_OPTION = "title";
const _OUTPUT_OPTION = "output";
const _IS_ONLY_ACCESSIBLE_IF_LOGGED_IN_AND_VERIFIED_OPTION =
    "is-only-accessible-if-logged-in-and-verified";
const _IS_ONLY_ACCESSIBLE_IF_LOGGED_IN_OPTION = "is-only-accessible-if-logged-in";
const _IS_ONLY_ACCESSIBLE_IF_LOGGED_OUT_OPTION = "is-only-accessible-if-logged-out";
const _IS_REDIRECTABLE_OPTION = "is-redirectable";
const _INTERNAL_PARAMETERS_OPTION = "internal-parameters";
const _PATH_SEGMENTS_OPTION = "path-segments";
const _QUERY_PARAMETERS_OPTION = "query-parameters";
const _MAKEUP_OPTION = "makeup";
const _NAVIGATION_CONTROLS_OPTION = "navigation-controls";
const _CONFIGURATION_TEMPLATE_OPTION = "configuration-template";
const _LOGIC_TEMPLATE_OPTION = "logic-template";
const _SCREEN_TEMPLATE_OPTION = "screen-template";
const _STATE_TEMPLATE_OPTION = "state-template";

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> generateScreenApp(List<String> arguments) async {
  final defaultTemplatesPath = p.join(await getXyzGenLibPath(), "templates", "screen");
  final parser = ArgParser()
    ..addFlag(
      "help",
      abbr: "h",
      negatable: false,
      help: "Help information.",
    )
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
      defaultsTo: toLocalPathFormat(p.join(defaultTemplatesPath, "screen_logic_template.dart.md")),
    )
    ..addOption(
      _SCREEN_TEMPLATE_OPTION,
      help: "Screen template file path.",
      defaultsTo: toLocalPathFormat(p.join(defaultTemplatesPath, "screen_template.dart.md")),
    )
    ..addOption(
      _STATE_TEMPLATE_OPTION,
      help: "State template file path.",
      defaultsTo: toLocalPathFormat(p.join(defaultTemplatesPath, "screen_state_template.dart.md")),
    )
    ..addOption(
      _CONFIGURATION_TEMPLATE_OPTION,
      help: "Configuration template file path.",
      defaultsTo: toLocalPathFormat(p.join(defaultTemplatesPath, "screen_configuration_template.dart.md")),
    )
    ..addOption(
      _IS_ONLY_ACCESSIBLE_IF_LOGGED_IN_OPTION,
      help: "Is screen accessible if logged in?",
      defaultsTo: false.toString(),
    )
    ..addOption(
      _IS_ONLY_ACCESSIBLE_IF_LOGGED_IN_AND_VERIFIED_OPTION,
      help: "Is screen accessible if logged in and verified?",
      defaultsTo: false.toString(),
    )
    ..addOption(
      _IS_ONLY_ACCESSIBLE_IF_LOGGED_OUT_OPTION,
      help: "Is screen accessible if logged out?",
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
      _NAVIGATION_CONTROLS_OPTION,
      help: "Screen navigator.",
    )
    ..addOption(
      DART_SDK_PATH_OPTION,
      help: "Dart SDK path.",
    );
  await basicConsoleAppBody<GenerateScreenArgs>(
    appTitle: "XYZ Generate Screen",
    arguments: arguments,
    parser: parser,
    onResults: onResults,
    action: action,
  );
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

GenerateScreenArgs onResults(_, dynamic results) {
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

  bool toBool(String option) {
    return results[option]?.toString().toLowerCase().trim() == true.toString();
  }

  return GenerateScreenArgs(
    fallbackDartSdkPath: results[DART_SDK_PATH_OPTION],
    outputDirPath: results[_OUTPUT_OPTION],
    screenName: results[_NAME_OPTION],
    logicTemplateFilePath: results[_LOGIC_TEMPLATE_OPTION],
    screenTemplateFilePath: results[_SCREEN_TEMPLATE_OPTION],
    stateTemplateFilePath: results[_STATE_TEMPLATE_OPTION],
    configurationTemplateFilePath: results[_CONFIGURATION_TEMPLATE_OPTION],
    isAccessibleOnlyIfLoggedIn: toBool(_IS_ONLY_ACCESSIBLE_IF_LOGGED_IN_OPTION),
    isAccessibleOnlyIfLoggedInAndVerified:
        toBool(_IS_ONLY_ACCESSIBLE_IF_LOGGED_IN_AND_VERIFIED_OPTION),
    isAccessibleOnlyIfLoggedOut: toBool(_IS_ONLY_ACCESSIBLE_IF_LOGGED_OUT_OPTION),
    isRedirectable: toBool(_IS_REDIRECTABLE_OPTION),
    internalParameters: toOptionsMap(_INTERNAL_PARAMETERS_OPTION),
    queryParameters: splitArg(results[_QUERY_PARAMETERS_OPTION])?.toSet(),
    pathSegments: splitArg(results[_PATH_SEGMENTS_OPTION])?.toList(),
    makeup: results[_MAKEUP_OPTION],
    title: results[_TITLE_OPTION],
    navigationControls: results[_NAVIGATION_CONTROLS_OPTION],
  );
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> action(_, __, GenerateScreenArgs args) async {
  await generateScreen(
    fallbackDartSdkPath: args.fallbackDartSdkPath,
    outputDirPath: args.outputDirPath!,
    screenName: args.screenName!,
    logicTemplateFilePath: args.logicTemplateFilePath!,
    screenTemplateFilePath: args.screenTemplateFilePath!,
    stateTemplateFilePath: args.stateTemplateFilePath!,
    configurationTemplateFilePath: args.configurationTemplateFilePath!,
    isAccessibleOnlyIfLoggedIn: args.isAccessibleOnlyIfLoggedIn!,
    isAccessibleOnlyIfLoggedInAndVerified: args.isAccessibleOnlyIfLoggedInAndVerified!,
    isAccessibleOnlyIfLoggedOut: args.isAccessibleOnlyIfLoggedOut!,
    isRedirectable: args.isRedirectable!,
    internalParameters: args.internalParameters ?? const {},
    queryParameters: args.queryParameters ?? const {},
    pathSegments: args.pathSegments ?? const [],
    makeup: args.makeup ?? "",
    title: args.title ?? "",
    navigationControls: args.navigationControls ?? "",
  );
}
