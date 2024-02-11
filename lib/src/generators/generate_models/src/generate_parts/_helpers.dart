//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

part of '../generate.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Map<String, String> _getKeyNames(
  Iterable<String> parameterKeys,
  StringCaseType keyStringCaseType,
) {
  return Map.fromEntries(
    parameterKeys.map(
      (k) => MapEntry(
        k,
        () {
          switch (keyStringCaseType) {
            case StringCaseType.LOWER_SNAKE_CASE:
              return k.toSnakeCase();
            case StringCaseType.UPPER_SNAKE_CASE:
              return k.toUpperSnakeCase();
            case StringCaseType.KEBAB_CASE:
              return k.toKebabCase();
            case StringCaseType.UPPER_KEBAB_CASE:
              return k.toUpperKebabCase();
            case StringCaseType.CAMEL_CASE:
              return k.toCamelCase();
            case StringCaseType.PASCAL_CASE:
              return k.toPascalCase();
          }
        }(),
      ),
    ),
  );
}

Map<String, String> _getKeyConstNames(Iterable<String> parameterKeys) {
  return Map.fromEntries(
    parameterKeys.map(
      (e) => MapEntry(
        e,
        "K_${e.toSnakeCase().toUpperCase()}",
      ),
    ),
  );
}


