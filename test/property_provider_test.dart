import 'package:flutter_test/flutter_test.dart';
import 'package:worksquare_housing/features/property/property_model.dart';
import 'package:worksquare_housing/features/property/property_provider.dart';

void main() {
  test('Provider loads and filters by city and type', () async {
    final provider = PropertyProvider();
    await provider.loadProperties();
    expect(provider.properties.isNotEmpty, true);

    final someCity = provider.cities.first;
    provider.setCity(someCity);
    expect(provider.properties.every((p) => p.city == someCity), true);

    provider.toggleType(PropertyType.house);
    expect(provider.properties.every((p) => p.city == someCity && p.type == PropertyType.house), true);
  });
}
