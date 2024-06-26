//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// 🇽🇾🇿 & Dev
//
// Licencing details are in the LICENSE file in the root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:analyzer/dart/constant/value.dart';

import '/src/xyz/_all_xyz.g.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

extension DartFromRecordOnDartObjectX on DartObject {
  //
  //
  //

  /// Returns `fieldName` property from `this` [DartObject] record if it matches
  /// the structure of [TGenFieldRecord] or `null`.
  String? fieldNameFromRecord() {
    return this._rawFieldNameFromRecord(this)?.replaceAll(RegExp(r'^[\w$]'), '');
  }

  String? _rawFieldNameFromRecord(DartObject obj) {
    final id = IGenFieldRecord.fieldName.name;
    final a = obj.getField('\$1')?.toStringValue();
    final b = obj.getField(id)?.toStringValue();
    return a ?? b;
  }

  //
  //
  //

  /// Returns `fieldType` property from `this` DartObject record if it matches
  /// \the structure of [TGenFieldRecord] or `null`.
  String? fieldTypeFromRecord() {
    final id = IGenFieldRecord.fieldType.name;
    final a = this.getField('\$2')?.toStringValue();
    final b = this.getField('\$2')?.toTypeValue()?.getDisplayString(withNullability: true);
    final c = this.getField(id)?.toStringValue();
    final d = this.getField(id)?.toTypeValue()?.getDisplayString(withNullability: true);
    return a ?? b ?? c ?? d;
  }

  //
  //
  //

  /// Returns `nullable` property from the `this` [DartObject] record if it
  /// matches the structure of [TGenFieldRecord] or `null`.
  bool? nullableFromRecord() {
    final id = IGenFieldRecord.nullable.name;
    final t = this.fieldTypeFromRecord();
    if (t == 'dynamic' || t == 'dynamic?') {
      return false;
    }
    final a = this.getField(id)?.toBoolValue();
    final b = this.getField('\$3')?.toBoolValue();
    final c = this._rawFieldNameFromRecord(this)?.contains('?');
    final d = t?.endsWith('?');
    return a ?? b ?? ((c ?? false) || (d ?? false));
  }
}
