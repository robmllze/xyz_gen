//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// 🇽🇾🇿 & Dev
//
// Licencing details are in the LICENSE file in the root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

/// Strips the special syntax from [fieldType].
String stripSpecialSyntaxFromFieldType(String fieldType) {
  // Step 0: Remove all spaces from the input String.
  String $step0(String input) {
    return input.replaceAll(' ', '');
  }

  // Step 1: Remove the '@let' substring from the input String.
  String $step1(String input) {
    return input.replaceAll('@let', '');
  }

  // Step 2: Simplify expressions by retaining only the last word in sequences
  // that may include hyphen-separated prefixes.
  // Example: "LowerCase-String" becomes "String".
  String $step2(String input) {
    return input.replaceAllMapped(
      RegExp(r'(\b\w+-)*(\w+)\b'),
      (m) => m.group(2)!,
    );
  }

  // Step 3: Transform a specialized 'clean' format into a bracketed list format.
  // This changes annotations such as "Type@clean<SubType, AnotherType>" to
  // "Type[SubType, AnotherType]" for standardization.
  String $step3(String input) {
    final x = RegExp(r'\w+\@clean\<([\w\[\]\+]+\??)(,[\w\[\]\+]+\??)*\>');
    var output = input;
    while (true) {
      final group0 = x.firstMatch(output)?.group(0);
      if (group0 == null) break;
      final replacement = group0
          .replaceAll('@clean', '')
          .replaceAll('?', '')
          .replaceAll('<', '[')
          .replaceAll('>', ']')
          .replaceAll(',', '+');
      output = output.replaceAll(group0, replacement);
    }
    return output;
  }

  // Step 4: Reverse some transformations made in Step 3, converting
  // brackets back to angle brackets and pluses back to commas.
  // This is likely to restore generic type syntax closer to standard Dart or TypeScript formats.
  String step4(String input) {
    return input.replaceAll('[', '<').replaceAll(']', '>').replaceAll('+', ', ');
  }

  // Apply all transformations sequentially to the input String.
  var output = fieldType;
  output = $step0(fieldType);
  output = $step1(output);
  output = $step2(output);
  output = $step3(output);
  output = step4(output);
  return output;
}
