import 'package:xyz_gen/generate_screen_access.dart';

@GenerateScreenAccess(
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
