import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:worksquare_housing/core/core.dart';
import 'package:worksquare_housing/features/property/property_model.dart';
import 'package:worksquare_housing/features/property/property_provider.dart';

class ListingDetailsScreen extends StatelessWidget {
  final PropertyModel property;
  const ListingDetailsScreen({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    final coord = _coordsForCity(property.city);
    final center = coord ?? const LatLng(0, 0);
    final markerList = coord == null
        ? <Marker>[]
        : [
            Marker(
              point: coord,
              width: 40,
              height: 40,
              child: const Icon(Icons.location_pin, color: AppColor.brandBlue),
            ),
          ];
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppColor.brandBlue,
            leading: Padding(
              padding: const EdgeInsets.all(12),
              child: InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: AppColor.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColor.white, width: 1.2),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.arrow_back, color: AppColor.white),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: property.imageUrl,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColor.black.withValues(alpha: 0.0),
                          AppColor.black.withValues(alpha: 0.35),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColor.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        NumberFormat.currency(
                          symbol: '₦',
                          decimalDigits: 0,
                        ).format(property.price),
                        style: AppTypography.text16.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              property.title,
                              style: AppTypography.text20.bold,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${property.city}, ${property.neighborhood}',
                              style: AppTypography.text16.withCustomColor(
                                AppColor.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Consumer<PropertyProvider>(
                        builder: (context, provider, _) {
                          final fav = provider.isFavorite(property.id);
                          return IconButton(
                            icon: Icon(
                              fav ? Icons.favorite : Icons.favorite_border,
                              color: fav
                                  ? AppColor.brandOrange
                                  : AppColor.brandBlue,
                            ),
                            onPressed: () => provider.toggleFavorite(property),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      _Chip(icon: Icons.bed, label: '${property.bedrooms} bd'),
                      _Chip(
                        icon: Icons.bathtub,
                        label: '${property.bathrooms} ba',
                      ),
                      _Chip(
                        icon: Icons.aspect_ratio,
                        label: '${property.sqft} sqft',
                      ),
                      _Chip(
                        icon: Icons.home_work,
                        label: _label(property.type),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.black.withValues(alpha: 0.06),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Description', style: AppTypography.text18.bold),
                        const SizedBox(height: 8),
                        Text(
                          'A beautifully finished home located in a prime neighborhood. '
                          'Spacious living areas, modern kitchen fittings, ample natural light, '
                          'and secure parking. Close to schools, shopping, and public transport. '
                          'Perfect for families and professionals seeking comfort and convenience.',
                          style: AppTypography.text14.withCustomColor(
                            AppColor.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.black.withValues(alpha: 0.06),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Location', style: AppTypography.text18.bold),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: SizedBox(
                            height: 220,
                            child: FlutterMap(
                              options: MapOptions(
                                initialCenter: center,
                                initialZoom: coord == null ? 2 : 12,
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate:
                                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                ),
                                MarkerLayer(markers: markerList),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _label(PropertyType t) {
    switch (t) {
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

  LatLng? _coordsForCity(String city) {
    switch (city.toLowerCase()) {
      case 'lagos':
        return const LatLng(6.5244, 3.3792);
      case 'abuja':
        return const LatLng(9.0765, 7.3986);
      case 'ogun':
        return const LatLng(7.1475, 3.3619);
      case 'ikeja':
        return const LatLng(6.6018, 3.3515);
      case 'surulere':
        return const LatLng(6.5013, 3.3316);
      case 'ikoyi':
        return const LatLng(6.4549, 3.4389);
      case 'victoria island':
        return const LatLng(6.4281, 3.4219);
      case 'asokoro':
        return const LatLng(9.03, 7.51);
      case 'wuse 2':
        return const LatLng(9.07, 7.46);
      default:
        return null;
    }
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Chip({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 18, color: AppColor.brandBlue),
      label: Text(label, style: AppTypography.text14),
      backgroundColor: AppColor.lightGrey.withValues(alpha: 0.3),
    );
  }
}
