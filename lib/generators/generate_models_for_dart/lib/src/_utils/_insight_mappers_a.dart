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
    placeholder: PlaceholdersA.SUPER_CLASS_NAME,
    mapInsights: (insight) async {
      return insight.annotation.shouldInherit == true ? insight.className : 'Model';
    },
  ),
  _InsightMapper(
    placeholder: PlaceholdersA.CLASS_FILE_NAME,
    mapInsights: (insight) async {
      return insight.fileName;
    },
  ),
  _InsightMapper(
    placeholder: PlaceholdersA.CLASS_NAME,
    mapInsights: (insight) async {
      return insight.annotation.className ??
          insight.className.replaceFirst(
            RegExp(r'^[_$]+'),
            '',
          );
    },
  ),
  _InsightMapper(
    placeholder: PlaceholdersA.SUPER_CONSTRUCTOR,
    mapInsights: (insight) async {
      return insight.annotation.shouldInherit == true
          ? insight.annotation.inheritanceConstructor?.nullIfEmpty != null
              ? ': super.${insight.annotation.inheritanceConstructor}()'
              : ''
          : '';
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
          final n = e.nullable;
          final f = e.fieldName!.toCamelCase();
          return '${n ? '' : 'required'} this.$f,';
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
    placeholder: PlaceholdersA.PARAMS_A3,
    mapInsights: (insight) async {
      return dartFields(insight).map(
        (e) {
          final t = stripSpecialSyntaxFromFieldType(e.fieldType!);
          final f = e.fieldName!.toCamelCase();
          return '$t? $f,';
        },
      ).join('\n');
    },
  ),
  _InsightMapper(
    placeholder: PlaceholdersA.FIELD_ASSERTIONS,
    mapInsights: (insight) async {
      return dartFields(insight).map(
        (e) {
          final n = e.nullable;
          final f = e.fieldName!.toCamelCase();
          return n ? '' : 'assert($f != null);';
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
    placeholder: PlaceholdersA.FROM_JSON_A1,
    mapInsights: (insight) async {
      return '${dartFields(insight).map(
        (e) {
          final className = insight.annotation.className ??
              insight.className.replaceFirst(
                RegExp(r'^[_$]+'),
                '',
              );
          final f = e.fieldName!.toCamelCase();
          final k = '${className}Fields.${f}.name';
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
          final className = insight.annotation.className ??
              insight.className.replaceFirst(
                RegExp(r'^[_$]+'),
                '',
              );
          final f = e.fieldName!.toCamelCase();
          final k = '${className}Fields.${f}.name';
          final f0 = '${f}0';
          return '$k: $f0,';
        },
      ).join('\n');
    },
  ),
  _InsightMapper(
    placeholder: PlaceholdersA.GETTERS_A,
    mapInsights: (insight) async {
      return dartFields(insight).map(
        (e) {
          final f = e.fieldName!.toCamelCase();
          final x = e.fieldTypeCode!;
          final s = stripSpecialSyntaxFromFieldType(x);
          final n = e.nullable;
          return [
            '  // $f.',
            '$s get ${f}Field => this.$f${n ? '' : '!'};',
            '',
          ].join('\n');
        },
      ).join('\n');
    },
  ),
  _InsightMapper(
    placeholder: PlaceholdersA.FIELDS,
    mapInsights: (insight) async {
      return dartFields(insight).map(
        (e) {
          final f = e.fieldName!.toCamelCase();
          final x = e.fieldTypeCode!;
          final y = x.endsWith('?') ? x.substring(0, x.length - 1) : x;
          final c = stringCaseType(insight).convert(e.fieldName!);
          final n = e.nullable;
          return "$f(const Field(fieldName: '$c', fieldType: '$y', nullable: $n,),)";
        },
      ).join(',\n');
    },
  ),
];

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

enum PlaceholdersA {
  SUPER_CLASS_NAME,
  CLASS_NAME,
  SUPER_CONSTRUCTOR,
  CLASS_FILE_NAME,
  FIELD_DECLARATIONS_A,
  PARAMS_A1,
  FIELD_ASSERTIONS,
  ARGS_A,
  PARAMS_A2,
  PARAMS_A3,
  FROM_JSON_A1,
  FROM_JSON_A2,
  TO_JSON_A1,
  TO_JSON_A2,
  GETTERS_A,
  FIELDS,
}

typedef _InsightMapper = xyz.InsightMapper<xyz.ClassInsight<GenerateModel>, PlaceholdersA>;
