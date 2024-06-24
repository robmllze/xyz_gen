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

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Returns a list of all code snippets for the language [lang] from a markdown
/// file at [filePath].
Future<List<String>> readCodeSnippetsFromMarkdownFile(
  String filePath, {
  String lang = '[^\\n]+',
}) async {
  final isMarkdownFile = filePath.toLowerCase().endsWith('.md');
  if (!isMarkdownFile) {
    throw Exception('The path "$filePath" does not refer to a file with a .md extension.');
  }
  final file = File(filePath);
  final input = await file.readAsString();
  final dartCodeRegex = RegExp('```($lang)\\n(.*?)```', dotAll: true);
  final matches = dartCodeRegex.allMatches(input);
  final snippets = matches.map((e) => e.group(2)?.trim() ?? '').toList();
  return snippets;
}
