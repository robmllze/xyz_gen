// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Generate Screen Access Annotations
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

abstract class XyzModel extends Equatable {
  /// Unique identifier fo this model.
  ///
  /// Related key: `K_ID` or "id"
  String? id;

  /// Optional arguments for this model.
  ///
  /// Related key: `K_ARGS` or "id"
  dynamic args;

  // Converts a this object to a JSON object.
  _JMap toJMap();

  /// Returns a copy of `this` model.
  T copyWith<T extends XyzModel>({T? other});

  /// Constructs a new instance of type [T] from the JSON object [other].
  T newFromJMap<T extends XyzModel>(_JMap other) {
    return this.newEmpty()..updateWithJMap(other);
  }

  /// Returns a new instance of type [T] with the fields in [other] merged
  /// with/overriding the current fields.
  T newOverrideJMap<T extends XyzModel>(_JMap other) {
    return this.newFromJMap({...this.toJMap(), ...other});
  }

  /// Returns a copy of `this` object with the fields in [other] overriding
  /// `this` fields.
  T newOverride<T extends XyzModel>(T other);

  /// Returns a new empty instance of [$nameClass].
  T newEmpty<T extends XyzModel>();

  /// Updates `this` fields from the fields of [other].
  void updateWithJMap(_JMap other);

  /// Updates `this` fields from the fields of [other].
  void updateWith<T extends XyzModel>(T other);

  @override
  String toString() => this.toJMap().toString();

  @override
  bool? get stringify => false;
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

abstract class XyzModelUpdate extends XyzModel {
  final dynamic type;
  XyzModelUpdate(this.type);
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

typedef _JMap = Map<String, dynamic>;
