// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

import '_dependencies.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

const SEPARATOR = ":";
const TEMPLATE_FILE_PATH_OPTION = "template";
const PATTERNS_OPTION = "patterns";
const ROOTS_OPTION = "roots";
const SUBS_OPTION = "subs";
const DART_SDK_PATH_OPTION = "dart-sdk";
const OUTPUT_OPTION = "output";

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

FutureOr<void> basicConsoleAppBody<T extends ValidObject>({
  required String appTitle,
  required List<String> arguments,
  required ArgParser parser,
  required T Function(ArgParser, ArgResults) onResults,
  required FutureOr<void> Function(ArgParser, ArgResults, T) action,
}) async {
  try {
    late ArgResults results;
    try {
      results = parser.parse(arguments);
    } catch (e) {
      printRed("[Error: Failed to parse arguments] $e");
      return;
    }
    if (results["help"]) {
      printUsage(appTitle, parser);
      return;
    }

    final args = onResults(parser, results);

    if (!args.valid) {
      printRed("You must provide all required options.");
      printUsage(appTitle, parser);
      exit(1);
    }

    await action(parser, results, args);
  } catch (e) {
    printRed("Error: $e");
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Iterable<String>? splitArg(dynamic input, [String separator = SEPARATOR]) {
  return input?.toString().split(separator).map((e) => e.trim()).nullIfEmpty;
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

void printUsage(String appTitle, ArgParser parser) {
  printLightCyan(
    [
      appTitle,
      "Usage:",
      parser.usage,
    ].join("\n"),
  );
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class BasicTemplateArgs extends ValidObject {
  final String? fallbackDartSdkPath;
  final String? templateFilePath;
  final Set<String>? rootPaths;
  final Set<String>? subPaths;
  final Set<String>? pathPatterns;
  const BasicTemplateArgs({
    this.fallbackDartSdkPath,
    required this.templateFilePath,
    required this.rootPaths,
    required this.subPaths,
    required this.pathPatterns,
  });

  @override
  bool get valid => ValidObject.areValid([
        if (this.fallbackDartSdkPath != null) this.fallbackDartSdkPath,
        this.templateFilePath,
        this.rootPaths,
        if (this.subPaths != null) this.subPaths,
        if (this.pathPatterns != null) this.pathPatterns,
      ]);
}
