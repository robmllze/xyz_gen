//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'dart:io' show exit;

import 'package:args/args.dart';

import '/_common.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// A helper for creating a basic command-line app.
Future<void> basicCmdAppHelper<T extends ValidObject>({
  required String appTitle,
  required List<String> arguments,
  required ArgParser parser,
  required T Function(ArgParser, ArgResults) onResults,
  required Future<void> Function(ArgParser, ArgResults, T) action,
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

/// An arguments model for a basic command-line app.
class BasicCmdAppArgs extends ValidObject {
  //
  //
  //

  final String? fallbackDartSdkPath;
  final String? templateFilePath;
  final Set<String>? rootPaths;
  final Set<String>? subPaths;
  final Set<String>? pathPatterns;

  //
  //
  //

  const BasicCmdAppArgs({
    this.fallbackDartSdkPath,
    required this.templateFilePath,
    required this.rootPaths,
    required this.subPaths,
    required this.pathPatterns,
  });

  //
  //
  //

  @override
  bool get valid => ValidObject.areValid([
        if (this.fallbackDartSdkPath != null) this.fallbackDartSdkPath,
        this.templateFilePath,
        this.rootPaths,
        if (this.subPaths != null) this.subPaths,
        if (this.pathPatterns != null) this.pathPatterns,
      ]);
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Splits the given [input] string by the given [separator] and trims each part.
Iterable<String>? splitArg(dynamic input, [Pattern separator = "&"]) {
  return input?.toString().split(separator).map((e) => e.trim()).nullIfEmpty;
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Prints the usage information for the given [parser].
void printUsage(String appTitle, ArgParser parser) {
  printLightCyan(
    [
      appTitle,
      "Usage:",
      parser.usage,
    ].join("\n"),
  );
}
