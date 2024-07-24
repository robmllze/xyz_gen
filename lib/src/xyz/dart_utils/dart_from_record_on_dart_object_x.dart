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


import '../_index.g.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

extension DartFromRecordOnDartObjectX on DartObject {
  //
  //
  //

  /// Returns `fieldName` property from `this` [DartObject] record if it matches
  /// the structure of [TFieldRecord] or `null`.
  List<String>? fieldPathFromRecord() {
    return this._rawFieldPathFromRecord()?.map((e) => e.replaceAll('?', '')).toList();
  }

  List<String>? _rawFieldPathFromRecord() {
    final a = dartObjToList(this.getField('\$1'));
    final b = dartObjToList(this.getField(FieldFieldNames.fieldPath));
    return (a ?? b)?.toList();
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
    final c = this.getField(FieldFieldNames.fieldType)?.toStringValue();
    final d = this.getField(FieldFieldNames.fieldType)?.toTypeValue()?.getDisplayString();
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

    final a = this.getField(FieldFieldNames.nullable)?.toBoolValue();
    final b = this.getField('\$3')?.toBoolValue();
    final c = this._rawFieldPathFromRecord()?.any((e) => e.contains('?'));
    final d = this._rawFieldTypeFromRecord()?.endsWith('?');
    return a ?? b ?? ((c ?? false) || (d ?? false));
  }
}
