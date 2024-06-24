//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// 🇽🇾🇿 & Dev
//
// Licencing details are in the LICENSE file in the root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'dart:io';

import 'package:args/args.dart';
import 'package:xyz_utils/xyz_utils.dart';

import '/src/core_utils/print_arg_parser_usage.dart';
import '/src/core_utils/valid_args_checker.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// A helper for creating and running a basic command-line application.
Future<void> runCommandLineApp<T extends ValidArgsChecker>({
  required String title,
  required List<String> args,
  required ArgParser parser,
  required T Function(
    ArgParser parser,
    ArgResults results,
  ) onResults,
  required Future<void> Function(
    ArgParser parser,
    ArgResults results,
    T checker,
  ) action,
}) async {
  try {
    late ArgResults results;
    try {
      results = parser.parse(args);
    } catch (e) {
      Here().debugLogError('Failed to parse arguments $e');
      return;
    }
    if (results['help']) {
      printArgParserUsage(title, parser);
      return;
    }
    final checker = onResults(parser, results);
    if (!checker.isValid) {
      Here().debugLogError('You must provide all required options.');
      printArgParserUsage(title, parser);
      exit(1);
    }
    await action(parser, results, checker);
  } catch (e) {
    Here().debugLogError(e);
  }
}
