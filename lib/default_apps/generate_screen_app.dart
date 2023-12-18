//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import '/all.dart';

import '/_internal_dependencies.dart';
import '/utils/get_xyz_gen_lib_path.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> generateScreenApp(List<String> arguments) async {
  final defaultTemplatesPath = join(await getXyzGenLibPath(), "templates", "screen");
  final parser = ArgParser()
    ..addFlag(
      "help",
      abbr: "h",
      negatable: false,
      help: "Help information.",
    )
    ..addOption(
      GenerateScreenAppOptions.OUTPUT,
      help: "Output directory path.",
      defaultsTo: toLocalPathFormat("/lib/screens"),
    )
    ..addOption(
      GenerateScreenAppOptions.CLASS_NAME,
      help: "Screen name.",
      defaultsTo: "ScreenTemplate",
    )
    ..addOption(
      GenerateScreenAppOptions.INTERNAL_PARAMETERS,
      help: "Internal parameters.",
    )
    ..addOption(
      GenerateScreenAppOptions.QUERY_PARAMETERS,
      help: "Query parameters.",
    )
    ..addOption(
      GenerateScreenAppOptions.PATH_SEGMENTS,
      help: "Path segments.",
    )
    ..addOption(
      GenerateScreenAppOptions.LOGIC_TEMPLATE,
      help: "Logic template file path.",
      defaultsTo: toLocalPathFormat(
        join(defaultTemplatesPath, "screen_logic_template.dart.md"),
      ),
    )
    ..addOption(
      GenerateScreenAppOptions.SCREEN_TEMPLATE,
      help: "Screen template file path.",
      defaultsTo: toLocalPathFormat(
        join(defaultTemplatesPath, "screen_template.dart.md"),
      ),
    )
    ..addOption(
      GenerateScreenAppOptions.STATE_TEMPLATE,
      help: "State template file path.",
      defaultsTo: toLocalPathFormat(
        join(defaultTemplatesPath, "screen_state_template.dart.md"),
      ),
    )
    ..addOption(
      GenerateScreenAppOptions.CONFIGURATION_TEMPLATE,
      help: "Configuration template file path.",
      defaultsTo: toLocalPathFormat(
        join(defaultTemplatesPath, "screen_configuration_template.dart.md"),
      ),
    )
    ..addOption(
      GenerateScreenAppOptions.PATH,
      help: "Screen path.",
      defaultsTo: "",
    )
    ..addOption(
      GenerateScreenAppOptions.IS_ONLY_ACCESSIBLE_IF_LOGGED_IN,
      help: "Is screen accessible if logged in?",
      defaultsTo: false.toString(),
    )
    ..addOption(
      GenerateScreenAppOptions.IS_ONLY_ACCESSIBLE_IF_LOGGED_IN_AND_VERIFIED,
      help: "Is screen accessible if logged in and verified?",
      defaultsTo: false.toString(),
    )
    ..addOption(
      GenerateScreenAppOptions.IS_ONLY_ACCESSIBLE_IF_LOGGED_OUT,
      help: "Is screen accessible if logged out?",
      defaultsTo: false.toString(),
    )
    ..addOption(
      GenerateScreenAppOptions.IS_REDIRECTABLE,
      help: "Is screen redirectable?",
      defaultsTo: false.toString(),
    )
    ..addOption(
      GenerateScreenAppOptions.MAKEUP,
      help: "Screen makeup.",
    )
    ..addOption(
      GenerateScreenAppOptions.DEFAULT_TITLE,
      help: "Screen title.",
    )
    ..addOption(
      GenerateScreenAppOptions.NAVIGATION_CONTROL_WIDGET,
      help: "Screen navigator.",
    )
    ..addOption(
      BasicConsoleAppOptions.DART_SDK_PATH,
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
    final entries = splitArg(results[GenerateScreenAppOptions.INTERNAL_PARAMETERS], "::")
        ?.map((e) {
          final a = e.split(":");
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
    fallbackDartSdkPath: results[BasicConsoleAppOptions.DART_SDK_PATH],
    outputDirPath: results[GenerateScreenAppOptions.OUTPUT],
    screenName: results[GenerateScreenAppOptions.CLASS_NAME],
    logicTemplateFilePath: results[GenerateScreenAppOptions.LOGIC_TEMPLATE],
    screenTemplateFilePath: results[GenerateScreenAppOptions.SCREEN_TEMPLATE],
    stateTemplateFilePath: results[GenerateScreenAppOptions.STATE_TEMPLATE],
    configurationTemplateFilePath: results[GenerateScreenAppOptions.CONFIGURATION_TEMPLATE],
    path: results[GenerateScreenAppOptions.PATH],
    isAccessibleOnlyIfLoggedIn: toBool(GenerateScreenAppOptions.IS_ONLY_ACCESSIBLE_IF_LOGGED_IN),
    isAccessibleOnlyIfLoggedInAndVerified:
        toBool(GenerateScreenAppOptions.IS_ONLY_ACCESSIBLE_IF_LOGGED_IN_AND_VERIFIED),
    isAccessibleOnlyIfLoggedOut: toBool(GenerateScreenAppOptions.IS_ONLY_ACCESSIBLE_IF_LOGGED_OUT),
    isRedirectable: toBool(GenerateScreenAppOptions.IS_REDIRECTABLE),
    internalParameters: toOptionsMap(GenerateScreenAppOptions.INTERNAL_PARAMETERS),
    queryParameters: splitArg(results[GenerateScreenAppOptions.QUERY_PARAMETERS])?.toSet(),
    pathSegments: splitArg(results[GenerateScreenAppOptions.PATH_SEGMENTS])?.toList(),
    makeup: results[GenerateScreenAppOptions.MAKEUP],
    title: results[GenerateScreenAppOptions.DEFAULT_TITLE],
    navigationControlWidget: results[GenerateScreenAppOptions.NAVIGATION_CONTROL_WIDGET],
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
    path: args.path!,
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
    navigationControlWidget: args.navigationControlWidget ?? "",
  );
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

abstract final class GenerateScreenAppOptions {
  static const DART_SDK_PATH = "dart-sdk";
  static const OUTPUT = "output";
  static const CLASS_NAME = "class-name";
  static const DEFAULT_TITLE = "default-title";
  static const IS_ONLY_ACCESSIBLE_IF_LOGGED_IN_AND_VERIFIED =
      "is-only-accessible-if-logged-in-and-verified";
  static const PATH = "path";
  static const IS_ONLY_ACCESSIBLE_IF_LOGGED_IN = "is-only-accessible-if-logged-in";
  static const IS_ONLY_ACCESSIBLE_IF_LOGGED_OUT = "is-only-accessible-if-logged-out";
  static const IS_REDIRECTABLE = "is-redirectable";
  static const INTERNAL_PARAMETERS = "internal-parameters";
  static const PATH_SEGMENTS = "path-segments";
  static const QUERY_PARAMETERS = "query-parameters";
  static const MAKEUP = "makeup";
  static const NAVIGATION_CONTROL_WIDGET = "navigation-control-widget";
  static const CONFIGURATION_TEMPLATE = "configuration-template";
  static const LOGIC_TEMPLATE = "logic-template";
  static const SCREEN_TEMPLATE = "screen-template";
  static const STATE_TEMPLATE = "state-template";
}
