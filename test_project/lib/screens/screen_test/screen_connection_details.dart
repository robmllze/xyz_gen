import 'package:xyz_gen/generate_screen_configuration/parts/_generate_screen_configuration_file.dart';

@GenerateScreenConfiguration(
  isOnlyAccessibleIfSignedInAndVerified: true,
  isRedirectable: false,
  internalParameters: {
    "target": "ModelUserData",
  },
)
class ScreenConnectionDetails {
  final String? key;
  const ScreenConnectionDetails({
    this.key,
  });
}
