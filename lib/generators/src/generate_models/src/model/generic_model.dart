//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'model.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class GenericModel extends Model {
  //
  //
  //

  final Map<String, dynamic> data;

  //
  //
  //

  GenericModel(this.data);

  //
  //
  //

  @override
  Map<String, dynamic> toJMap({
    dynamic defaultValue,
    bool includeNulls = false,
  }) {
    return includeNulls
        ? Map.fromEntries(data.entries.where((e) => e.value != null))
            .map((k, v) => MapEntry(k, v!))
        : data.map((k, v) => MapEntry(k, v ?? defaultValue));
  }

  //
  //
  //

  @override
  T empty<T extends Model>() => GenericModel({}) as T;

  //
  //
  //

  @override
  T copy<T extends Model>() => this as T;

  //
  //
  //

  @override
  T copyWith<T extends Model>(T other) => this.copyWithJMap(other.toJMap());

  //
  //
  //

  @override
  T copyWithJMap<T extends Model>(Map<String, dynamic> other) =>
      GenericModel({...this.data, ...other}) as T;

  //
  //
  //

  @override
  void updateWith<T extends Model>(T other) =>
      this.updateWithJMap(other.toJMap());

  //
  //
  //

  @override
  void updateWithJMap<T extends Model>(Map<String, dynamic> other) =>
      this.data.addAll(other);
}
