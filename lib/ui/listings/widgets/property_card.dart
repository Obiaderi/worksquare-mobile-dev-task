import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:worksquare_housing/core/core.dart';
import 'package:worksquare_housing/features/property/property_model.dart';
import 'package:worksquare_housing/features/property/property_provider.dart';

class PropertyCard extends StatelessWidget {
  final PropertyModel property;
  final bool compact;
  const PropertyCard({super.key, required this.property, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(symbol: '₦', decimalDigits: 0);
    return InkWell(
      onTap: () => Navigator.pushNamed(
        context,
        RoutePath.listingDetailsScreen,
        arguments: property,
      ),
      child: Card(
        elevation: 2,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: compact ? 90.h : 110.h,
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CachedNetworkImage(
                      imageUrl: property.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (ctx, url) =>
                          Container(color: AppColor.lightGrey),
                      errorWidget: (ctx, url, err) =>
                          Container(color: AppColor.red),
                    ),
                  ),
                  Positioned(
                    right: 8.w,
                    top: 8.h,
                    child: Consumer<PropertyProvider>(
                      builder: (context, provider, _) {
                        final fav = provider.isFavorite(property.id);
                        return Semantics(
                          button: true,
                          label: fav ? 'Unfavorite' : 'Favorite',
                          child: InkWell(
                            onTap: () => provider.toggleFavorite(property),
                            borderRadius: BorderRadius.circular(18.r),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              transitionBuilder: (child, anim) =>
                                  ScaleTransition(scale: anim, child: child),
                              child: Container(
                                key: ValueKey(fav),
                                padding: EdgeInsets.all(4.w),
                                decoration: BoxDecoration(
                                  color: AppColor.white.withValues(alpha: 0.85),
                                  borderRadius: BorderRadius.circular(18.r),
                                  border: Border.all(
                                    color: fav
                                        ? AppColor.brandOrange
                                        : AppColor.grey,
                                  ),
                                ),
                                child: Icon(
                                  fav ? Icons.favorite : Icons.favorite_border,
                                  size: 16.sp,
                                  color: fav
                                      ? AppColor.brandOrange
                                      : AppColor.grey,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (compact)
              Padding(
                padding: EdgeInsets.all(10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      property.title,
                      style: AppTypography.text14.bold,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${property.city}, ${property.neighborhood}',
                      style: AppTypography.text14.withCustomColor(
                        AppColor.grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      currency.format(property.price),
                      style: AppTypography.text16.bold.withCustomColor(
                        AppColor.brandOrange,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Wrap(
                      spacing: 12.w,
                      runSpacing: 4.h,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Icon(Icons.bed, size: 16.sp, color: AppColor.grey),
                        Text(
                          '${property.bedrooms} bd',
                          style: AppTypography.text12,
                        ),
                        Icon(Icons.bathtub, size: 16.sp, color: AppColor.grey),
                        Text(
                          '${property.bathrooms} ba',
                          style: AppTypography.text12,
                        ),
                        Icon(
                          Icons.aspect_ratio,
                          size: 16.sp,
                          color: AppColor.grey,
                        ),
                        Text(
                          '${property.sqft} sqft',
                          style: AppTypography.text12,
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      _label(property.type),
                      style: AppTypography.text10.withCustomColor(
                        AppColor.blue,
                      ),
                    ),
                  ],
                ),
              )
            else
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(10.w),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          property.title,
                          style: AppTypography.text14.bold,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '${property.city}, ${property.neighborhood}',
                          style: AppTypography.text14.withCustomColor(
                            AppColor.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          currency.format(property.price),
                          style: AppTypography.text16.bold.withCustomColor(
                            AppColor.brandOrange,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Wrap(
                          spacing: 12.w,
                          runSpacing: 4.h,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Icon(Icons.bed, size: 16.sp, color: AppColor.grey),
                            Text(
                              '${property.bedrooms} bd',
                              style: AppTypography.text12,
                            ),
                            Icon(
                              Icons.bathtub,
                              size: 16.sp,
                              color: AppColor.grey,
                            ),
                            Text(
                              '${property.bathrooms} ba',
                              style: AppTypography.text12,
                            ),
                            Icon(
                              Icons.aspect_ratio,
                              size: 16.sp,
                              color: AppColor.grey,
                            ),
                            Text(
                              '${property.sqft} sqft',
                              style: AppTypography.text12,
                            ),
                          ],
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          _label(property.type),
                          style: AppTypography.text10.withCustomColor(
                            AppColor.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _label(PropertyType type) {
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
}
