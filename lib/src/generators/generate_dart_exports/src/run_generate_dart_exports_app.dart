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
import 'package:path/path.dart' as p;

import '/src/xyz/_all_xyz.g.dart' as xyz;

import '_args_checker.dart';
import '_generate.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// A command line app for generating Dart export files for the provided
/// directories.
Future<void> runGenerateDartExportsApp(List<String> args) async {
  await xyz.runCommandLineApp(
    title: '🇽🇾🇿  Generate Dart Exports',
    description:
        'A command line app for generating Dart export files for the provided directories.',
    args: args,
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
      ),
    onResults: (parser, results) {
      return ArgsChecker(
        rootPaths: results['roots'],
        subPaths: results['subs'],
        pathPatterns: results['patterns'],
        templateFilePaths: results['template'],
      );
    },
    action: (parser, results, args) async {
      await generateExports<_Placeholders>(
        lang: xyz.Lang.DART,
        statementBuilder: {
          _Placeholders.PUBLIC_EXPORTS: (relativeFilePath) => "export '$relativeFilePath';",
          _Placeholders.PRIVATE_EXPORTS: (relativeFilePath) => "// export '$relativeFilePath';",
          _Placeholders.GENERATED_EXPORTS: (relativeFilePath) => "// export '$relativeFilePath';",
        },
        statusBuilder: (exportFilePath) {
          final rootDirPath = p.normalize(p.join(Directory.current.path, '..'));
          final exportFilePathFromRoot = p.relative(exportFilePath, from: rootDirPath);

          final isGenFile = xyz.Lang.DART.isValidGenFilePath(exportFilePath);
          if (isGenFile) {
            return _Placeholders.GENERATED_EXPORTS;
          }
          final isPrivateFile = p.split(exportFilePathFromRoot).any((part) => part.startsWith('_'));
          if (isPrivateFile) {
            return _Placeholders.PRIVATE_EXPORTS;
          }
          return _Placeholders.PUBLIC_EXPORTS;
        },
        placeholderBuilder: (placeholder) {
          switch (placeholder) {
            case _Placeholders.PUBLIC_EXPORTS:
              return '// No public files in directory.';
            case _Placeholders.PRIVATE_EXPORTS:
              return '// No private files in directory.';
            case _Placeholders.GENERATED_EXPORTS:
              return '// No generated files in directory.';
          }
        },
        templateFilePath: args.templateFilePaths!.first,
        rootDirPaths: args.rootPaths!,
        subDirPaths: args.subPaths ?? const {},
        pathPatterns: args.pathPatterns ?? const {},
      );
    },
  );
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

enum _Placeholders {
  PUBLIC_EXPORTS,
  PRIVATE_EXPORTS,
  GENERATED_EXPORTS;
}
