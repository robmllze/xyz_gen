
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

part of 'example.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class ModelUser extends _ModelUser {
  //
  //
  //

  static const K_CHILD = 'child';
  static const K_EMAIL = 'email';
  static const K_FIRST_NAME = 'first_name';
  static const K_ID = 'id';
  static const K_LAST_NAME = 'last_name';

  static const CLASS = 'ModelUser';

  @override
  String get $class => CLASS;

  ModelUser? _child;
  String? _email;
  String? _firstName;
  String? _id;
  String? _lastName;

  //
  //
  //

  ModelUser.empty();

  //
  //
  //

  factory ModelUser({
    ModelUser? child,
    String? email,
    String? firstName,
    String? id,
    String? lastName,
  }) {
    return ModelUser.b(
      child: child,
      email: email,
      firstName: firstName,
      id: id,
      lastName: lastName,
    );
  }

  //
  //
  //

  ModelUser.b({
    ModelUser? child,
    String? email,
    String? firstName,
    String? id,
    String? lastName,
  }) {
    this._child = child;
    this._email = email;
    this._firstName = firstName;
    this._id = id;
    this._lastName = lastName;
  }

  //
  //
  //

  factory ModelUser.from(
    Model? other,
  ) {
    return ModelUser.fromJson(
      letAs<GenericModel>(other)?.data ?? other?.toJson(),
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

  factory ModelUser.fromJsonString(
    String? source,
  ) {
    try {
      if (source != null && source.isNotEmpty) {
        final decoded = jsonDecode(source);
        return ModelUser.fromJson(decoded);
      } else {
        return ModelUser.empty();
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
    Map<String, dynamic>? otherData,
  ) {
    try {
      return ModelUser.empty()
        ..$child = otherData?[K_CHILD]
        ..$email = otherData?[K_EMAIL]
        ..$firstName = otherData?[K_FIRST_NAME]
        ..$id = otherData?[K_ID]
        ..$lastName = otherData?[K_LAST_NAME];
    } catch (e) {
      assert(false, e);
      rethrow;
    }
  }

  //
  //
  //

  factory ModelUser.fromUri(
    Uri? uri,
  ) {
    try {
      if (uri != null && uri.path == CLASS) {
        return ModelUser.fromJson(uri.queryParameters);
      } else {
        return ModelUser.b();
      }
    } catch (e) {
      assert(false, e);
      rethrow;
    }
  }

  //
  //
  //

  static ModelUser? convert(
    Model? other,
  ) {
    return other != null ? ModelUser.from(other) : null;
  }

  //
  //
  //

  static ModelUser? fromPool({
    required Iterable<ModelUser>? pool,
    required String? id,
  }) {
    return id != null ? pool?.firstWhereOrNull((e) => e.id == id) : null;
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
        K_CHILD: this.$child,
        K_EMAIL: this.$email,
        K_FIRST_NAME: this.$firstName,
        K_ID: this.$id,
        K_LAST_NAME: this.$lastName,
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
      if (other._child != null) {
        this.child = other._child!;
      }
      if (other._email != null) {
        this.email = other._email!;
      }
      if (other._firstName != null) {
        this.firstName = other._firstName!;
      }
      if (other._id != null) {
        this.id = other._id!;
      }
      if (other._lastName != null) {
        this.lastName = other._lastName!;
      }
    }
  }

  //
  //
  //

  // child.
  ModelUser? get child => this._child;
  set child(ModelUser? v) => this._child = v;
  dynamic get $child => this._child?.toJson();
  set $child(v) => this._child = () {
        final a = letMap<String, dynamic>(v);
        return a != null ? ModelUser.fromJson(a) : null;
      }();

  // email.
  String? get email => this._email;
  set email(String? v) => this._email = v;
  dynamic get $email => this._email?.toString().trim().nullIfEmpty?.toLowerCase();
  set $email(v) => this._email = v?.toString().trim().nullIfEmpty?.toLowerCase();

  // firstName.
  String? get firstName => this._firstName;
  set firstName(String? v) => this._firstName = v;
  dynamic get $firstName => this._firstName?.toString().trim().nullIfEmpty;
  set $firstName(v) => this._firstName = v?.toString().trim().nullIfEmpty;

  // id.
  String? get id => this._id;
  set id(String? v) => this._id = v;
  dynamic get $id => this._id?.toString().trim().nullIfEmpty;
  set $id(v) => this._id = v?.toString().trim().nullIfEmpty;

  // lastName.
  String? get lastName => this._lastName;
  set lastName(String? v) => this._lastName = v;
  dynamic get $lastName => this._lastName?.toString().trim().nullIfEmpty;
  set $lastName(v) => this._lastName = v?.toString().trim().nullIfEmpty;
}
