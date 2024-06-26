//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// 🇽🇾🇿 & Dev
//
// Licencing details are in the LICENSE file in the root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:meta/meta.dart';
import 'package:xyz_gen_annotations/annotations_src/field.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

final class DartField extends Field {
  //
  //
  //

  const DartField({
    required super.fieldName,
    required super.fieldType,
    super.nullable,
  });

  /// Derives an instance [DartField] from [source].
  factory DartField.from(Field source) {
    return DartField(
      fieldName: source.fieldName,
      fieldType: source.fieldType,
      nullable: source.nullable,
    );
  }

  /// Derives an instance [DartField] from [record].
  factory DartField.fromRecord(TFieldRecord record) {
    return DartField(
      fieldName: record.fieldName,
      fieldType: record.fieldType,
      nullable: record.nullable,
    );
  }

  //
  //
  //

  @override
  String? get fieldName {
    if (super.fieldName != null) {
      return this._fieldNameNullable!
          ? super.fieldName!.substring(0, super.fieldName!.length - 1)
          : super.fieldName;
    } else {
      return null;
    }
  }

  @override
  String? get fieldType {
    if (super.fieldType != null) {
      return this._fieldTypeNullable!
          ? super.fieldType?.substring(0, super.fieldType!.length - 1)
          : super.fieldType;
    } else {
      return null;
    }
  }

  //
  //
  //

  @override
  bool? get nullable {
    return [
      super.nullable,
      this._fieldNameNullable,
      this._fieldTypeNullable,
    ].any((e) => e == true);
  }

  //
  //
  //

  bool? get _fieldNameNullable => super.fieldName?.endsWith('?');

  bool? get _fieldTypeNullable => super.fieldType?.endsWith('?');

  //
  //
  //

  /// Assumes [unknown] is a [TFieldRecord] or [Field] or similar and  tries to
  /// construct a [DartField], otherwise returns `null`.
  @visibleForTesting
  static DartField? ofOrNull(dynamic unknown) {
    try {
      return DartField.from(Field.ofOrNull(unknown)!);
    } catch (_) {
      return null;
    }
  }
}
