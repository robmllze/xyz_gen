````dart
//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// GENERATED BY XYZ_GEN - DO NOT MODIFY BY HAND
// See: https://github.com/robmllze/xyz_gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

// ignore_for_file: annotate_overrides
// ignore_for_file: empty_constructor_bodies
// ignore_for_file: invalid_null_aware_operator
// ignore_for_file: overridden_fields
// ignore_for_file: unnecessary_non_null_assertion
// ignore_for_file: unnecessary_null_comparison
// ignore_for_file: unnecessary_this

part of '___CLASS_FILE_NAME___';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class ___CLASS___ extends ___PARENT_CLASS___ {
  //
  //
  //
  
  ___P0___

  ___P1___
  
  //
  //
  //

  ___CLASS___({
    ___P2___
  }) : super._() {
    ___P3___
  }

  //
  //
  //

  ___CLASS___.unsafe({
    ___P4___
  }) : super._() {
    ___P5___
    ___P3___
  }

  //
  //
  //

  factory ___CLASS___.from(
    ___CLASS___ other,
  ) {
    return ___CLASS___.unsafe()..updateWith(other);
  }

  //
  //
  //

  factory ___CLASS___.fromJson(
    String source,
  ) {
    try {
      final decoded = jsonDecode(source);
      return ___CLASS___.fromJMap(decoded);
    } catch (e) {
      assert(false, e);
      rethrow;
    }
  }

  //
  //
  //
  
  factory ___CLASS___.fromJMap(
    Map<String, dynamic> input,
  ) {
    try {
      return ___CLASS___.unsafe(
        ___P6___
      );
    } catch (e) {
      assert(false, e);
      rethrow;
    }
  }

  //
  //
  //

  @override
  Map<String, dynamic> toJMap({
    dynamic defaultValue,
    bool includeNulls = false,
  }) {
    try {
      final withNulls = <String, dynamic>{
        ___P7___
      }.mapWithDefault(defaultValue);
      return includeNulls ? withNulls : withNulls.nonNulls;
    } catch (e) {
      assert(false, e);
      rethrow;
    }
  }

  //
  //
  //

  @override
  T empty<T extends Model>() {
    return ___CLASS___.unsafe() as T;
  }

  //
  //
  //

  @override
  T copy<T extends Model>() {
    return (___CLASS___.unsafe()..updateWith(this)) as T;
  }

  //
  //
  //

  @override
  T copyWith<T extends Model>(
    T other,
  ) {
    if (other is ___CLASS___) {
       return this.copy<T>()..updateWith(other);
    }
    assert(false);
    return this.copy<T>();
  }

  //
  //
  //

  @override
  T copyWithJMap<T extends Model>(
    JMap other,
  ) {
    if (other.isNotEmpty) {
       return this.copy<T>()..updateWithJMap(other);
    }
    return this.copy<T>();
  }

  //
  //
  //

  @override
  void updateWith<T extends Model>(
    T other,
  ) {
    if (other is ___CLASS___) {
    ___P8___
    } else {
      assert(false);
    }
  }

  //
  //
  //

  @override
  void updateWithJMap<T extends Model>(
    JMap other,
  ) {
   this.updateWith(___CLASS___.fromJMap(other));
  }
}
````