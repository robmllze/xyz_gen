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

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

final typeScriptInsightMappers = [
  _InsightMapper(
    placeholder: PlaceholdersA.CLASS_NAME,
    mapInsights: (insight) async {
      return insight.className;
    },
  ),
  _InsightMapper(
    placeholder: PlaceholdersA.FIELDS,
    mapInsights: (insight) async {
      final fields0 = insight.annotation.fields ?? {};
      if (fields0.isNotEmpty) {
        final fields1 = fields0.map((e) => FieldUtils.ofOrNull(e)).nonNulls;
        final firstFieldNames =
            fields1.map((e) => (e, '${e.fieldPath?.firstOrNull}${e.nullable != false ? '?' : ''}'));
        final test1 = firstFieldNames.map((e) {
          final field = e.$1;
          final firstFieldName = e.$2;
          switch (field.fieldType) {
            case 'String':
              return '$firstFieldName: string;';
            case 'num':
              return '$firstFieldName: number;';
            case 'int':
              return '$firstFieldName: number;';
            case 'double':
              return '$firstFieldName: number;';
            case 'DateTime':
              return '$firstFieldName: string;';
            default:
              return '$firstFieldName: any;';
          }
        });
        return test1.join('\n');
      } else {
        return '';
      }
    },
  ),
];

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

enum PlaceholdersA {
  CLASS_NAME,
  FIELDS,
}

typedef _InsightMapper = xyz.InsightMapper<xyz.ClassInsight<GenerateModel>, PlaceholdersA>;
