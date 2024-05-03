//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// 🇽🇾🇿 & Dev
//
// Licencing details are in the LICENSE file in the root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:xyz_gen_annotations/xyz_gen_annotations.dart';

part '_model_test.g.dart';

// -----------------------------------------------------------------------------

@GenerateModel(
  fields: {
    F('id', 'String?'),
    F('email', $LowerCaseString),
    F('searchable_name', $SearchableString),
    F('name', String),
    F('date', DateTime, nullable: true),
    F('test2', Map<String, List<int>>),
  },
  shouldInherit: true,
)
abstract class _ModelTest extends Model {
  @Field()
  late String firstName;

  @Field()
  String? lastName;

  @Field()
  late Map<DateTime, List<Set<ModelTest>>?> toets;

  String get fullName => '$firstName $lastName';
}
