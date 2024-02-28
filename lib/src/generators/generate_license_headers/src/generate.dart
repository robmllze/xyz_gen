//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// X|Y|Z & Dev 
//
// Copyright Ⓒ Robert Mollentze, xyzand.dev
// 
// Licensing details can be found in the LICENSE file in the root directory.
// 
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:path/path.dart' as p;

import '/_common.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> generateLicenseHeaders({
  Set<String> rootDirPaths = const {},
  Set<String> subDirPaths = const {},
  Set<String> pathPatterns = const {},
  required String templateFilePath,
}) async {
  final template =
      (await readSnippetsFromMarkdownFile(templateFilePath)).join("\n");
  for (final dirPath in combinePathSets([rootDirPaths, subDirPaths])) {
    Iterable fileResults = await findFiles(
      dirPath,
      extensions: const {},
      pathPatterns: pathPatterns,
      onFileFound: (_, __, filePath) async =>
          !isGeneratedDartFilePath(filePath),
    );
    final templateLangFileExt =
        p.extension(templateFilePath, 2).replaceAll(".md", "").toLowerCase();
    fileResults = fileResults.where((e) => e.extension == templateLangFileExt);
    for (final result in fileResults) {
      await _generateForFile(result, template);
    }
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> _generateForFile(FindFileResult result, String template) async {
  final filePath = result.filePath;
  final commentStarter = langFileCommentStarters[result.extension] ?? "//";
  final lines = (await readFileAsLines(filePath))!;
  if (lines.isNotEmpty) {
    var n = 0;
    for (n; n < lines.length; n++) {
      final line = lines[n].trim();
      if (line.isNotEmpty && !line.startsWith(commentStarter)) {
        break;
      }
    }
    final withoutHeader = lines.sublist(n).join("\n");
    final withHeader = "${template.trim()}\n\n$withoutHeader";
    printGreen("Generated license header for `${getBaseName(filePath)}`");
    await writeFile(filePath, withHeader);
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

final langFileCommentStarters = {
  ".ada": "--", // Ada
  ".awk": "#", // AWK
  ".bat": "REM ", // Batch
  ".cfg": "#", // Configuration files
  ".clj": ";", // Clojure
  ".cob": "*>", // COBOL
  ".erl": "%", // Erlang
  ".exs": "#", // Elixir
  ".f90": "!", // Fortran
  ".fish": "#", // Fish Shell
  ".hs": "--", // Haskell
  ".ini": ";", // INI configuration files
  ".jsonc": "//", // JSONC
  ".lisp": ";", // Lisp
  ".lua": "--", // Lua
  ".m": "%", // MATLAB and Octave
  ".pl": "#", // Perl
  ".ps1": "#", // PowerShell
  ".py": "#", // Python
  ".r": "#", // R
  ".rb": "#", // Ruby
  ".rst": "..", // reStructuredText, comment blocks
  ".scm": ";", // Scheme
  ".sed": "#", // SED
  ".sh": "#", // Bash
  ".sql": "--", // SQL
  ".tcl": "#", // TCL
  ".tex": "%", // LaTeX documents
  ".vbs": "'", // VBScript
  ".vim": "\"", // Vim script
  ".yaml": "#", // YAML
  ".zsh": "#", // Zsh
};