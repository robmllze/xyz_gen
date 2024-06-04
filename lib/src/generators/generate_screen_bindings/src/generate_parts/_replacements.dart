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

String _ip0(Set<Record> internalParameters) {
  final a = internalParameters.whereType<TStdField>().map((e) {
    final fieldName = e.fieldName;
    final fieldKey = fieldName.toSnakeCase();
    final fieldType = e.fieldType;
    final nullable = e.nullable != false;
    final exclamationMark = nullable ? '' : '!';
    final questionMark = nullable ? '?' : '';
    final fieldK = 'K_${fieldKey.toUpperCase()}';
    return [
      '/// Key corresponding to the value `$fieldName`',
      "static const $fieldK = '$fieldKey';",
      '/// Returns the **internal parameter** with the key `$fieldKey`',
      '/// or [$fieldK].',
      '$fieldType$questionMark get $fieldName => super.arg<$fieldType>($fieldK)$exclamationMark;',
    ].join('\n');
  }).toList()
    ..sort();
  return a.isNotEmpty ? a.join('\n') : '';
}

String _ip1(Set<Record> internalParameters) {
  final a = internalParameters.whereType<TStdField>().map((e) {
    final fieldName = e.fieldName;
    final fieldType = e.fieldType;
    final nullable = e.nullable != false;
    final questionMark = nullable ? '?' : '';
    final required = nullable ? '' : 'required ';
    return '$required$fieldType$questionMark $fieldName,';
  }).toList()
    ..sort();
  return a.isNotEmpty ? a.join('\n') : '';
}

String _ip2(Set<Record> internalParameters) {
  final a = internalParameters.whereType<TStdField>().map((e) {
    final fieldName = e.fieldName;
    final fieldKey = fieldName.toSnakeCase();
    final fieldK = 'K_${fieldKey.toUpperCase()}';
    return '$fieldK: $fieldName,';
  }).toList()
    ..sort();
  return a.isNotEmpty ? a.join('\n') : '';
}

String _qp0(Set<Record> queryParameters) {
  final a = queryParameters.whereType<TStdField>().map((e) {
    final fieldName = e.fieldName;
    final nullable = e.nullable != false;
    final fieldKey = fieldName.toSnakeCase();
    final fieldK = 'K_${fieldKey.toUpperCase()}';
    final exclamationMark = nullable ? '' : '!';
    final questionMark = nullable ? '?' : '';
    return [
      '/// Key corresponding to the value `$fieldName`',
      // ignore: unnecessary_string_escapes
      "static const $fieldK = '$fieldKey';",
      '/// Returns the URI **query parameter** with the key `$fieldKey`',
      '/// or [$fieldK].',
      'String$questionMark get $fieldName => super.arg<String>($fieldK)$exclamationMark;',
    ].join('\n');
  }).toList()
    ..sort();
  return a.isNotEmpty ? a.join('\n') : '';
}

String _qp1(Set<Record> queryParameters) {
  final a = queryParameters.whereType<TStdField>().map((e) {
    final fieldName = e.fieldName;
    final nullable = e.nullable != false;
    return "${nullable ? "String?" : "required String"} $fieldName,";
  }).toList()
    ..sort();
  return a.isNotEmpty ? a.join('\n') : '';
}

String _qp2(Set<Record> queryParameters) {
  final a = queryParameters.whereType<TStdField>().map((e) {
    final fieldName = e.fieldName;
    final nullable = e.nullable != false;
    final fieldKey = fieldName.toSnakeCase();
    final fieldK = 'K_${fieldKey.toUpperCase()}';
    return "${nullable ? "if ($fieldName != null) " : ""}$fieldK: $fieldName,";
  }).toList()
    ..sort();
  return a.isNotEmpty ? a.join('\n') : '';
}
