enum Flavor {
  dev,
  staging,
  prod,
}

class FlavorConfig {
  final Flavor flavor;
  final String name;
  final String apiUrl;

  static FlavorConfig? _instance;

  factory FlavorConfig({required Flavor flavor, required String name, required String apiUrl}) {
    _instance ??= FlavorConfig._internal(flavor, name, apiUrl);
    return _instance!;
  }

  FlavorConfig._internal(this.flavor, this.name, this.apiUrl);

  static FlavorConfig get instance => _instance!;
}
