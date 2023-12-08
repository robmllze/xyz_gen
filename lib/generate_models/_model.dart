//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:xyz_utils/io.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

abstract class Model {
  String? id;

  dynamic args;

  JMap toJMap({dynamic defaultValue, bool includeNulls = false});

  JMap sortedJMap({dynamic defaultValue, bool includeNulls = false}) {
    final a = this.toJMap(defaultValue: defaultValue, includeNulls: includeNulls);
    final b = a.keys.toList(growable: false)..sort((k1, k2) => k1.compareTo(k2));
    final c = {for (var k in b) k: a[k] as dynamic};
    return c;
  }

  T empty<T extends Model>();

  T copy<T extends Model>();

  T copyWith<T extends Model>(T other);

  T copyWithJMap<T extends Model>(JMap other);

  void updateWith<T extends Model>(T other);

  void updateWithJMap<T extends Model>(JMap other);

  @override
  String toString() => this.toJMap().toString();

  bool equals<T extends Model>(T other) => this.toJMap().deep == other.toJMap().deep;

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

  @override
  int get hashCode => this.sortedJMap().toString().hashCode;
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

abstract class ThisModel<T extends Model> extends Model {
  late final T model = this as T;
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class GenericModel extends Model {
  final JMap data;

  GenericModel(this.data);

  @override
  JMap toJMap({dynamic defaultValue, bool includeNulls = false}) {
    return includeNulls ? data.nonNulls : data.map((k, v) => MapEntry(k, v ?? defaultValue));
  }

  @override
  T empty<T extends Model>() => GenericModel({}) as T;

  @override
  T copy<T extends Model>() => this as T;

  @override
  T copyWith<T extends Model>(T other) => this.copyWithJMap(other.toJMap());

  @override
  T copyWithJMap<T extends Model>(JMap other) => GenericModel({...this.data, ...other}) as T;

  @override
  void updateWith<T extends Model>(T other) => this.updateWithJMap(other.toJMap());

  @override
  void updateWithJMap<T extends Model>(JMap other) => this.data.addAll(other);
}
