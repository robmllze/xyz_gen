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
import 'package:xyz_gen_annotations/xyz_gen_annotations.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

extension DartFromRecordOnDartObjectX on DartObject {
  //
  //
  //

  /// Returns `fieldName` property from `this` [DartObject] record if it matches
  /// the structure of [TFieldRecord] or `null`.
  String? fieldNameFromRecord() {
    final raw = this._rawFieldNameFromRecord();
    if (raw != null) {
      return raw.endsWith('?') ? raw.substring(0, raw.length - 1) : raw;
    }
    return null;
  }

  String? _rawFieldNameFromRecord() {
    final a = this.getField('\$1')?.toStringValue();
    final b = this.getField('fieldName')?.toStringValue();
    return a ?? b;
  }

  //
  //
  //

  /// Returns `fieldType` property from `this` DartObject record if it matches
  /// the structure of [TFieldRecord] or `null`.
  String? fieldTypeFromRecord() {
    final raw = this._rawFieldTypeFromRecord();
    if (raw != null) {
      return raw.endsWith('?') ? raw.substring(0, raw.length - 1) : raw;
    }
    return null;
  }

  String? _rawFieldTypeFromRecord() {
    final a = this.getField('\$2')?.toStringValue();
    final b = this.getField('\$2')?.toTypeValue()?.getDisplayString();
    final c = this.getField('fieldType')?.toStringValue();
    final d = this.getField('fieldType')?.toTypeValue()?.getDisplayString();
    return a ?? b ?? c ?? d;
  }

  //
  //
  //

  /// Returns `nullable` property from the `this` [DartObject] record if it
  /// matches the structure of [TFieldRecord] or `null`.
  bool? nullableFromRecord() {
    if (this.fieldTypeFromRecord() == 'dynamic') {
      return false;
    }
    final a = this.getField('nullable')?.toBoolValue();
    final b = this.getField('\$3')?.toBoolValue();
    final c = this._rawFieldNameFromRecord()?.endsWith('?');
    final d = this._rawFieldTypeFromRecord()?.endsWith('?');
    return a ?? b ?? ((c ?? false) || (d ?? false));
  }
}
