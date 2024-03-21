//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// 🇽🇾🇿 & Dev
//
// Copyright Ⓒ Robert Mollentze, xyzand.dev
//
// Licensing details can be found in the LICENSE file in the root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

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
      Here().debugLogError('Failed to parse arguments $e');
      return;
    }
    if (results['help']) {
      printUsage(appTitle, parser);
      return;
    }
    final args = onResults(parser, results);
    if (!args.valid) {
      Here().debugLogError('You must provide all required options.');
      printUsage(appTitle, parser);
      exit(1);
    }
    await action(parser, results, args);
  } catch (e) {
    Here().debugLogError(e);
  }
}
