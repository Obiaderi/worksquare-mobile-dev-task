import 'package:worksquare_housing/core/core.dart';
import 'package:worksquare_housing/features/property/property_model.dart';
import 'package:worksquare_housing/ui/bottom_nav_screen.dart';
import 'package:worksquare_housing/ui/listings/listing_details_screen.dart';
import 'package:worksquare_housing/ui/screen_not_found.dart';
import 'package:worksquare_housing/ui/screens/splash_screen.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePath.splashScreen:
        return TransitionUtils.buildTransition(const SplashScreen(), settings);

      case RoutePath.listingDetailsScreen:
        final arg = settings.arguments;
        if (arg is PropertyModel) {
          return TransitionUtils.buildTransition(
            ListingDetailsScreen(property: arg),
            settings,
          );
        }
        return errorScreen(settings);

      case RoutePath.bottomNavScreen:
        return TransitionUtils.buildTransition(
          const BottomNavScreen(),
          settings,
        );

      default:
        return errorScreen(settings);
    }
  }

  static errorScreen(RouteSettings settings) {
    return TransitionUtils.buildTransition(
      ScreenNotFound(routeName: settings.name),
      settings,
    );
  }
}
