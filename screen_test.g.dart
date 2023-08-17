@GenerateScreenBlahBlah(options: {"hello", "world"})
class ScreenTest {
  final String? key;
  const ScreenTest({
    this.key,
  });
}

class GenerateScreenBlahBlah {
  final Set<String> options;
  const GenerateScreenBlahBlah({
    this.options = const {},
  });
}
