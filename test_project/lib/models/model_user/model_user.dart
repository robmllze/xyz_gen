import 'package:xyz_gen/generate_models/annotation.dart';
import 'package:xyz_gen/generate_models/model.dart';
import 'package:xyz_gen/utils/helpers.dart';
import 'package:xyz_utils/xyz_utils.dart';

part 'model_user.g.dart';

@GenerateModel(
  className: "ModelUser",
  collectionPath: "users",
  parameters: {
    "id": "String",
    "args": "List<String>",
    "firstName": "String",
    "lastName": "String",
    "displayName": "String",
  },
)
// ignore: must_be_immutable
abstract class ModelUserUtils extends Model {
  ModelUserUtils._();
}
