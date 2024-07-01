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

Map<String, String> _typescriptReplacements({
  required GenerateModel annotation,
  required Map<String, TypeCode> fields,
  required StringCaseType keyStringCaseType,
}) {
  final fields0 = fields.map((k, v) => MapEntry(k.toCamelCase(), v));
  final entries0 = fields0.entries.toList()
    ..sort((a, b) => a.key.compareTo(b.key));
  final vars = entries0.map((e) => e.key);
  final entries1 = vars.map((i) => MapEntry(i, fields0[i]));
  // final nonNullableVars = vars.where((e) => !fields0[e]!.nullable);
  // final keys = _getKeyNames(vars, keyStringCaseType);
  // final consts = _getKeyConstNames(vars);

  return {
    '___P0___': entries1.map((e) {
      return '  ${e.key}: ${e.value?.toTypescriptTypeString() ?? 'any'};';
    }),
    '___P1___': entries1.map((e) {
      return '    ${e.key} = null,';
    }),
    '___P2___': entries1.map((e) {
      return '    ${e.key}?: ${e.value?.toTypescriptTypeString() ?? 'any'},';
    }),
    '___P3___': entries1.map((e) {
      return '    this.${e.key} = ${e.key};';
    }),
    '___P4___': entries1.map((e) {
      return "      ['${keyStringCaseType.convert(e.key)}', this.${e.key}],";
    }),
    '___P5___': entries1.map((e) {
      return "      ${e.key}: map.get('${keyStringCaseType.convert(e.key)}'),";
    }),
    '___P6___': entries1.map((e) {
      return "      '${keyStringCaseType.convert(e.key)}': this.${e.key},";
    }),
    '___P7___': entries1.map((e) {
      return "      ${e.key}: obj['${keyStringCaseType.convert(e.key)}'] as ${e.value?.toTypescriptTypeString() ?? 'any'},";
    }),
  }.mapValues((e) => e.join('\n'));
}
