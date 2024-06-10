//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// 🇽🇾🇿 & Dev
//
// Licencing details are in the LICENSE file in the root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:args/args.dart';
import 'package:path/path.dart' as p;

import '/_common.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// A command line app for generating models.
Future<void> generateModelsApp(List<String> arguments) async {
  await basicCmdAppHelper<BasicCmdAppArgs>(
    appTitle: 'XYZ Gen - Generate Models',
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
        defaultsTo: 'models',
      )
      ..addOption(
        'patterns',
        abbr: 'p',
        help: 'Path patterns separated by `&`.',
      )
      ..addOption(
        'templates',
        abbr: 't',
        help: 'Template file paths separated by `&`..',
        defaultsTo: p.join(
          await getXyzGenLibPath(),
          'templates',
          'your_model_template.dart.md',
        ),
      )
      ..addOption(
        'dart-sdk',
        help: 'Dart SDK path.',
      ),
    onResults: (parser, results) {
      return BasicCmdAppArgs(
        fallbackDartSdkPath: results['dart-sdk'],
        templateFilePaths: splitArg(results['templates'])?.toSet(),
        rootPaths: splitArg(results['roots'])?.toSet(),
        subPaths: splitArg(results['subs'])?.toSet(),
        pathPatterns: splitArg(results['patterns'])?.toSet(),
      );
    },
    action: (parser, results, args) async {
      await generateModels(
        fallbackDartSdkPath: args.fallbackDartSdkPath,
        rootDirPaths: args.rootPaths!,
        subDirPaths: args.subPaths ?? const {},
        pathPatterns: args.pathPatterns ?? const {},
        templateFilePaths: args.templateFilePaths ?? const {},
      );
    },
  );
}
