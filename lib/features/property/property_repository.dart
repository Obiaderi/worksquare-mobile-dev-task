import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart' show rootBundle;

import 'property_model.dart';

class PropertyRepository {
  Future<List<PropertyModel>> fetchAll() async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      final raw = await rootBundle.loadString('assets/listings.json');
      final decoded = jsonDecode(raw);
      if (decoded is! List) {
        throw const FormatException('Expected a JSON array');
      }
      final list = decoded.cast<Map<String, dynamic>>();
      return list.map(_fromJson).toList();
    } catch (_) {
      return _generateFallback();
    }
  }

  PropertyModel _fromJson(Map<String, dynamic> j) {
    final id = j['id']?.toString() ?? _randId();
    final status = j['status'];
    final statusType = (status is List && status.isNotEmpty)
        ? status.first.toString().toLowerCase()
        : '';
    final typeStr = (j['type'] ?? statusType).toString().toLowerCase();
    final type = _parseTypeFromSchema(typeStr);

    final loc = j['location']?.toString();
    final city = j['city']?.toString() ?? _cityFromLocation(loc) ?? 'Unknown';
    final neighborhood =
        j['neighborhood']?.toString() ??
        _neighborhoodFromLocation(loc) ??
        'Unknown';

    final price = _parsePrice(j['price']);
    final imageUrl = _normalizeImageUrl(
      j['imageUrl']?.toString() ?? j['image']?.toString(),
      id,
    );

    return PropertyModel(
      id: id,
      title: j['title']?.toString() ?? _typeLabel(type),
      city: city,
      neighborhood: neighborhood,
      address: j['address']?.toString() ?? 'N/A',
      zipCode: j['zipCode']?.toString() ?? '',
      price: price,
      bedrooms: _toInt(j['bedrooms'], defaultValue: 0),
      bathrooms: _toInt(j['bathrooms'], defaultValue: 0),
      sqft: _toInt(j['sqft'], defaultValue: 0),
      type: type,
      imageUrl: imageUrl,
    );
  }

  int _toInt(Object? v, {int defaultValue = 0}) {
    if (v == null) return defaultValue;
    if (v is int) return v;
    if (v is double) return v.round();
    final s = v.toString();
    return int.tryParse(s) ?? defaultValue;
  }

  String _typeLabel(PropertyType type) {
    switch (type) {
      case PropertyType.apartment:
        return 'Apartment';
      case PropertyType.house:
        return 'House';
      case PropertyType.condo:
        return 'Condo';
      case PropertyType.townhouse:
        return 'Townhouse';
      case PropertyType.studio:
        return 'Studio';
    }
  }

  List<PropertyModel> _generateFallback() {
    final rand = Random(42);
    final cities = [
      'San Francisco',
      'New York',
      'Austin',
      'Seattle',
      'Chicago',
    ];
    final neighborhoods = {
      'San Francisco': ['SoMa', 'Mission', 'Sunset'],
      'New York': ['Brooklyn', 'Queens', 'Manhattan'],
      'Austin': ['Downtown', 'South Congress', 'East Austin'],
      'Seattle': ['Capitol Hill', 'Ballard', 'Fremont'],
      'Chicago': ['Lincoln Park', 'Wicker Park', 'River North'],
    };
    final zips = ['94103', '11201', '73301', '98102', '60614'];
    final types = PropertyType.values;
    List<PropertyModel> items = [];
    for (int i = 0; i < 60; i++) {
      final city = cities[i % cities.length];
      final hoodList = neighborhoods[city]!;
      final hood = hoodList[rand.nextInt(hoodList.length)];
      final price = 120000 + rand.nextInt(1800000);
      final beds = 1 + rand.nextInt(5);
      final baths = 1 + rand.nextInt(4);
      final sqft = 450 + rand.nextInt(3500);
      final type = types[rand.nextInt(types.length)];
      final zip = zips[i % zips.length];
      items.add(
        PropertyModel(
          id: 'prop_$i',
          title: '${_typeLabel(type)} in $hood',
          city: city,
          neighborhood: hood,
          address: '${100 + rand.nextInt(900)} Market St',
          zipCode: zip,
          price: price,
          bedrooms: beds,
          bathrooms: baths,
          sqft: sqft,
          type: type,
          imageUrl: 'https://picsum.photos/seed/property_$i/600/400',
        ),
      );
    }
    return items;
  }

  String _randId() => 'prop_${Random().nextInt(999999)}';

  String _normalizeImageUrl(String? hint, String id) {
    if (hint == null || hint.isEmpty) {
      return 'https://picsum.photos/seed/$id/800/500';
    }
    final lower = hint.toLowerCase();
    final looksUrl =
        lower.startsWith('http://') || lower.startsWith('https://');
    if (looksUrl) return hint;
    final seed = hint.replaceAll(RegExp(r'[^a-z0-9]'), '_');
    return 'https://picsum.photos/seed/${seed}_$id/800/500';
  }

  int _parsePrice(Object? v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is double) return v.round();
    final s = v.toString();
    final digits = s.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(digits) ?? 0;
  }

  PropertyType _parseTypeFromSchema(String s) {
    switch (s) {
      case 'house':
      case 'duplex':
        return PropertyType.house;
      case 'flat':
      case 'apartment':
        return PropertyType.apartment;
      case 'terrace':
        return PropertyType.townhouse;
      case 'penthouse':
      case 'condo':
        return PropertyType.condo;
      case 'studio':
        return PropertyType.studio;
      default:
        return PropertyType.apartment;
    }
  }

  String? _cityFromLocation(String? loc) {
    if (loc == null || loc.isEmpty) return null;
    final parts = loc.split(',');
    if (parts.isEmpty) return null;
    return parts.last.trim();
  }

  String? _neighborhoodFromLocation(String? loc) {
    if (loc == null || loc.isEmpty) return null;
    final parts = loc.split(',');
    if (parts.length < 2) return parts.first.trim();
    return parts.first.trim();
  }
}
