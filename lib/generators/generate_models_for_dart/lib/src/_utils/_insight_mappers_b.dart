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

import '/src/xyz/_index.g.dart' as xyz;

import '_insight_mapper_utils.dart';
import '_strip_special_syntax_from_field_type.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

final insightMappersB = [
  _InsightMapper(
    placeholder: PlaceholdersB.FIELD_DECLARATIONS_B,
    mapInsights: (insight) async {
      return dartFields(insight).map(
        (e) {
          final t = stripSpecialSyntaxFromFieldType(e.fieldType!);
          final f = e.fieldName!.toCamelCase();
          return '$t? $f;';
        },
      ).join('\n');
    },
  ),
  _InsightMapper(
    placeholder: PlaceholdersB.FIELD_ASSERTIONS,
    mapInsights: (insight) async {
      return dartFields(insight).map(
        (e) {
          final n = e.nullable;
          final f = e.fieldName!.toCamelCase();
          return n ? '' : 'assert(this.$f != null);';
        },
      ).join('\n');
    },
  ),
  _InsightMapper(
    placeholder: PlaceholdersB.FROM_JSON_B,
    mapInsights: (insight) async {
      return '${dartFields(insight).map(
        (e) {
          final k = 'K_${e.fieldName!.toUpperSnakeCase()}';
          final f = e.fieldName!.toCamelCase();
          return '..\$$f = otherData?[$k]';
        },
      ).join('\n')};';
    },
  ),
  _InsightMapper(
    placeholder: PlaceholdersB.TO_JSON_B,
    mapInsights: (insight) async {
      return dartFields(insight).map(
        (e) {
          final k = 'K_${e.fieldName!.toUpperSnakeCase()}';
          final f = e.fieldName!.toCamelCase();
          return '$k: this.\$$f,';
        },
      ).join('\n');
    },
  ),
  _InsightMapper(
    placeholder: PlaceholdersB.UPDATE_WITH_JSON_B,
    mapInsights: (insight) async {
      return dartFields(insight).map(
        (e) {
          final f = e.fieldName!.toCamelCase();
          return 'if (other.$f != null) { this.$f = other.$f!; }';
        },
      ).join('\n');
    },
  ),
  _InsightMapper(
    placeholder: PlaceholdersB.GETTERS_AND_SETTERS_B,
    mapInsights: (insight) async {
      return dartFields(insight).map(
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

enum PlaceholdersB {
  FIELD_DECLARATIONS_B,
  FIELD_ASSERTIONS,
  FROM_JSON_B,
  TO_JSON_B,
  UPDATE_WITH_JSON_B,
  GETTERS_AND_SETTERS_B;
}

typedef _InsightMapper = xyz.InsightMapper<xyz.ClassInsight<GenerateModel>, Enum>;
