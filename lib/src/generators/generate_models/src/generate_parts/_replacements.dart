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

Map<String, String> _replacements({
  required Map<String, TypeCode> fields,
  required StringCaseType keyStringCaseType,
  required bool includeId,
  required bool includeArgs,
}) {
  final fields0 = fields.map((k, v) => MapEntry(k.toCamelCase(), v));
  final entries0 = fields0.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
  final vars = entries0.map((e) => e.key);
  final entries1 = vars.map((i) => MapEntry(i, fields0[i]));
  final nonNullableVars = vars.where((e) => !fields0[e]!.nullable);
  final keys = _getKeyNames(vars, keyStringCaseType);
  final consts = _getKeyConstNames(vars);

  final p = <Iterable>[
    // ___P0___
    vars.map((e) => "static const ${consts[e]} = '${keys[e]}';"),
    // ___P1___
    entries1.map((e) => 'dynamic _${e.key};'),
    // ___P2___
    [
      ...entries1
          .map((e) => '${e.value!.nullable ? '' : 'required '}${e.value?.getName()} ${e.key},'),
    ],
    // ___P3___
    [
      ...vars.map((e) => 'this._$e = $e;'),
    ],
    // ___P4___
    [
      ...entries1.map((e) => '${e.value?.nullableName} ${e.key},'),
    ],
    // ___P5___
    nonNullableVars.map((e) => 'assert($e != null);'),
    // ___P6___
    [
      ...vars.map((e) {
        return '..\$$e = otherData?[${consts[e]}]';
      }),
      ';',
    ],
    // ___P7___
    vars.map((e) {
      final keyConst = consts[e];
      return '$keyConst: this._$e,';
    }),
    // ___P8___

    vars.map((e) {
      return 'if (other._$e != null) { this.$e = other._$e; }';
    }),
    // ___P9___
    [],
    // ___P10___
    vars.map((e) {
      final parameter = fields0[e]!;
      final typeCode = parameter.value;
      final typeName = parameter.getName();
      final v0 = mapWithFromMappers(
        typeMappers: LooseTypeMappers.instance,
        fieldName: 'v',
        typeCode: typeCode,
      );
      var v1 = mapWithToMappers(
        typeMappers: LooseTypeMappers.instance,
        fieldName: 'this._$e',
        typeCode: typeCode,
      );
      return [
        '$typeName get $e => this._$e;',
        'dynamic get \$$e => ${parameter.nullable ? v1 : '($v1)!'};'
            'set $e($typeName v) => this.\$$e = v;',
        'set \$$e(v) => this._$e = $v0;',
        '',
      ].join('\n');
    }),
    // ___P11___
    [
      ...vars.map((e) => '$e: $e,'),
    ],
  ];

  final output = <String, String>{};
  for (var n = 0; n < p.length; n++) {
    output['___P${n}___'] = p[n].join('\n');
  }
  return output;
}
