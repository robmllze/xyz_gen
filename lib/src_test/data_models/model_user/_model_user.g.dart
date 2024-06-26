//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// GENERATED BY 🇽🇾🇿 GEN - DO NOT MODIFY BY HAND
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

part of 'model_user.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class ModelUser extends _ModelUser {
  //
  //
  //

  static const K_TOETS = 'toets';
  static const K_TEST = 'test';

  static const CLASS = 'ModelUser';

  @override
  String get $class => CLASS;

  int? toets;
  Map<String, List<Map<String, ModelUser>>>? test;

  //
  //
  //

  ModelUser.empty();

  //
  //
  //

  factory ModelUser({
    int? toets,
    required Map<String, List<Map<String, ModelUser>>> test,
  }) {
    return ModelUser.b(
      toets: toets,
      test: test,
    );
  }

  //
  //
  //

  ModelUser.b({
    this.toets,
    this.test,
  }) {
    assert(this.toets != null);
  }

  //
  //
  //

  factory ModelUser.from(
    Model? other,
  ) {
    try {
      return fromOrNull(other)!;
    } catch (e) {
      assert(false, 'ModelUser.from: $e');
      rethrow;
    }
  }

  static ModelUser? fromOrNull(
    Model? other,
  ) {
    return fromJsonOrNull(other?.toJson())!;
  }

  //
  //
  //

  factory ModelUser.of(
    ModelUser other,
  ) {
    try {
      return ofOrNull(other)!;
    } catch (e) {
      assert(false, 'ModelUser.of: $e');
      rethrow;
    }
  }

  static ModelUser? ofOrNull(
    ModelUser? other,
  ) {
    return fromJsonOrNull(other?.toJson());
  }

  //
  //
  //

  factory ModelUser.fromJsonString(
    String source,
  ) {
    try {
      return fromJsonStringOrNull(source)!;
    } catch (e) {
      assert(false, 'ModelUser.fromJsonString: $e');
      rethrow;
    }
  }

  static ModelUser? fromJsonStringOrNull(
    String? source,
  ) {
    try {
      if (source!.isNotEmpty) {
        final decoded = jsonDecode(source);
        return ModelUser.fromJson(decoded);
      } else {
        return ModelUser.empty();
      }
    } catch (_) {
      return null;
    }
  }

  //
  //
  //

  factory ModelUser.fromJson(
    Map<String, dynamic>? otherData,
  ) {
    try {
      return fromJsonOrNull(otherData)!;
    } catch (e) {
      assert(false, 'ModelUser.fromJson: $e');
      rethrow;
    }
  }

  static ModelUser? fromJsonOrNull(
    Map<String, dynamic>? otherData,
  ) {
    try {
      return ModelUser.empty()
        ..$toets = otherData?[K_TOETS]
        ..$test = otherData?[K_TEST];
    } catch (e) {
      return null;
    }
  }

  //
  //
  //

  factory ModelUser.fromUri(
    Uri? uri,
  ) {
    try {
      return fromUriOrNull(uri)!;
    } catch (e) {
      assert(false, 'ModelUser.fromUri: $e');
      rethrow;
    }
  }

  static ModelUser? fromUriOrNull(
    Uri? uri,
  ) {
    try {
      if (uri != null && uri.path == CLASS) {
        return ModelUser.fromJson(uri.queryParameters);
      } else {
        return ModelUser.empty();
      }
    } catch (_) {
      return null;
    }
  }

  //
  //
  //

  @override
  Map<String, dynamic> toJson({
    dynamic defaultValue,
    bool includeNulls = false,
  }) {
    try {
      final withNulls = <String, dynamic>{
        K_TOETS: this.$toets,
        K_TEST: this.$test,
      }.mapWithDefault(defaultValue);
      return includeNulls ? withNulls : withNulls.nonNulls;
    } catch (e) {
      assert(false, 'ModelUser.toJson: $e');
      rethrow;
    }
  }

  //
  //
  //

  @override
  T empty<T extends Model>() {
    return ModelUser.b() as T;
  }

  //
  //
  //

  @override
  T copy<T extends Model>() {
    return (ModelUser.b()..updateWith(this)) as T;
  }

  //
  //
  //

  @override
  void updateWithJson(
    Map<String, dynamic>? otherData,
  ) {
    if (otherData != null && otherData.isNotEmpty) {
      final other = ModelUser.fromJson(otherData);
      if (other.toets != null) {
        this.toets = other.toets!;
      }
      if (other.test != null) {
        this.test = other.test!;
      }
    }
  }

  //
  //
  //

  // toets.
  int? get toetsField => this.toets;
  set toetsField(int? v) => this.toets = v;
  @protected
  dynamic get $toets => this.toets;
  @protected
  set $toets(v) => this.toets = letInt(v);

  // test.
  Map<String, List<Map<String, ModelUser>>> get testField => this.test!;
  set testField(Map<String, List<Map<String, ModelUser>>> v) => this.test = v;
  @protected
  dynamic get $test => this
      .test
      ?.map(
        (p0, p1) => MapEntry(
          p0?.toString().trim().nullIfEmpty,
          p1
              ?.map(
                (p0) => p0
                    ?.map(
                      (p0, p1) => MapEntry(
                        p0?.toString().trim().nullIfEmpty?.toLowerCase(),
                        p1?.toJson(),
                      ),
                    )
                    .nonNulls
                    .nullIfEmpty,
              )
              .nonNulls
              .nullIfEmpty
              ?.toList(),
        ),
      )
      .nonNulls
      .nullIfEmpty;
  @protected
  set $test(v) => this.test = letMap(v)
      ?.map(
        (p0, p1) => MapEntry(
          p0?.toString().trim().nullIfEmpty,
          letList(p1)
              ?.map(
                (p0) => letMap(p0)
                    ?.map(
                      (p0, p1) => MapEntry(
                        p0?.toString().trim().nullIfEmpty?.toLowerCase(),
                        () {
                          final a = letMap<String, dynamic>(p1);
                          return a != null ? ModelUser.fromJson(a) : null;
                        }(),
                      ),
                    )
                    .nonNulls
                    .nullIfEmpty
                    ?.cast(),
              )
              .nonNulls
              .nullIfEmpty
              ?.toList()
              .cast(),
        ),
      )
      .nonNulls
      .nullIfEmpty
      ?.cast();
}
