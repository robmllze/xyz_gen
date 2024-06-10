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

Map<String, String> _dartReplacements({
  required GenerateModel annotation,
  required Map<String, TypeCode> fields,
  required StringCaseType keyStringCaseType,
}) {
  final fields0 = fields.map((k, v) => MapEntry(k.toCamelCase(), v));
  final entries0 = fields0.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
  final vars = entries0.map((e) => e.key);
  final entries1 = vars.map((i) => MapEntry(i, fields0[i]));
  final nonNullableVars = vars.where((e) => !fields0[e]!.nullable);
  final keys = _getKeyNames(vars, keyStringCaseType);
  final consts = _getKeyConstNames(vars);
  return {
    '___P0___': vars.map((e) {
      return "static const ${consts[e]} = '${keys[e]}';";
    }),
    '___P1___': entries1.map((e) {
      return '${e.value?.nullableName} ${e.key};';
    }),
    '___P2___': entries1.map(
      (e) {
        return '${e.value!.nullable ? '' : 'required '}${e.value?.name} ${e.key},';
      },
    ),
    '___P3___': vars.map((e) {
      return '$e: $e,';
    }),
    '___P4___': entries1.map((e) {
      return 'this.${e.key},';
    }),
    '___P5___': nonNullableVars.map((e) {
      return 'assert($e != null);';
    }),
    '___P6___': [
      ...vars.map((e) {
        return '..\$$e = otherData${annotation.className != 'DataModel' ? '?[${consts[e]}]' : ''}';
      }),
      ';',
    ],
    '___P7___': vars.map((e) {
      return '${annotation.className != 'DataModel' ? '${consts[e]}: ' : '...'}this.\$$e,';
    }),
    '___P8___': vars.map((e) {
      return 'if (other.$e != null) { this.$e = other.$e!; }';
    }),
    '___P9___': vars.map((e) {
      final type = fields0[e]!;
      final typeCode = type.code;
      final typeName = type.name;
      final nullable = type.nullable;
      final v0 = mapWithFromMappers(
        typeMappers: DartLooseTypeMappers.instance,
        fieldName: 'v',
        typeCode: typeCode,
      );
      var v1 = mapWithToMappers(
        typeMappers: DartLooseTypeMappers.instance,
        fieldName: 'this.$e',
        typeCode: typeCode,
      );
      return [
        '  // $e.',
        '$typeName get ${e}Field => this.$e${nullable ? '' : '!'};',
        'set ${e}Field($typeName v) => this.$e = v;',
        '@protected',
        'dynamic get \$$e => $v1;',
        '@protected',
        'set \$$e(v) => this.$e = $v0;',
        '',
      ].join('\n');
    }),
  }.mapValues((e) => e.join('\n'));
}
