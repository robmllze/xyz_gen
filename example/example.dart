//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// 🇽🇾🇿 & Dev
//
// Copyright Ⓒ Robert Mollentze, xyzand.dev
//
// Licensing details can be found in the LICENSE file in the root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:xyz_gen_annotations/xyz_gen_annotations.dart';

part '_model_user.g.dart';

// -----------------------------------------------------------------------------

// This is just one of many generators included in the `xyz_gen` package! This
// Model generator is much more flexible than `json_serializable` and easier
// to use in your project.

@GenerateModel(
  fields: {
    'email': $LowerCaseString,
    'searchable_name': $LowerCaseString,
    'display_name': 'String?',
    'type': $UpperSnakeCaseString,
  },
  shouldInherit: true,
  keyStringCase: 'lower_snake_case',
)

// -----------------------------------------------------------------------------

// ignore: unused_element
abstract class _ModelUser extends ThisModel<ModelUser> {
  @Field()
  String? firstName;

  @Field()
  String? lastName;

  String get fullName => '$firstName $lastName';

  bool get isAdmin => this.model.type == ModelUserType.ADMIN.name;
  bool get isUser => this.model.type == ModelUserType.USER.name;

  bool emailContains(String value) {
    return this.model.email?.contains(value.toLowerCase()) == true;
  }

  bool nameContains(String value) {
    return this.model.searchableName?.contains(value.toLowerCase()) == true;
  }
}

// -----------------------------------------------------------------------------

enum ModelUserType {
  ADMIN,
  USER,
}
