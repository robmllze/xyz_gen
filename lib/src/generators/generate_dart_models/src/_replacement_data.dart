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

import '../../../xyz/core_utils/type_codes/type_code_mapper.dart';
import '/src/xyz/_all_xyz.g.dart' as xyz;

import '_analyze_dart_file.dart';
import '../../../xyz/language_support_utils/dart/dart_loose_type_mappers.dart';
import '_strip_special_syntax_from_field_type.dart';
import '_to_generic_type.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Map<String, String> replacementData(ClassInsight insight) {
  return {
    _Placeholders.SUPER_CLASS: _superClass(insight),
    _Placeholders.CLASS_FILE_NAME: _classFileName(insight),
    _Placeholders.CLASS: _class(insight),
    _Placeholders.MODEL_ID: _modelId(insight),
    _Placeholders.SUPER_CONSTRUCTOR: _superConstructor(insight),
    _Placeholders.P0: _p0(insight),
    _Placeholders.P1: _p1(insight),
    _Placeholders.P2: _p2(insight),
    _Placeholders.P3: _p3(insight),
    _Placeholders.P4: _p4(insight),
    _Placeholders.P5: _p5(insight),
    _Placeholders.P6: _p6(insight),
    _Placeholders.P7: _p7(insight),
    _Placeholders.P8: _p8(insight),
    _Placeholders.P9: _p9(insight),
  }.map((k, v) => MapEntry(k.placeholder, v));
}

Iterable<xyz.DartField> _dartFields(ClassInsight insight) {
  return insight.annotation.fields.map((e) {
    e.runtimeType;
    return xyz.DartField.fromRecord(e);
  }).nonNulls;
}

StringCaseType _stringCaseType(ClassInsight insight) {
  return StringCaseType.values.valueOf(insight.annotation.keyStringCase) ??
      StringCaseType.LOWER_SNAKE_CASE;
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

String _superClass(ClassInsight insight) {
  return insight.annotation.shouldInherit ? insight.className : 'Model';
}

String _classFileName(ClassInsight insight) {
  return insight.fileName;
}

String _class(ClassInsight insight) {
  return insight.annotation.className ?? insight.className.replaceFirst(RegExp(r'^[_$]+'), '');
}

String _modelId(ClassInsight insight) {
  return insight.className.toLowerSnakeCase();
}

String _superConstructor(ClassInsight insight) {
  return insight.annotation.shouldInherit
      ? insight.annotation.inheritanceConstructor?.nullIfEmpty != null
          ? ': super.${insight.annotation.inheritanceConstructor}()'
          : ''
      : '';
}

String _p0(ClassInsight insight) {
  return _dartFields(insight).map(
    (e) {
      final k = 'K_${e.fieldName!.toUpperSnakeCase()}';
      final c = _stringCaseType(insight).convert(e.fieldName!);
      return "static const $k = '$c';";
    },
  ).join('\n');
}

String _p1(ClassInsight insight) {
  return _dartFields(insight).map(
    (e) {
      final t = stripSpecialSyntaxFromFieldType(e.fieldType!);
      final f = e.fieldName!;
      return '$t? $f;';
    },
  ).join('\n');
}

String _p2(ClassInsight insight) {
  return _dartFields(insight).map(
    (e) {
      final t = stripSpecialSyntaxFromFieldType(e.fieldType!);
      final n = e.nullable;
      final f = e.fieldName!;
      return '${n ? '' : 'required'} $t${n ? '?' : ''} $f,';
    },
  ).join('\n');
}

String _p3(ClassInsight insight) {
  return _dartFields(insight).map(
    (e) {
      final f = e.fieldName!;
      return '$f: $f,';
    },
  ).join('\n');
}

String _p4(ClassInsight insight) {
  return _dartFields(insight).map(
    (e) {
      final f = e.fieldName!;
      return 'this.$f,';
    },
  ).join('\n');
}

String _p5(ClassInsight insight) {
  return _dartFields(insight).map(
    (e) {
      final n = e.nullable;
      final f = e.fieldName!;
      return n ? 'assert(this.$f != null);' : '';
    },
  ).join('\n');
}

String _p6(ClassInsight insight) {
  return '${_dartFields(insight).map(
    (e) {
      final k = 'K_${e.fieldName!.toUpperSnakeCase()}';
      final f = e.fieldName!;
      return '..\$$f = otherData${insight.className != 'DataModel' ? '?[$k]' : ''}';
    },
  ).join('\n')};';
}

String _p7(ClassInsight insight) {
  return _dartFields(insight).map(
    (e) {
      final k = 'K_${e.fieldName!.toUpperSnakeCase()}';
      final f = e.fieldName!;
      return '${insight.className != 'DataModel' ? '$k: ' : '...'}this.\$$f,';
    },
  ).join('\n');
}

String _p8(ClassInsight insight) {
  return _dartFields(insight).map(
    (e) {
      final f = e.fieldName!;
      return 'if (other.$f != null) { this.$f = other.$f!; }';
    },
  ).join('\n');
}

String _p9(ClassInsight insight) {
  return _dartFields(insight).map(
    (e) {
      final f = e.fieldName!;
      final x = e.fieldTypeCode!;
      final s = stripSpecialSyntaxFromFieldType(x);
      final n = e.nullable;
      final a = TypeCodeMapper(DartLooseTypeMappers.instance.toMappers).map(
        fieldName: 'this.$f',
        fieldTypeCode: x,
      );
      final b = TypeCodeMapper(DartLooseTypeMappers.instance.fromMappers).map(
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
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

enum _Placeholders {
  SUPER_CLASS,
  CLASS,
  SUPER_CONSTRUCTOR,
  MODEL_ID,
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
