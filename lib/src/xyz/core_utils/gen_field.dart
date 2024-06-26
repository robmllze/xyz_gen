//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// 🇽🇾🇿 & Dev
//
// Licencing details are in the LICENSE file in the root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

/// Represents a field, its name, type, and its nullability. Similar to
/// [TGenFieldRecord].
base class GenField {
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

  /// Derives an instance [DartGenField] from [source].
  factory GenField.from(GenField source) {
    return GenField(
      fieldName: source.fieldName,
      fieldType: source.fieldType,
      nullable: source.nullable,
    );
  }

  /// Derives an instance [DartGenField] from [record].
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
    return this.fieldName.replaceAll(RegExp(r'^[\w$]'), '');
  }

  /// Returns the field type, stripping out any characters that are not word characters (\w).
  String get fieldTypeWord {
    return this.fieldType.replaceAll(RegExp(r'^[\w$]'), '');
  }

  //
  //
  //

  /// Converts this to a [TGenFieldRecord].
  TGenFieldRecord get toRecord => (
        fieldName: this.fieldNameWord,
        fieldType: this.fieldTypeWord,
        nullable: this.nullable,
      );

  //
  //
  //

  /// Assumes [unknown] is a [TGenFieldRecord] or [GenField] or similar and
  /// tries to construct a [GenField], otherwise returns `null`.
  static GenField? ofOrNull(dynamic unknown) {
    try {
      final fieldName = fieldNameOrNull(unknown)!;
      final fieldType = fieldTypeOrNull(unknown) ?? 'dynamic';
      final nullable = nullableOrNull(unknown);
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
  static String? fieldNameOrNull(dynamic unknown) {
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
  static String? fieldTypeOrNull(dynamic unknown) {
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
  static bool? nullableOrNull(dynamic unknown) {
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

/// Identifier names for the [TGenFieldRecord] type.
enum IGenFieldRecord {
  //
  //
  //

  $this('TGenFieldRecord'),
  fieldName('fieldName'),
  fieldType('fieldType'),
  nullable('nullable');

  //
  //
  //

  final String id;

  //
  //
  //

  const IGenFieldRecord(this.id);
}
