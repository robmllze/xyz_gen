//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// X|Y|Z & Dev
//
// Copyright Ⓒ Robert Mollentze (https://xyzand.dev)
// 
// Licensing details can be found in the LICENSE file in the root directory.
// 
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:xyz_gen_annotations/xyz_gen_annotations.dart';

part '_model_user.g.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

// This is just one of many generators included in the `xyz_gen` package! This
// Model generator is much more flexible than `json_serializable` and easier
// to use in your project.

@GenerateModel(
  fields: {
    "email": $LowerCaseString,
    "searchable_name": $LowerCaseString,
    "display_name": "String?",
    "type": $UpperSnakeCaseString,
  },
  shouldInherit: false,
  keyStringCase: "lower_snake_case",
  includeId: false,
  includeArgs: false,
)
// ignore: unused_element
abstract class _ModelUser {
  @Field()
  String? firstName;

  @Field()
  String? lastName;
}

enum ModelUserType {
  ADMIN,
  USER,
}