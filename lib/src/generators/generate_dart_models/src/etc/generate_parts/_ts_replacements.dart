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

Map<String, String> _typescriptReplacements({
  required GenerateModel annotation,
  required Map<String, DartTypeCode> fields,
  required utils.StringCaseType keyStringCaseType,
}) {
  final fields0 = fields.map((k, v) => MapEntry(k.toCamelCase(), v));
  final entries0 = fields0.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
  final vars = entries0.map((e) => e.key);
  final entries1 = vars.map((i) => MapEntry(i, fields0[i]));
  // final nonNullableVars = vars.where((e) => !fields0[e]!.nullable);
  // final keys = _getKeyNames(vars, keyStringCaseType);
  // final consts = _getKeyConstNames(vars);

  return {
    '___P0___': entries1.map((e) {
      final n = e.key;
      final t = e.value!;
      final t1 = t.toTypeScriptTypeCode();
      return '  $n: ${t.toTypeScriptTypeString() ?? t1.name};';
    }),
    '___P1___': entries1.map((e) {
      final n = e.key;
      final t = e.value!;
      return '    $n${t.nullable ? ' = null' : ''},';
    }),
    '___P2___': entries1.map((e) {
      final n = e.key;
      final t = e.value!;
      final t1 = t.toTypeScriptTypeCode();
      return '    $n${t.nullable ? '?' : ''}: ${t.toTypeScriptTypeString() ?? t1.name},';
    }),
    '___P3___': entries1.map((e) {
      return '    this.${e.key} = ${e.key};';
    }),
    // toMap
    '___P4___': entries1.map((e) {
      final n = e.key;
      final t = e.value!;
      final isModel = t.nonNullableName.startsWith('Model') || t.nullableName.startsWith('Model');
      if (isModel) {
        return "      ['${keyStringCaseType.convertString(n)}', this.$n?.toMap()],";
      } else {
        return "      ['${keyStringCaseType.convertString(n)}', this.$n],";
      }
    }),
    // fromMap
    '___P5___': entries1.map((e) {
      final n = e.key;
      final t = e.value!;
      final isModel = t.nonNullableName.startsWith('Model') || t.nullableName.startsWith('Model');
      if (isModel) {
        return [
          '      $n: (() => {',
          "        const v = map.get('${keyStringCaseType.convertString(n)}');",
          '        return v != null ? ${t.nonNullableName}.fromMap(v): v;',
          '      })(),',
        ].join('\n');
      } else {
        return "      $n: map.get('${keyStringCaseType.convertString(n)}'),";
      }
    }),
    // toObject
    '___P6___': entries1.map((e) {
      final n = e.key;
      final t = e.value!;
      final isModel = t.nonNullableName.startsWith('Model') || t.nullableName.startsWith('Model');
      if (isModel) {
        return "      '${keyStringCaseType.convertString(n)}': this.$n?.toObject(),";
      } else {
        return "      '${keyStringCaseType.convertString(n)}': this.$n,";
      }
    }),
    // fromObject
    '___P7___': entries1.map((e) {
      final n = e.key;
      final t = e.value!;
      final isModel = t.nonNullableName.startsWith('Model') || t.nullableName.startsWith('Model');
      if (isModel) {
        return [
          '      $n: (() => {',
          "        const v = obj['${keyStringCaseType.convertString(n)}'];",
          '        return v != null ? ${t.nonNullableName}.fromObject(v): v;',
          '      })(),',
        ].join('\n');
      } else {
        return "      $n: obj['${keyStringCaseType.convertString(n)}'],";
      }
      //return "      $n: obj['${keyStringCaseType.convertString(n)}'] as ${t.toTypeScriptTypeString() ?? 'any'},";
    }),
  }.mapValues((e) => e.join('\n'));
}
