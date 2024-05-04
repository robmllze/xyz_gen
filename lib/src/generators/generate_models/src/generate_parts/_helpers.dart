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
  final fieldType = _stdFieldType(input);
  var nullable = _stdNullable(input);

  if (nullable != true && fieldName.endsWith('?')) {
    fieldName = fieldName.substring(0, fieldName.length - 1);
    nullable = true;
  }
  if (fieldType == 'dynamic') {
    nullable = false;
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
    try {
      return input.$1 as String;
    } catch (_) {
      final r = Random().nextInt(99999 - 10000) + 10000;
      return 'field_$r';
    }
  }
}

String _stdFieldType(dynamic input) {
  try {
    return input.fieldType as String;
  } catch (_) {
    try {
      return input.$2 as String;
    } catch (_) {
      return 'Null';
    }
  }
}

bool? _stdNullable(dynamic input) {
  try {
    return input.nullable as bool?;
  } catch (_) {
    try {
      return input.$3 as bool?;
    } catch (_) {
      return true;
    }
  }
}
