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
      final fields = dartFields(insight).toList();

      String $v(String a, xyz.DartField field) {
        final keys = field.fieldPath;
        if (keys == null || keys.isEmpty) return '';
        final f = field.fieldName;
        final x = field.fieldTypeCode!;
        final s = stripSpecialSyntaxFromFieldType(x);
        final b = xyz.DartTypeCodeMapper(xyz.DartLooseTypeMappers.instance.fromMappers).map(
          fieldName: "$a?['${keys.last}']",
          fieldTypeCode: s,
        );
        return 'final ${f} = $b;';
      }

      final j = fields.map((a) {
        final ff = fields
            .where((b) => a.fieldPath!.join('.').startsWith(b.fieldPath!.join('.')))
            .toList()
          ..sort((a, b) => b.fieldName!.compareTo(a.fieldName!));
        return $v(ff.length > 1 ? '${ff[1].fieldName}' : 'otherData', ff.first);
      });
      return j.join('\n');
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
          final s = stripSpecialSyntaxFromFieldType(x);
          final a = xyz.DartTypeCodeMapper(xyz.DartLooseTypeMappers.instance.toMappers).map(
            fieldName: 'this.$f',
            fieldTypeCode: s,
          );
          return 'final $f0 = $a;';
        },
      ).join('\n');
    },
  ),
  _InsightMapper(
    placeholder: PlaceholdersA.TO_JSON_A2,
    mapInsights: (insight) async {
      final fields = dartFields(insight).toList();
      final parents = fields
          .where(
            (f1) =>
                f1.fieldType == 'Map<String, dynamic>' &&
                fields.map((e) => e.fieldName!).any((e) => e.startsWith(f1.fieldName!)),
          )
          .toList();
      fields.removeWhere((e) => parents.contains(e));

      dynamic traverseMap(Map<String, dynamic> map, List<String> keys, {dynamic newValue}) {
        dynamic current = map;
        for (var n = 0; n < keys.length; n++) {
          final key = keys[n];
          if (n == keys.length - 1) {
            if (newValue != null) {
              current[key] = newValue; // Set the value if newValue is provided
              return;
            } else {
              return current[key]; // Get the value if newValue is not provided
            }
          } else {
            if (current is Map<String, dynamic> && current.containsKey(key)) {
              current = current[key];
            } else {
              if (newValue != null) {
                current[key] = <String, dynamic>{}; // Create a new map if we're setting a value
                current = current[key];
              } else {
                return null; // Key not found or current is not a map
              }
            }
          }
        }
        return null; // Return null if keys are exhausted without finding the value
      }

      final type = StringCaseType.values.valueOf(insight.annotation.keyStringCase) ??
          StringCaseType.CAMEL_CASE;

      void setValueInMap(
        Map<String, dynamic> data,
        Iterable<String> keys,
        dynamic value,
      ) {
        if (keys.length > 1) {
          for (var n = 0; n < keys.length - 1; n++) {
            final k = keys.elementAt(n);
            data = (data[k] ??= <String, dynamic>{});
          }
        }
        final d1 = data[keys.last];
        if (d1 is Map && value is Map) {
          data[keys.last] = {...d1, ...value};
        } else {
          data[keys.last] = value;
        }
      }

      final entries = fields
          .map((e) => MapEntry(type.convertAll(e.fieldPath!).join('.'), '${e.fieldName}0'))
          .toList()
        ..sort((a, b) => b.key.compareTo(a.key));

      var buffer = <String, dynamic>{};

      for (final e in entries) {
        setValueInMap(buffer, e.key.split('.').map((e) => "'$e'"), e.value);
      }

      for (final parent in parents) {
        traverseMap(
          buffer,
          [...parent.fieldPath!.map((e) => "'${type.convert(e)}'"), '#'],
          newValue: '...?${parent.fieldName}0,',
        );
      }

      final test = buffer.entries.map((e) => '${e.key}: ${e.value},').join();

      return test.replaceAll('#:', '');
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
