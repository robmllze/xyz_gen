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
import 'package:path/path.dart' as p;

import '/_common.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// A command line app for generating license headers.
Future<void> generateLicenseHeadersApp(List<String> arguments) async {
  await basicCmdAppHelper<BasicCmdAppArgs>(
    appTitle: 'XYZ Gen - Generate License Headers',
    arguments: arguments,
    parser: ArgParser()
      ..addFlag(
        'help',
        abbr: 'h',
        negatable: false,
        help: 'Help information.',
      )
      ..addOption(
        'roots',
        abbr: 'r',
        help: 'Root directory paths separated by `&`.',
        defaultsTo: 'lib',
      )
      ..addOption(
        'subs',
        abbr: 's',
        help: 'Sub-directory paths separated by `&`.',
      )
      ..addOption(
        'patterns',
        abbr: 'p',
        help: 'Path patterns separated by `&`.',
      )
      ..addOption(
        'template',
        abbr: 't',
        help: 'Template file path.',
        defaultsTo: p.join(
          await getXyzGenLibPath(),
          'templates',
          'your_license_header_template.dart.md',
        ),
      ),
    onResults: (parser, results) {
      return BasicCmdAppArgs(
        templateFilePath: results['template'],
        rootPaths: splitArg(results['roots'])?.toSet(),
        subPaths: splitArg(results['subs'])?.toSet(),
        pathPatterns: splitArg(results['patterns'])?.toSet(),
      );
    },
    action: (parser, results, args) async {
      await generateLicenseHeaders(
        rootDirPaths: args.rootPaths ?? {},
        subDirPaths: args.subPaths ?? {},
        pathPatterns: args.pathPatterns ?? {},
        templateFilePath: args.templateFilePath!,
      );
    },
  );
}
