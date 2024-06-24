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

import '../core_utils/print_arg_parser_usage.dart';
import '../core_utils/valid_args_checker.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// A helper for creating a basic command-line app.
Future<void> basicCmdAppHelper<T extends ValidArgsChecker>({
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
      Here().debugLogError('Failed to parse arguments $e');
      return;
    }
    if (results['help']) {
      printArgParserUsage(appTitle, parser);
      return;
    }
    final args = onResults(parser, results);
    if (!args.isValid) {
      Here().debugLogError('You must provide all required options.');
      printArgParserUsage(appTitle, parser);
      exit(1);
    }
    await action(parser, results, args);
  } catch (e) {
    Here().debugLogError(e);
  }
}
