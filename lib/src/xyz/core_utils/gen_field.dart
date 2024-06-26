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

/// Represents a field, its name, type, and its nullability. Similar to
/// [TGenFieldRecord].
final class GenField {
  //
  //
  //

  /// The name of the field.
  final String fieldName;

  /// The type of the field as a String, e.g. 'String'.
  final String fieldType;

  /// Whether [fieldType] is nullable or not.
  final bool? nullable;

  //
  //
  //

  const GenField({
    required this.fieldName,
    required this.fieldType,
    this.nullable,
  });

  factory GenField.fromRecord(TGenFieldRecord record) {
    return GenField(
      fieldName: record.fieldName,
      fieldType: record.fieldType,
      nullable: record.nullable,
    );
  }

  //
  //
  //

  //// Returns the field name, stripping out any characters that are not word characters (\w).
  String get fieldNameWord {
    return this.fieldName.replaceAll(RegExp(r'^[\w]'), '');
  }

  /// Returns the field type, stripping out any characters that are not word characters (\w).
  String get fieldTypeWord {
    return this.fieldType.replaceAll(RegExp(r'^[\w]'), '');
  }

  //
  //
  //

  /// Converts this to a [TGenFieldRecord].
  TGenFieldRecord get toRecord => (
        fieldName: this.fieldName,
        fieldType: this.fieldType,
        nullable: this.nullable,
      );

  //
  //
  //

  /// Whether [fieldName] is marked as nullable in Dart. This would be the case
  /// if [fieldName] ends with '?';
  @visibleForTesting
  bool get fieldNameMarkedAsNullableDartOnly {
    return this.fieldName.endsWith('?');
  }

  /// Whether [fieldType] is marked as nullable in Dart. This would be the case
  /// if [fieldType] ends with '?';
  @visibleForTesting
  bool get fieldTypeMarkedAsNullableDartOnly {
    return this.fieldType.endsWith('?') || this.fieldType == 'dynamic';
  }

  /// Whether this field is implicitly nullable in Dart. This would be the case
  /// if [nullable] is true or either [fieldName] or [fieldType] ends with '?';
  @visibleForTesting
  bool get nullableDartOnly {
    return [
      this.nullable,
      this.fieldNameMarkedAsNullableDartOnly,
      this.fieldTypeMarkedAsNullableDartOnly
    ].any((e) => e == true);
  }

  /// Converts the [GenField] instance back to a [TGenFieldRecord].
  @visibleForTesting
  TGenFieldRecord get toDartRecord => (
        fieldName: this.fieldNameWord,
        fieldType: this.fieldTypeWord,
        nullable: this.nullableDartOnly,
      );

  /// Assumes [unknown] is a [TGenFieldRecord] or [GenField] or similar and
  /// tries to construct a [GenField], otherwise returns `null`.
  ///
  /// This assumes that the language of interst is Dart and that [fieldName]
  /// and [fieldType] follow Dart's naming conventions and syntax.
  @visibleForTesting
  static GenField? tryDartField(dynamic unknown) {
    try {
      return GenField.tryField(unknown)!.toDartRecord.toClass;
    } catch (_) {
      return null;
    }
  }

  //
  //
  //

  /// Assumes [unknown] is a [TGenFieldRecord] or [GenField] or similar and
  /// tries to construct a [GenField], otherwise returns `null`.
  static GenField? tryField(dynamic unknown) {
    try {
      final fieldName = tryFieldName(unknown)!;
      final fieldType = tryFieldType(unknown) ?? 'dynamic';
      final nullable = tryNullable(unknown);
      return GenField(
        fieldName: fieldName,
        fieldType: fieldType,
        nullable: nullable,
      );
    } catch (_) {
      return null;
    }
  }

  /// Assumes [unknown] is a [TGenFieldRecord] or [GenField] or similar and
  /// tries to get the [fieldName] property, or returns `null`.
  static String? tryFieldName(dynamic unknown) {
    try {
      return (unknown.fieldName as String);
    } catch (_) {
      try {
        return unknown.$1 as String;
      } catch (_) {
        return null;
      }
    }
  }

  /// Assumes [unknown] is a [TGenFieldRecord] or [GenField] or similar and
  /// tries to get the [fieldType] property, or returns `null`.
  static String? tryFieldType(dynamic unknown) {
    try {
      return unknown.fieldType as String;
    } catch (_) {
      try {
        return unknown.$2 as String;
      } catch (e) {
        return null;
      }
    }
  }

  /// Assumes [unknown] is a [TGenFieldRecord] or [GenField] or similar and
  /// tries to get the [nullable] property, or returns `null`.
  static bool? tryNullable(dynamic unknown) {
    try {
      return unknown.nullable as bool?;
    } catch (_) {
      try {
        return unknown.$3 as bool?;
      } catch (_) {
        return null;
      }
    }
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// A record representing a field. Similar to [GenField].
typedef TGenFieldRecord = ({
  String fieldName,
  String fieldType,
  bool? nullable,
});

extension ToClassOnTGenFieldRecordExtension on TGenFieldRecord {
  /// Converts this to a [GenField].
  GenField get toClass => GenField(
        fieldName: fieldName,
        fieldType: fieldType,
        nullable: nullable,
      );
}
