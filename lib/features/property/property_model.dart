enum PropertyType { apartment, house, condo, townhouse, studio }

class PropertyModel {
  final String id;
  final String title;
  final String city;
  final String neighborhood;
  final String address;
  final String zipCode;
  final int price;
  final int bedrooms;
  final int bathrooms;
  final int sqft;
  final PropertyType type;
  final String imageUrl;

  const PropertyModel({
    required this.id,
    required this.title,
    required this.city,
    required this.neighborhood,
    required this.address,
    required this.zipCode,
    required this.price,
    required this.bedrooms,
    required this.bathrooms,
    required this.sqft,
    required this.type,
    required this.imageUrl,
  });
}
