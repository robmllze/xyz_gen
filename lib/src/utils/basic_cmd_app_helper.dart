//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
// 
// X|Y|Z Gen
//
// https://xyzand.dev/
//
// See LICENSE file in the root of this project for license details.
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