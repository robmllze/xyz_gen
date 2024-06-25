//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// 🇽🇾🇿 & Dev
//
// Licencing details are in the LICENSE file in the root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

part of '../../_generate.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Map<String, String> _getKeyNames(
  Iterable<String> parameterKeys,
  utils.StringCaseType keyStringCaseType,
) {
  return Map.fromEntries(
    parameterKeys.map(
      (k) => MapEntry(
        k,
        () {
          switch (keyStringCaseType) {
            case utils.StringCaseType.LOWER_SNAKE_CASE:
              return k.toSnakeCase();
            case utils.StringCaseType.UPPER_SNAKE_CASE:
              return k.toUpperSnakeCase();
            case utils.StringCaseType.LOWER_KEBAB_CASE:
              return k.toKebabCase();
            case utils.StringCaseType.UPPER_KEBAB_CASE:
              return k.toUpperKebabCase();
            case utils.StringCaseType.CAMEL_CASE:
              return k.toCamelCase();
            case utils.StringCaseType.PASCAL_CASE:
              return k.toPascalCase();
            case utils.StringCaseType.LOWER_DOT_CASE:
              return k.toLowerDotCase();
            case utils.StringCaseType.UPPER_DOT_CASE:
              return k.toUpperDotCase();
            case utils.StringCaseType.PATH_CASE:
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
