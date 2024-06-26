//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// 🇽🇾🇿 & Dev
//
// Licencing details are in the LICENSE file in the root directory.
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
            case StringCaseType.LOWER_KEBAB_CASE:
              return k.toKebabCase();
            case StringCaseType.UPPER_KEBAB_CASE:
              return k.toUpperKebabCase();
            case StringCaseType.CAMEL_CASE:
              return k.toCamelCase();
            case StringCaseType.PASCAL_CASE:
              return k.toPascalCase();
            case StringCaseType.LOWER_DOT_CASE:
              return k.toLowerDotCase();
            case StringCaseType.UPPER_DOT_CASE:
              return k.toUpperDotCase();
            case StringCaseType.PATH_CASE:
              return k.toPathCase();
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
        'K_${e.toSnakeCase().toUpperCase()}',
      ),
    ),
  );
}

TStdField _stdField(dynamic input) {
  var fieldName = _stdFieldName(input);
  var fieldType = _stdFieldType(input);
  final nullable = fieldType == 'dynamic'
      ? false
      : _stdNullable(input) ??
          fieldName.endsWith('?') || fieldType.endsWith('?');
  if (fieldName.endsWith('?')) {
    fieldName = fieldName.substring(0, fieldName.length - 1);
  }
  if (fieldType.endsWith('?')) {
    fieldType = fieldType.substring(0, fieldType.length - 1);
  }
  return (
    fieldName: fieldName,
    fieldType: fieldType,
    nullable: nullable,
  );
}

typedef TStdField = ({String fieldName, String fieldType, bool? nullable});

String _stdFieldName(dynamic input) {
  try {
    return input.fieldName as String;
  } catch (_) {
    return input.$1 as String;
  }
}

String _stdFieldType(dynamic input) {
  try {
    return input.fieldType as String;
  } catch (_) {
    return input.$2 as String;
  }
}

bool? _stdNullable(dynamic input) {
  try {
    return input.nullable as bool?;
  } catch (_) {
    try {
      return input.$3 as bool?;
    } catch (_) {
      return null;
    }
  }
}
