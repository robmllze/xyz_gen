//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// 🇽🇾🇿 & Dev
//
// Licencing details are in the LICENSE file in the root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

final class CategorizedPattern {
  //
  //
  //

  final String pattern;
  final dynamic category;

  //
  //
  //

  const CategorizedPattern({
    required this.pattern,
    this.category,
  });

  //
  //
  //

  RegExp get regExp => RegExp(this.pattern);

  //
  //
  //

  static dynamic categorize(String value, Iterable<CategorizedPattern> patterns) {
    for (final e in patterns) {
      final expression = RegExp(e.pattern);
      if (expression.hasMatch(value)) {
        return e.category;
      }
    }
    return null;
  }
}
