//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'dart:convert';
export 'dart:convert';

import 'package:collection/collection.dart' show DeepCollectionEquality;

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

abstract class Model {
  //
  //
  //

  String? id;
  dynamic args;

  //
  //
  //

  String toJson() {
    return json.encode(this.toJMap());
  }

  //
  //
  //

  Map<String, dynamic> toJMap({
    dynamic defaultValue,
    bool includeNulls = false,
  });

  //
  //
  //

  Map<String, dynamic> sortedJMap({
    dynamic defaultValue,
    bool includeNulls = false,
  }) {
    final a = this.toJMap(defaultValue: defaultValue, includeNulls: includeNulls);
    final b = a.keys.toList(growable: false)..sort((k1, k2) => k1.compareTo(k2));
    final c = {for (var k in b) k: a[k] as dynamic};
    return c;
  }

  //
  //
  //

  T empty<T extends Model>();

  //
  //
  //

  T copy<T extends Model>();

  //
  //
  //

  T copyWith<T extends Model>(T other);

  //
  //
  //

  T copyWithJMap<T extends Model>(Map<String, dynamic> other);

  //
  //
  //

  void updateWith<T extends Model>(T other);

  //
  //
  //

  void updateWithJMap<T extends Model>(Map<String, dynamic> other);

  //
  //
  //

  @override
  String toString() => this.toJMap().toString();

  //
  //
  //

  bool equals<T extends Model>(T other) {
    return const DeepCollectionEquality().equals(this.toJMap(), other.toJMap());
  }

  //
  //
  //

  @override
  bool operator ==(Object? other) {
    if (other is! Model) {
      return false;
    }
    if (other.runtimeType != this.runtimeType) {
      return false;
    }
    return this.equals(other);
  }

  //
  //
  //

  @override
  int get hashCode => this.sortedJMap().toString().hashCode;
}
