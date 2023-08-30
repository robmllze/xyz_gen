// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:xyz_utils/xyz_utils_non_web.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

const SEPARATOR = ":";
const TEMPLATE_FILE_PATH_OPTION = "template";
const PATTERNS_OPTION = "patterns";
const ROOTS_OPTION = "roots";
const SUBS_OPTION = "subs";

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

final argParserWithHelp = ArgParser()
  ..addFlag(
    "help",
    abbr: "h",
    negatable: false,
    help: "Help information.",
  );

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

final argParserForBasicGenerator = argParserWithHelp
  ..addOption(
    ROOTS_OPTION,
    abbr: "r",
    help: "Root directory paths separated by `$SEPARATOR`.",
  )
  ..addOption(
    SUBS_OPTION,
    abbr: "s",
    help: "Sub-directory paths separated by `$SEPARATOR`.",
  )
  ..addOption(
    PATTERNS_OPTION,
    abbr: "p",
    help: "Path patterns separated by `$SEPARATOR`.",
  )
  ..addOption(
    TEMPLATE_FILE_PATH_OPTION,
    abbr: "t",
    help: "Template file path.",
  );

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
      printRed("Error: Failed to parse arguments.");
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
  return input?.toString().split(separator).map((e) => e.trim());
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

abstract class ValidObject {
  const ValidObject();
  bool get valid;
  static bool areValid(List<dynamic> inputs) {
    for (final input in inputs) {
      if (input == null) {
        return false;
      }
      try {
        if (input.isEmpty) {
          return false;
        }
      } catch (_) {}
    }
    return true;
  }
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
  final String? templateFilePath;
  final Set<String>? rootPaths;
  final Set<String>? subPaths;
  final Set<String>? pathPatterns;
  const BasicTemplateArgs({
    required this.templateFilePath,
    required this.rootPaths,
    required this.subPaths,
    required this.pathPatterns,
  });

  @override
  bool get valid => ValidObject.areValid([
        this.rootPaths,
        this.pathPatterns,
        this.templateFilePath,
      ]);
}
