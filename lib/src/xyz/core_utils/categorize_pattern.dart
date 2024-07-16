//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// 🇽🇾🇿 & Dev
//
// Licencing details are in the LICENSE file in the root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

final class CategorizedPattern<TCategory extends Enum> {
  //
  //
  //

  final String pattern;
  final TCategory? category;

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

  static TCategory? categorize<TCategory extends Enum>(
    String value,
    Iterable<CategorizedPattern<TCategory>> patterns,
  ) {
    for (final e in patterns) {
      final expression = RegExp(e.pattern, caseSensitive: false);
      if (expression.hasMatch(value)) {
        return e.category;
      }
    }
    return null;
  }

  //
  //
  //

  static const DEFAULT = _DefaultCategory.DEFAULT;
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

enum _DefaultCategory {
  DEFAULT,
}
