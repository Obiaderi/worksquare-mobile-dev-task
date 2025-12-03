import 'package:provider/provider.dart';
import 'package:worksquare_housing/core/core.dart';
import 'package:worksquare_housing/features/property/property_provider.dart';
import 'package:worksquare_housing/ui/listings/listings_screen.dart';
import 'package:worksquare_housing/ui/listings/widgets/property_card.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [ListingsScreen(), _FavoritesScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: AppColor.brandBlue,
        unselectedItemColor: AppColor.grey,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Listings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}

class _FavoritesScreen extends StatelessWidget {
  const _FavoritesScreen();

  @override
  Widget build(BuildContext context) {
    return Consumer<PropertyProvider>(
      builder: (context, provider, _) {
        final items = provider.favoritesList;
        return Scaffold(
          appBar: AppBar(title: const Text('Favorites')),
          body: items.isEmpty
              ? Center(
                  child: Text('No favorites yet', style: AppTypography.text16),
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  itemBuilder: (context, index) {
                    final p = items[index];
                    return PropertyCard(property: p, compact: true);
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemCount: items.length,
                ),
        );
      },
    );
  }
}
