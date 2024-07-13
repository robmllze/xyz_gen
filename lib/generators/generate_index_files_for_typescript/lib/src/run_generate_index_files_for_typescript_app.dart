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

import '/src/xyz/_index.g.dart' as xyz;

import 'generate_index_files_for_typescript.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// A command line app for generating index files for TypeScript from directories.
/// The [args] are interpreted and passed to [generateIndexFilesForTypeScript].
Future<void> runGenerateIndexFilesForTypeScriptApp(List<String> args) async {
  await xyz.runCommandLineApp(
    title: '🇽🇾🇿  Generate Index Files for TypeScript',
    description:
        'A command line app for generating TypeScript index files for the provided directories.',
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
        help: 'Root directory paths of source files separated by `&`.',
        defaultsTo: 'lib',
      )
      ..addOption(
        'subs',
        abbr: 's',
        help: 'Sub-directory paths of source files separated by `&`.',
      )
      ..addOption(
        'patterns',
        abbr: 'p',
        help: 'Path patterns for source files separated by `&`.',
      )
      ..addOption(
        'templates',
        abbr: 't',
        help: 'Root directory paths of templates separated by `&`.',
      ),
    onResults: (parser, results) {
      return _ArgsChecker(
        rootPaths: results['roots'],
        subPaths: results['subs'],
        pathPatterns: results['patterns'],
        templateFilePaths: results['templates'],
      );
    },
    action: (parser, results, args) async {
      await generateIndexFilesForTypeScript(
        templatesRootDirPaths: args.templatesRootDirPaths!,
        rootDirPaths: args.rootPaths!,
        subDirPaths: args.subPaths ?? const {},
        pathPatterns: args.pathPatterns ?? const {},
      );
    },
  );
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class _ArgsChecker extends xyz.ValidArgsChecker {
  //
  //
  //

  final Set<String>? templatesRootDirPaths;
  final Set<String>? rootPaths;
  final Set<String>? subPaths;
  final Set<String>? pathPatterns;

  //
  //
  //

  _ArgsChecker({
    required dynamic templateFilePaths,
    required dynamic rootPaths,
    required dynamic subPaths,
    required dynamic pathPatterns,
  })  : this.templatesRootDirPaths = xyz.splitArg(templateFilePaths)?.toSet(),
        this.rootPaths = xyz.splitArg(rootPaths)?.toSet(),
        this.subPaths = xyz.splitArg(subPaths)?.toSet(),
        this.pathPatterns = xyz.splitArg(pathPatterns)?.toSet();

  //
  //
  //

  @override
  List get args => [
        this.templatesRootDirPaths,
        this.rootPaths,
        if (this.subPaths != null) this.subPaths,
        if (this.pathPatterns != null) this.pathPatterns,
      ];
}
