import 'package:shared_preferences/shared_preferences.dart';
import 'package:worksquare_housing/core/core.dart';

import 'property_model.dart';
import 'property_repository.dart';

class PropertyProvider extends ChangeNotifier {
  final _repo = PropertyRepository();
  SharedPreferences? _prefs;

  List<PropertyModel> _all = [];
  List<PropertyModel> _visible = [];
  bool _loading = false;
  String? _error;
  bool _isGrid = true;
  Set<String> _favoriteIds = {};

  String? selectedCity;
  String? selectedNeighborhood;
  String? selectedZip;
  Set<PropertyType> selectedTypes = {};
  int? minPrice;
  int? maxPrice;
  int? bedrooms;
  int? bathrooms;
  String searchText = '';

  List<PropertyModel> get properties => _visible;
  bool get loading => _loading;
  String? get error => _error;
  bool get isGrid => _isGrid;
  Set<String> get favoriteIds => _favoriteIds;
  bool isFavorite(String id) => _favoriteIds.contains(id);
  bool get hasActiveFilters {
    return (selectedCity?.isNotEmpty == true) ||
        (selectedNeighborhood?.isNotEmpty == true) ||
        (selectedZip?.isNotEmpty == true) ||
        selectedTypes.isNotEmpty ||
        (minPrice != null && minPrice != globalMinPrice) ||
        (maxPrice != null && maxPrice != globalMaxPrice) ||
        bedrooms != null ||
        bathrooms != null ||
        searchText.trim().isNotEmpty;
  }

  int get globalMinPrice => _all.isEmpty
      ? 0
      : _all.map((e) => e.price).reduce((a, b) => a < b ? a : b);
  int get globalMaxPrice => _all.isEmpty
      ? 0
      : _all.map((e) => e.price).reduce((a, b) => a > b ? a : b);
  List<String> get cities => _unique(_all.map((e) => e.city));
  List<String> get neighborhoods => _unique(_all.map((e) => e.neighborhood));
  List<String> get zips => _unique(_all.map((e) => e.zipCode));

  Future<void> loadProperties() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      await _initPrefs();
      await _loadFavorites();
      _all = await _repo.fetchAll();
      minPrice = globalMinPrice;
      maxPrice = globalMaxPrice;
      _applyFilters();
    } catch (e) {
      _error = 'Failed to load properties';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await loadProperties();
  }

  void toggleLayout() {
    _isGrid = !_isGrid;
    notifyListeners();
  }

  void setCity(String? value) {
    selectedCity = value;
    _applyFilters();
  }

  void setNeighborhood(String? value) {
    selectedNeighborhood = value;
    _applyFilters();
  }

  void setZip(String? value) {
    selectedZip = value;
    _applyFilters();
  }

  void toggleType(PropertyType type) {
    if (selectedTypes.contains(type)) {
      selectedTypes.remove(type);
    } else {
      selectedTypes.add(type);
    }
    _applyFilters();
  }

  void setPriceRange(int min, int max) {
    minPrice = min;
    maxPrice = max;
    _applyFilters();
  }

  void setBedrooms(int? value) {
    bedrooms = value;
    _applyFilters();
  }

  void setBathrooms(int? value) {
    bathrooms = value;
    _applyFilters();
  }

  void setSearch(String value) {
    searchText = value;
    _applyFilters();
  }

  void clearFilters() {
    selectedCity = null;
    selectedNeighborhood = null;
    selectedZip = null;
    selectedTypes.clear();
    bedrooms = null;
    bathrooms = null;
    searchText = '';
    minPrice = globalMinPrice;
    maxPrice = globalMaxPrice;
    _applyFilters();
  }

  Future<void> toggleFavorite(PropertyModel property) async {
    if (_favoriteIds.contains(property.id)) {
      _favoriteIds.remove(property.id);
    } else {
      _favoriteIds.add(property.id);
    }
    await _saveFavorites();
    notifyListeners();
  }

  List<PropertyModel> get favoritesList =>
      _all.where((p) => _favoriteIds.contains(p.id)).toList();

  Future<void> _loadFavorites() async {
    try {
      final list = _prefs?.getStringList('favorite_ids') ?? [];
      _favoriteIds = list.toSet();
    } catch (_) {}
  }

  Future<void> _saveFavorites() async {
    try {
      await _prefs?.setStringList('favorite_ids', _favoriteIds.toList());
    } catch (_) {}
  }

  Future<void> _initPrefs() async {
    try {
      _prefs ??= await SharedPreferences.getInstance();
    } catch (_) {}
  }

  void _applyFilters() {
    Iterable<PropertyModel> list = _all;
    if (selectedCity != null && selectedCity!.isNotEmpty) {
      list = list.where((e) => e.city == selectedCity);
    }
    if (selectedNeighborhood != null && selectedNeighborhood!.isNotEmpty) {
      list = list.where((e) => e.neighborhood == selectedNeighborhood);
    }
    if (selectedZip != null && selectedZip!.isNotEmpty) {
      list = list.where((e) => e.zipCode == selectedZip);
    }
    if (selectedTypes.isNotEmpty) {
      list = list.where((e) => selectedTypes.contains(e.type));
    }
    if (minPrice != null) {
      list = list.where((e) => e.price >= minPrice!);
    }
    if (maxPrice != null) {
      list = list.where((e) => e.price <= maxPrice!);
    }
    if (bedrooms != null) {
      list = list.where((e) => e.bedrooms >= bedrooms!);
    }
    if (bathrooms != null) {
      list = list.where((e) => e.bathrooms >= bathrooms!);
    }
    final q = searchText.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list.where(
        (e) =>
            e.title.toLowerCase().contains(q) ||
            e.address.toLowerCase().contains(q) ||
            e.city.toLowerCase().contains(q) ||
            e.neighborhood.toLowerCase().contains(q),
      );
    }
    _visible = list.toList();
    notifyListeners();
  }

  List<String> _unique(Iterable<String> source) {
    final set = <String>{}..addAll(source);
    final list = set.toList();
    list.sort();
    return list;
  }
}
