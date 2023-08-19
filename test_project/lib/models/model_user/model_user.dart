import 'package:xyz_gen/generate_model.dart';

part 'model_user.g.dart';

@GenerateModel(
  className: "ModelUser",
  collectionPath: "users",
  parameters: {
    "firstName": "String",
    "lastName": "String",
    "displayName": "String",
  },
)
// ignore: must_be_immutable
abstract class ModelUserUtils {}
