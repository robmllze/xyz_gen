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

part of 'example.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class ModelUser extends Model {
  //
  //
  //

  static const CLASS = 'ModelUser';
  static const MODEL_ID = 'model_user';

  static const K_DISPLAY_NAME = 'display_name';
  static const K_EMAIL = 'email';
  static const K_FIRST_NAME = 'first_name';
  static const K_LAST_NAME = 'last_name';
  static const K_SEARCHABLE_NAME = 'searchable_name';
  static const K_TYPE = 'type';

  String? displayName;
  String? email;
  String? firstName;
  String? lastName;
  String? searchableName;
  String? type;

  //
  //
  //

  ModelUser({
    this.displayName,
    this.email,
    this.firstName,
    this.lastName,
    this.searchableName,
    this.type,
  }) {}

  //
  //
  //

  ModelUser.unsafe({
    this.displayName,
    this.email,
    this.firstName,
    this.lastName,
    this.searchableName,
    this.type,
  }) {}

  //
  //
  //

  factory ModelUser.from(
    Model? other,
  ) {
    return ModelUser.fromJson(
      other is GenericModel ? other.data : other?.toJson(),
    );
  }

  //
  //
  //

  factory ModelUser.of(
    ModelUser? other,
  ) {
    return ModelUser.fromJson(other?.toJson());
  }

  //
  //
  //

  factory ModelUser.fromUri(
    Uri? uri,
  ) {
    try {
      if (uri != null && uri.path == MODEL_ID) {
        return ModelUser.fromJson(uri.queryParameters);
      } else {
        return ModelUser.unsafe();
      }
    } catch (e) {
      assert(false, e);
      rethrow;
    }
  }

  //
  //
  //

  factory ModelUser.fromJsonString(
    String? source,
  ) {
    try {
      if (source != null && source.isNotEmpty) {
        final decoded = jsonDecode(source);
        return ModelUser.fromJson(decoded);
      } else {
        return ModelUser.unsafe();
      }
    } catch (e) {
      assert(false, e);
      rethrow;
    }
  }

  //
  //
  //

  factory ModelUser.fromJson(
    Map<String, dynamic>? data,
  ) {
    try {
      return ModelUser.unsafe(
        displayName: data?[K_DISPLAY_NAME]?.toString().trim().nullIfEmpty,
        email: data?[K_EMAIL]?.toString().trim().nullIfEmpty?.toLowerCase(),
        firstName: data?[K_FIRST_NAME]?.toString().trim().nullIfEmpty,
        lastName: data?[K_LAST_NAME]?.toString().trim().nullIfEmpty,
        searchableName: data?[K_SEARCHABLE_NAME]
            ?.toString()
            .trim()
            .nullIfEmpty
            ?.toLowerCase(),
        type: data?[K_TYPE]?.toString().trim().nullIfEmpty?.toUpperSnakeCase(),
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
  Map<String, dynamic> toJson({
    dynamic defaultValue,
    bool includeNulls = false,
  }) {
    try {
      final withNulls = <String, dynamic>{
        K_DISPLAY_NAME: displayName?.toString().trim().nullIfEmpty,
        K_EMAIL: email?.toString().trim().nullIfEmpty?.toLowerCase(),
        K_FIRST_NAME: firstName?.toString().trim().nullIfEmpty,
        K_LAST_NAME: lastName?.toString().trim().nullIfEmpty,
        K_SEARCHABLE_NAME:
            searchableName?.toString().trim().nullIfEmpty?.toLowerCase(),
        K_TYPE: type?.toString().trim().nullIfEmpty?.toUpperSnakeCase(),
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
    return ModelUser.unsafe() as T;
  }

  //
  //
  //

  @override
  T copy<T extends Model>() {
    return (ModelUser.unsafe()..updateWith(this)) as T;
  }

  //
  //
  //

  @override
  void updateWithJson(
    Map<String, dynamic>? data,
  ) {
    if (data != null && data.isNotEmpty) {
      this.displayName =
          letAs<String?>(data?[K_DISPLAY_NAME]) ?? this.displayName;
      this.email = letAs<String?>(data?[K_EMAIL]) ?? this.email;
      this.firstName = letAs<String?>(data?[K_FIRST_NAME]) ?? this.firstName;
      this.lastName = letAs<String?>(data?[K_LAST_NAME]) ?? this.lastName;
      this.searchableName =
          letAs<String?>(data?[K_SEARCHABLE_NAME]) ?? this.searchableName;
      this.type = letAs<String?>(data?[K_TYPE]) ?? this.type;
    }
  }

  //
  //
  //

  @override
  String get modelId => MODEL_ID;
}
