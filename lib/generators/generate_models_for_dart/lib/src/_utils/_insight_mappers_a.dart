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
          final f = e.fieldName;
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
          final f = e.fieldName;
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
          final f = e.fieldName;
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
          final f = e.fieldName;
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
          final f = e.fieldName;
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
          final f = e.fieldName;
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
          final f = e.fieldName;
          final x = e.fieldTypeCode!;
          final f0 = '${f}0';
          final b = xyz.DartTypeCodeMapper(xyz.DartLooseTypeMappers.instance.fromMappers).map(
            fieldName: f0,
            fieldTypeCode: x,
          );
          String $v(String start, List<String>? fields) {
            if (fields == null || fields.isEmpty) return '';

            var result = "$start";

            if (fields.length > 1) {
              for (var n = 0; n < fields.length - 1; n++) {
                result = "letMap<String, dynamic>($result?['${fields[n]}'],)";
              }
            }

            result = "$result?['${fields.last}']";

            return result;
          }

          final fields = e
              .fieldNameParts(
                StringCaseType.values.valueOf(insight.annotation.keyStringCase) ??
                    StringCaseType.CAMEL_CASE,
              )
              ?.toList();
          final v = $v('otherData', fields);
          return [
            'final $f0 = $v;',
            'final $f = $b;',
          ].join('\n');
        },
      ).join('\n')}';
    },
  ),
  _InsightMapper(
    placeholder: PlaceholdersA.FROM_JSON_A2,
    mapInsights: (insight) async {
      return '${dartFields(insight).map(
        (e) {
          final f = e.fieldName;
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
          final f = e.fieldName;
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
          final f = e.fieldName;
          final f0 = '${f}0';
          final fields = e
              .fieldNameParts(
                StringCaseType.values.valueOf(insight.annotation.keyStringCase) ??
                    StringCaseType.CAMEL_CASE,
              )
              ?.toList();
          $v(String end, List<String>? fields) {
            if (fields == null || fields.isEmpty) return '';
            var result = "{'${fields.last}': $end,},";
            for (var n = fields.length - 2; n >= 0; n--) {
              result = "{'${fields[n]}': ${result}},";
            }
            return result;
          }

          final v = $v(f0, fields);
          return v;
        },
      ).join('\n');
    },
  ),
  _InsightMapper(
    placeholder: PlaceholdersA.GETTERS_A,
    mapInsights: (insight) async {
      return dartFields(insight).map(
        (e) {
          final f = e.fieldName;
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
    placeholder: PlaceholdersA.FIELD_NAMES,
    mapInsights: (insight) async {
      return dartFields(insight).map(
        (e) {
          final f = e.fieldName;
          final c = stringCaseType(insight).convert(e.fieldName!);
          return "static const $f = '$c';";
        },
      ).join('\n');
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
  FIELD_NAMES,
}

typedef _InsightMapper = xyz.InsightMapper<xyz.ClassInsight<GenerateModel>, PlaceholdersA>;
