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

import '/src/xyz/_all_xyz.g.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

final class DartGenField extends GenField {
  //
  //
  //

  const DartGenField({
    required super.fieldName,
    required super.fieldType,
    super.nullable,
  });

  /// Derives an instance [DartGenField] from [source].
  factory DartGenField.from(GenField source) {
    return DartGenField(
      fieldName: source.fieldName,
      fieldType: source.fieldType,
      nullable: source.nullable,
    );
  }

  /// Derives an instance [DartGenField] from [record].
  factory DartGenField.fromRecord(TGenFieldRecord record) {
    return DartGenField(
      fieldName: record.fieldName,
      fieldType: record.fieldType,
      nullable: record.nullable,
    );
  }

  //
  //
  //

  @override
  bool get nullable {
    return [
      super.nullable,
      this.fieldNameMarkedAsNullableDartOnly,
      this.fieldTypeMarkedAsNullableDartOnly,
    ].any((e) => e == true);
  }

  //
  //
  //

  /// Whether [fieldName] is marked as nullable in Dart. This would be the case
  /// if [fieldName] ends with '?';
  bool get fieldNameMarkedAsNullableDartOnly {
    return this.fieldName.endsWith('?');
  }

  /// Whether [fieldType] is marked as nullable in Dart. This would be the case
  /// if [fieldType] ends with '?';
  bool get fieldTypeMarkedAsNullableDartOnly {
    return this.fieldType.endsWith('?') || this.fieldType == 'dynamic';
  }

  //
  //
  //

  /// Assumes [unknown] is a [TGenFieldRecord] or [GenField] or similar and
  /// tries to construct a [DartGenField], otherwise returns `null`.
  @visibleForTesting
  static DartGenField? ofOrNull(dynamic unknown) {
    try {
      return DartGenField.from(GenField.ofOrNull(unknown)!);
    } catch (_) {
      return null;
    }
  }

  //
  //
  //
}
