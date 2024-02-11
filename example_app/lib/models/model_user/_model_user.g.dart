//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// GENERATED BY XYZ_GEN - DO NOT MODIFY BY HAND
// See: https://github.com/robmllze/xyz_gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

// ignore_for_file: invalid_null_aware_operator
// ignore_for_file: unnecessary_non_null_assertion
// ignore_for_file: unnecessary_null_comparison

part of 'model_user.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class ModelUser {
  //
  //
  //

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
  });

  //
  //
  //

  factory ModelUser.fromJson(
    Map<String, dynamic> input,
  ) {
    return ModelUser(
      displayName: input[K_DISPLAY_NAME]?.toString().trim().nullIfEmpty,
      email: input[K_EMAIL]?.toString().trim().nullIfEmpty?.toLowerCase(),
      firstName: input[K_FIRST_NAME]?.toString().trim().nullIfEmpty,
      lastName: input[K_LAST_NAME]?.toString().trim().nullIfEmpty,
      searchableName: input[K_SEARCHABLE_NAME]
          ?.toString()
          .trim()
          .nullIfEmpty
          ?.toLowerCase(),
      type: input[K_TYPE]?.toString().trim().nullIfEmpty?.toUpperSnakeCase(),
    );
  }

  //
  //
  //

  Map<String, dynamic> toJson() {
    return {
      K_DISPLAY_NAME: displayName?.toString().trim().nullIfEmpty,
      K_EMAIL: email?.toString().trim().nullIfEmpty?.toLowerCase(),
      K_FIRST_NAME: firstName?.toString().trim().nullIfEmpty,
      K_LAST_NAME: lastName?.toString().trim().nullIfEmpty,
      K_SEARCHABLE_NAME:
          searchableName?.toString().trim().nullIfEmpty?.toLowerCase(),
      K_TYPE: type?.toString().trim().nullIfEmpty?.toUpperSnakeCase(),
    };
  }

  //
  //
  //

  static const K_DISPLAY_NAME = "display_name";
  static const K_EMAIL = "email";
  static const K_FIRST_NAME = "first_name";
  static const K_LAST_NAME = "last_name";
  static const K_SEARCHABLE_NAME = "searchable_name";
  static const K_TYPE = "type";
}
