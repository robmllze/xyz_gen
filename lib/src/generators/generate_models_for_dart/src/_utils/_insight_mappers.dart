//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// 🇽🇾🇿 & Dev
//
// Licencing details are in the LICENSE file in the root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:xyz_gen_annotations/xyz_gen_annotations.dart';
import 'package:xyz_utils/xyz_utils_non_web.dart' as utils;

import '/src/xyz/_all_xyz.g.dart' as xyz;

import '_strip_special_syntax_from_field_type.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

final insightMappers = [
  _InsightMapper(
    placeholder: Placeholders.SUPER_CLASS,
    mapInsights: (insight) async {
      return insight.annotation.shouldInherit ? insight.className : 'Model';
    },
  ),
  _InsightMapper(
    placeholder: Placeholders.CLASS_FILE_NAME,
    mapInsights: (insight) async {
      return insight.fileName;
    },
  ),
  _InsightMapper(
    placeholder: Placeholders.CLASS,
    mapInsights: (insight) async {
      return insight.annotation.className ?? insight.className.replaceFirst(RegExp(r'^[_$]+'), '');
    },
  ),
  _InsightMapper(
    placeholder: Placeholders.SUPER_CONSTRUCTOR,
    mapInsights: (insight) async {
      return insight.annotation.shouldInherit
          ? insight.annotation.inheritanceConstructor?.nullIfEmpty != null
              ? ': super.${insight.annotation.inheritanceConstructor}()'
              : ''
          : '';
    },
  ),
  _InsightMapper(
    placeholder: Placeholders.P0,
    mapInsights: (insight) async {
      return _dartFields(insight).map(
        (e) {
          final k = 'K_${e.fieldName!.toUpperSnakeCase()}';
          final c = _stringCaseType(insight).convert(e.fieldName!);
          return "static const $k = '$c';";
        },
      ).join('\n');
    },
  ),
  _InsightMapper(
    placeholder: Placeholders.P1,
    mapInsights: (insight) async {
      return _dartFields(insight).map(
        (e) {
          final t = stripSpecialSyntaxFromFieldType(e.fieldType!);
          final f = e.fieldName!.toCamelCase();
          return '$t? $f;';
        },
      ).join('\n');
    },
  ),
  _InsightMapper(
    placeholder: Placeholders.P2,
    mapInsights: (insight) async {
      return _dartFields(insight).map(
        (e) {
          final t = stripSpecialSyntaxFromFieldType(e.fieldType!);
          final n = e.nullable;
          final f = e.fieldName!.toCamelCase();
          return '${n ? '' : 'required'} $t${n ? '?' : ''} $f,';
        },
      ).join('\n');
    },
  ),
  _InsightMapper(
    placeholder: Placeholders.P3,
    mapInsights: (insight) async {
      return _dartFields(insight).map(
        (e) {
          final f = e.fieldName!.toCamelCase();
          return '$f: $f,';
        },
      ).join('\n');
    },
  ),
  _InsightMapper(
    placeholder: Placeholders.P4,
    mapInsights: (insight) async {
      return _dartFields(insight).map(
        (e) {
          final f = e.fieldName!.toCamelCase();
          return 'this.$f,';
        },
      ).join('\n');
    },
  ),
  _InsightMapper(
    placeholder: Placeholders.P5,
    mapInsights: (insight) async {
      return _dartFields(insight).map(
        (e) {
          final n = e.nullable;
          final f = e.fieldName!.toCamelCase();
          return n ? '': 'assert(this.$f != null);';
        },
      ).join('\n');
    },
  ),
  _InsightMapper(
    placeholder: Placeholders.P6,
    mapInsights: (insight) async {
      return '${_dartFields(insight).map(
        (e) {
          final k = 'K_${e.fieldName!.toUpperSnakeCase()}';
          final f = e.fieldName!.toCamelCase();
          return '..\$$f = otherData${insight.className != 'DataModel' ? '?[$k]' : ''}';
        },
      ).join('\n')};';
    },
  ),
  _InsightMapper(
    placeholder: Placeholders.P7,
    mapInsights: (insight) async {
      return _dartFields(insight).map(
        (e) {
          final k = 'K_${e.fieldName!.toUpperSnakeCase()}';
          final f = e.fieldName!.toCamelCase();
          return '${insight.className != 'DataModel' ? '$k: ' : '...'}this.\$$f,';
        },
      ).join('\n');
    },
  ),
  _InsightMapper(
    placeholder: Placeholders.P8,
    mapInsights: (insight) async {
      return _dartFields(insight).map(
        (e) {
          final f = e.fieldName!.toCamelCase();
          return 'if (other.$f != null) { this.$f = other.$f!; }';
        },
      ).join('\n');
    },
  ),
  _InsightMapper(
    placeholder: Placeholders.P9,
    mapInsights: (insight) async {
      return _dartFields(insight).map(
        (e) {
          final f = e.fieldName!.toCamelCase();
          final x = e.fieldTypeCode!;
          final s = stripSpecialSyntaxFromFieldType(x);
          final n = e.nullable;
          final a = xyz.DartTypeCodeMapper(xyz.DartLooseTypeMappers.instance.toMappers).map(
            fieldName: 'this.$f',
            fieldTypeCode: x,
          );
          final b = xyz.DartTypeCodeMapper(xyz.DartLooseTypeMappers.instance.fromMappers).map(
            fieldName: 'v',
            fieldTypeCode: x,
          );
          return [
            '  // $f.',
            '$s get ${f}Field => this.$f${n ? '' : '!'};',
            'set ${f}Field($s v) => this.$f = v;',
            '@protected',
            'dynamic get \$$f => $a;',
            '@protected',
            'set \$$f(v) => this.$f = $b;',
            '',
          ].join('\n');
        },
      ).join('\n');
    },
  ),
];

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

enum Placeholders {
  SUPER_CLASS,
  CLASS,
  SUPER_CONSTRUCTOR,
  CLASS_FILE_NAME,
  P0,
  P1,
  P2,
  P3,
  P4,
  P5,
  P6,
  P7,
  P8,
  P9;
}

Iterable<xyz.DartField> _dartFields(_ClassInsight insight) {
  return insight.annotation.fields.map((e) {
    e.runtimeType;
    return xyz.DartField.fromRecord(e);
  }).nonNulls;
}

StringCaseType _stringCaseType(_ClassInsight insight) {
  return StringCaseType.values.valueOf(insight.annotation.keyStringCase) ??
      StringCaseType.LOWER_SNAKE_CASE;
}

typedef _ClassInsight = xyz.ClassInsight<GenerateModel>;

typedef _InsightMapper = xyz.InsightMapper<_ClassInsight, Placeholders>;
