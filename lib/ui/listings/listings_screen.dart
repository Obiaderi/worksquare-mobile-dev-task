import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:worksquare_housing/core/core.dart';
import 'package:worksquare_housing/features/property/property_model.dart';
import 'package:worksquare_housing/features/property/property_provider.dart';

import 'widgets/property_card.dart';

class ListingsScreen extends StatefulWidget {
  const ListingsScreen({super.key});

  @override
  State<ListingsScreen> createState() => _ListingsScreenState();
}

class _ListingsScreenState extends State<ListingsScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PropertyProvider>().loadProperties();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PropertyProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: AppBar(
            title: TextField(
              controller: _searchController,
              onChanged: provider.setSearch,
              style: AppTypography.text16.withCustomColor(AppColor.white),
              decoration: InputDecoration(
                hintText: 'Search properties',
                hintStyle: AppTypography.text14.withCustomColor(
                  AppColor.white.withValues(alpha: 0.7),
                ),
                border: InputBorder.none,
              ),
            ),
            backgroundColor: AppColor.brandBlue,
            actions: [
              IconButton(
                icon: Icon(
                  provider.isGrid ? Icons.view_list : Icons.grid_view,
                  color: AppColor.white,
                ),
                onPressed: provider.toggleLayout,
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: provider.refresh,
            child: CustomScrollView(slivers: _buildSlivers(provider)),
          ),
        );
      },
    );
  }

  List<Widget> _buildSlivers(PropertyProvider provider) {
    final slivers = <Widget>[
      SliverToBoxAdapter(child: _FilterBar(provider: provider)),
    ];
    if (provider.loading) {
      slivers.add(
        const SliverFillRemaining(
          hasScrollBody: false,
          child: Center(child: CircularProgressIndicator()),
        ),
      );
      return slivers;
    }
    if (provider.error != null) {
      slivers.add(
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  provider.error!,
                  style: AppTypography.text16.withCustomColor(AppColor.red),
                ),
                SizedBox(height: 12.h),
                ElevatedButton(
                  onPressed: provider.loadProperties,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
      return slivers;
    }
    final items = provider.properties;
    if (items.isEmpty) {
      slivers.add(
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Text(
              'No properties match your filters',
              style: AppTypography.text16,
            ),
          ),
        ),
      );
      return slivers;
    }
    slivers.add(provider.isGrid ? _sliverGrid(items) : _sliverList(items));
    return slivers;
  }

  Widget _sliverGrid(List items) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: ScreenUtil().screenWidth > 600 ? 3 : 2,
          mainAxisSpacing: 12.h,
          crossAxisSpacing: 12.w,
          childAspectRatio: 0.6,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          final p = items[index] as PropertyModel;
          return PropertyCard(property: p);
        }, childCount: items.length),
      ),
    );
  }

  Widget _sliverList(List items) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final p = items[index] as PropertyModel;
          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: PropertyCard(property: p, compact: true),
          );
        }, childCount: items.length),
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  final PropertyProvider provider;
  const _FilterBar({required this.provider});

  @override
  Widget build(BuildContext context) {
    final priceRange = RangeValues(
      (provider.minPrice ?? provider.globalMinPrice).toDouble(),
      (provider.maxPrice ?? provider.globalMaxPrice).toDouble(),
    );
    return Container(
      color: AppColor.brandBlue,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Filters',
                  style: AppTypography.text14.bold.withCustomColor(
                    AppColor.white,
                  ),
                ),
              ),
              if (provider.hasActiveFilters) _clearButton(provider),
            ],
          ),
          SizedBox(height: 6.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 4.h,
            children: PropertyType.values.map((t) {
              final selected = provider.selectedTypes.contains(t);
              return FilterChip(
                label: Text(_typeLabel(t), style: AppTypography.text12),
                selected: selected,
                onSelected: (_) => provider.toggleType(t),
                selectedColor: AppColor.white,
                backgroundColor: AppColor.brandBlue.withValues(alpha: 0.4),
                labelStyle: AppTypography.text12.withCustomColor(
                  selected ? AppColor.brandBlue : AppColor.white,
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 6.h),
          Row(
            children: [
              Text(
                'Price',
                style: AppTypography.text12.withCustomColor(AppColor.white),
              ),
              Expanded(
                child: RangeSlider(
                  values: priceRange,
                  min: provider.globalMinPrice.toDouble(),
                  max: provider.globalMaxPrice.toDouble(),
                  divisions: 20,
                  labels: RangeLabels(
                    _format(priceRange.start.toInt()),
                    _format(priceRange.end.toInt()),
                  ),
                  onChanged: (v) =>
                      provider.setPriceRange(v.start.toInt(), v.end.toInt()),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
        ],
      ),
    );
  }

  Widget _clearButton(PropertyProvider provider) {
    return Semantics(
      button: true,
      label: 'Clear filters',
      child: Tooltip(
        message: 'Clear filters',
        child: TextButton.icon(
          onPressed: provider.clearFilters,
          icon: Icon(Icons.clear, color: AppColor.white, size: 16.sp),
          label: Text(
            'Clear',
            style: AppTypography.text12.withCustomColor(AppColor.white),
          ),
          style: ButtonStyle(
            minimumSize: WidgetStatePropertyAll(Size(48.w, 20.h)),
            padding: WidgetStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            ),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
            ),
            side: WidgetStatePropertyAll(
              BorderSide(
                color: AppColor.white.withValues(alpha: 0.9),
                width: 1,
              ),
            ),
            foregroundColor: WidgetStatePropertyAll(AppColor.white),
            overlayColor: WidgetStatePropertyAll(
              AppColor.white.withValues(alpha: 0.12),
            ),
            backgroundColor: WidgetStatePropertyAll(
              AppColor.brandBlue.withValues(alpha: 0.3),
            ),
          ),
        ),
      ),
    );
  }

  String _typeLabel(PropertyType t) {
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

  String _format(int v) {
    if (v >= 1000000) {
      return '₦${(v / 1000000).toStringAsFixed(1)}M';
    }
    if (v >= 1000) {
      return '₦${(v / 1000).toStringAsFixed(0)}k';
    }
    return '₦$v';
  }
}
