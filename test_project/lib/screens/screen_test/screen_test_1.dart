import 'package:xyz_gen/generate_screen_access.dart';

@GenerateScreenAccess(
  isOnlyAccessibleIfSignedInAndVerified: true,
  // isOnlyAccessibleIfSignedIn: true,
  // isOnlyAccessibleIfSignedOut: true,
  isRedirectable: false,
)
class ScreenTest1 {
  final String? key;
  const ScreenTest1({
    this.key,
  });
}
