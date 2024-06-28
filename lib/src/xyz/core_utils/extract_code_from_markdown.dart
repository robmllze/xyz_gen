//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// 🇽🇾🇿 & Dev
//
// Licencing details are in the LICENSE file in the root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

/// Extracts all code for the language [langCode] from some Markdown [content].
String extractCodeFromMarkdown(
  String content, {
  String? langCode,
}) {
  final snippets = extractCodeSnippetsFromMarkdown(
    content,
    langCode: langCode,
  );
  final code = snippets.join('\n');
  return code;
}

/// Extracts all code snippets for the language [langCode] from some Markdown [content].
List<String> extractCodeSnippetsFromMarkdown(
  String content, {
  String? langCode,
}) {
  final dartCodeRegex = RegExp('```(${langCode ?? '[^\\n]+'})\\n(.*?)```', dotAll: true);
  final matches = dartCodeRegex.allMatches(content);
  final snippets = matches.map((e) => e.group(2)?.trim() ?? '').toList();
  return snippets;
}
