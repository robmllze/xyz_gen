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

final insightMappersA = [
  _InsightMapper(
    placeholder: PlaceholdersA.SUPER_CLASS,
    mapInsights: (insight) async {
      return insight.annotation.shouldInherit ? insight.className : 'Model';
    },
  ),
  _InsightMapper(
    placeholder: PlaceholdersA.CLASS_FILE_NAME,
    mapInsights: (insight) async {
      return insight.fileName;
    },
  ),
  _InsightMapper(
    placeholder: PlaceholdersA.CLASS,
    mapInsights: (insight) async {
      return insight.annotation.className ?? insight.className.replaceFirst(RegExp(r'^[_$]+'), '');
    },
  ),
  _InsightMapper(
    placeholder: PlaceholdersA.SUPER_CONSTRUCTOR,
    mapInsights: (insight) async {
      return insight.annotation.shouldInherit
          ? insight.annotation.inheritanceConstructor?.nullIfEmpty != null
              ? ': super.${insight.annotation.inheritanceConstructor}()'
              : ''
          : '';
    },
  ),
  _InsightMapper(
    placeholder: PlaceholdersA.STATIC_KEY_NAMES,
    mapInsights: (insight) async {
      return dartFields(insight).map(
        (e) {
          final k = 'K_${e.fieldName!.toUpperSnakeCase()}';
          final c = stringCaseType(insight).convert(e.fieldName!);
          return "static const $k = '$c';";
        },
      ).join('\n');
    },
  ),
  _InsightMapper(
    placeholder: PlaceholdersA.FIELD_DECLARATIONS_A,
    mapInsights: (insight) async {
      return dartFields(insight).map(
        (e) {
          final t = stripSpecialSyntaxFromFieldType(e.fieldType!);
          final f = e.fieldName!.toCamelCase();
          return 'final $t? $f;';
        },
      ).join('\n');
    },
  ),
  _InsightMapper(
    placeholder: PlaceholdersA.PARAMS_A1,
    mapInsights: (insight) async {
      return dartFields(insight).map(
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
    placeholder: PlaceholdersA.ARGS_A,
    mapInsights: (insight) async {
      return dartFields(insight).map(
        (e) {
          final f = e.fieldName!.toCamelCase();
          return '$f: $f,';
        },
      ).join('\n');
    },
  ),
  _InsightMapper(
    placeholder: PlaceholdersA.PARAMS_A2,
    mapInsights: (insight) async {
      return dartFields(insight).map(
        (e) {
          final f = e.fieldName!.toCamelCase();
          return 'this.$f,';
        },
      ).join('\n');
    },
  ),
  _InsightMapper(
    placeholder: PlaceholdersA.FROM_JSON_A1,
    mapInsights: (insight) async {
      return '${dartFields(insight).map(
        (e) {
          final k = 'K_${e.fieldName!.toUpperSnakeCase()}';
          final f = e.fieldName!.toCamelCase();
          final x = e.fieldTypeCode!;
          final f0 = '${f}0';
          final b = xyz.DartTypeCodeMapper(xyz.DartLooseTypeMappers.instance.fromMappers).map(
            fieldName: f0,
            fieldTypeCode: x,
          );

          return 'final $f0 = otherData?[$k];\nfinal $f = $b;';
        },
      ).join('\n')}';
    },
  ),
  _InsightMapper(
    placeholder: PlaceholdersA.FROM_JSON_A2,
    mapInsights: (insight) async {
      return '${dartFields(insight).map(
        (e) {
          final f = e.fieldName!.toCamelCase();
          return '$f: $f,';
        },
      ).join('\n')}';
    },
  ),
  _InsightMapper(
    placeholder: PlaceholdersA.TO_JSON_A1,
    mapInsights: (insight) async {
      return dartFields(insight).map(
        (e) {
          final f = e.fieldName!.toCamelCase();
          final f0 = '${f}0';
          final x = e.fieldTypeCode!;
          final a = xyz.DartTypeCodeMapper(xyz.DartLooseTypeMappers.instance.toMappers).map(
            fieldName: 'this.$f',
            fieldTypeCode: x,
          );
          return 'final $f0 = $a;';
        },
      ).join('\n');
    },
  ),
  _InsightMapper(
    placeholder: PlaceholdersA.TO_JSON_A2,
    mapInsights: (insight) async {
      return dartFields(insight).map(
        (e) {
          final k = 'K_${e.fieldName!.toUpperSnakeCase()}';
          final f = e.fieldName!.toCamelCase();
          final f0 = '${f}0';
          return '$k: $f0,';
        },
      ).join('\n');
    },
  ),
];

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

enum PlaceholdersA {
  SUPER_CLASS,
  CLASS,
  SUPER_CONSTRUCTOR,
  CLASS_FILE_NAME,
  STATIC_KEY_NAMES,
  FIELD_DECLARATIONS_A,
  PARAMS_A1,
  ARGS_A,
  PARAMS_A2,
  FROM_JSON_A1,
  FROM_JSON_A2,
  TO_JSON_A1,
  TO_JSON_A2,
}

typedef _InsightMapper = xyz.InsightMapper<xyz.ClassInsight<GenerateModel>, Enum>;
