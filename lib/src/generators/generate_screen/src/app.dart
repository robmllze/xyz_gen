//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:args/args.dart';
import 'package:path/path.dart' as p;

import '/_common.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// A command line app for generating screens.
Future<void> generateScreensApp(List<String> arguments) async {
  final defaultTemplatesPath = p.join(
    await getXyzGenLibPath(),
    "generators",
    "generate_screen",
    "templates",
  );
  await basicCmdAppHelper<GenerateScreenArgs>(
    appTitle: "XYZ Gen - Generate Screen",
    arguments: arguments,
    parser: ArgParser()
      ..addFlag(
        "help",
        abbr: "h",
        negatable: false,
        help: "Help information.",
      )
      ..addOption(
        "output",
        abbr: "o",
        help: "Output directory path.",
        defaultsTo: toLocalSystemPathFormat("/lib/screens"),
      )
      ..addOption(
        "class-name",
        help: "Screen name.",
        defaultsTo: "ScreenExample",
      )
      ..addOption(
        "internal-parameters",
        help: "Internal parameters.",
      )
      ..addOption(
        "query-parameters",
        help: "Query parameters.",
      )
      ..addOption(
        "path-segments",
        help: "Path segments.",
      )
      ..addOption(
        "logic-template",
        help: "Logic template file path.",
        defaultsTo: toLocalSystemPathFormat(
          p.join(defaultTemplatesPath, "default_screen_logic_template.dart.md"),
        ),
      )
      ..addOption(
        "screen-template",
        help: "Screen template file path.",
        defaultsTo: toLocalSystemPathFormat(
          p.join(defaultTemplatesPath, "default_screen_template.dart.md"),
        ),
      )
      ..addOption(
        "state-template",
        help: "State template file path.",
        defaultsTo: toLocalSystemPathFormat(
          p.join(defaultTemplatesPath, "default_screen_state_template.dart.md"),
        ),
      )
      ..addOption(
        "configuration-template",
        help: "Configuration template file path.",
        defaultsTo: toLocalSystemPathFormat(
          p.join(defaultTemplatesPath,
              "default_screen_configuration_template.dart.md"),
        ),
      )
      ..addOption(
        "path",
        help: "Screen path.",
        defaultsTo: "",
      )
      ..addOption(
        "is-only-accessible-if-logged-in",
        help: "Is screen accessible if logged in?",
        defaultsTo: false.toString(),
      )
      ..addOption(
        "is-only-accessible-if-logged-in-and-verified",
        help: "Is screen accessible if logged in and verified?",
        defaultsTo: false.toString(),
      )
      ..addOption(
        "is-only-accessible-if-logged-out",
        help: "Is screen accessible if logged out?",
        defaultsTo: false.toString(),
      )
      ..addOption(
        "is-redirectable",
        help: "Is screen redirectable?",
        defaultsTo: false.toString(),
      )
      ..addOption(
        "makeup",
        help: "Screen makeup.",
      )
      ..addOption(
        "default-title",
        help: "Screen title.",
      )
      ..addOption(
        "navigation-control-widget",
        help: "Screen navigator.",
      )
      ..addOption(
        "dart-sdk",
        help: "Dart SDK path.",
      ),
    onResults: (parser, results) {
      Map<String, String>? toOptionsMap(String option) {
        final entries = splitArg(results["internal-parameters"], "&&")
            ?.map((e) {
              final a = e.split(":");
              return a.length == 2 ? MapEntry(a[0], a[1]) : null;
            })
            .nonNulls
            .toSet();
        return entries != null
            ? Map<String, String>.fromEntries(entries)
            : null;
      }

      bool toBool(String option) {
        return results[option]?.toString().toLowerCase().trim() ==
            true.toString();
      }

      return GenerateScreenArgs(
        fallbackDartSdkPath: results["dart-sdk"],
        outputDirPath: results["output"],
        screenName: results["class-name"],
        logicTemplateFilePath: results["logic-template"],
        screenTemplateFilePath: results["screen-template"],
        stateTemplateFilePath: results["state-template"],
        configurationTemplateFilePath: results["configuration-template"],
        path: results["path"],
        isAccessibleOnlyIfLoggedIn: toBool("is-only-accessible-if-logged-in"),
        isAccessibleOnlyIfLoggedInAndVerified:
            toBool("is-only-accessible-if-logged-in-and-verified"),
        isAccessibleOnlyIfLoggedOut: toBool("is-only-accessible-if-logged-out"),
        isRedirectable: toBool("is-redirectable"),
        internalParameters: toOptionsMap("internal-parameters"),
        queryParameters: splitArg(results["query-parameters"])?.toSet(),
        pathSegments: splitArg(results["path-segments"])?.toList(),
        makeup: results["makeup"],
        title: results["default-title"],
        navigationControlWidget: results["navigation-control-widget"],
      );
    },
    action: (parser, results, args) async {
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
        isAccessibleOnlyIfLoggedInAndVerified:
            args.isAccessibleOnlyIfLoggedInAndVerified!,
        isAccessibleOnlyIfLoggedOut: args.isAccessibleOnlyIfLoggedOut!,
        isRedirectable: args.isRedirectable!,
        internalParameters: args.internalParameters ?? const {},
        queryParameters: args.queryParameters ?? const {},
        pathSegments: args.pathSegments ?? const [],
        makeup: args.makeup ?? "",
        title: args.title ?? "",
        navigationControlWidget: args.navigationControlWidget ?? "",
      );
    },
  );
}
