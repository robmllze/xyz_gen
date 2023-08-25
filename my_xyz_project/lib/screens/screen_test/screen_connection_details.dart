import 'package:xyz_gen/generate_screen_configurations/annotation.dart';

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
