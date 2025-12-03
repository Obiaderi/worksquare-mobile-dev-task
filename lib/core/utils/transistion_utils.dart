import 'package:worksquare_housing/core/core.dart';

class TransitionUtils {
  static Route<T> buildTransition<T>(
    Widget child,
    RouteSettings settings, {
    TransitionType transition = TransitionType.fade,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
    RouteTransitionsBuilder? customTransition,
  }) {
    switch (transition) {
      case TransitionType.native:
        return MaterialPageRoute<T>(builder: (_) => child, settings: settings);
      case TransitionType.fade:
        return PageRouteBuilder<T>(
          settings: settings,
          pageBuilder: (_, __, ___) => child,
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
          transitionDuration: duration,
        );
      case TransitionType.slideRight:
        return _slideTransition(
          child,
          const Offset(-1, 0),
          settings,
          duration,
          curve,
        );
      case TransitionType.slideLeft:
        return _slideTransition(
          child,
          const Offset(1, 0),
          settings,
          duration,
          curve,
        );
      case TransitionType.slideTop:
        return _slideTransition(
          child,
          const Offset(0, 1),
          settings,
          duration,
          curve,
        );
      case TransitionType.slideBottom:
        return _slideTransition(
          child,
          const Offset(0, -1),
          settings,
          duration,
          curve,
        );
      case TransitionType.scale:
        return PageRouteBuilder<T>(
          settings: settings,
          pageBuilder: (_, __, ___) => child,
          transitionsBuilder: (_, animation, __, child) => ScaleTransition(
            scale: CurvedAnimation(parent: animation, curve: curve),
            child: child,
          ),
          transitionDuration: duration,
        );
      case TransitionType.rotate:
        return PageRouteBuilder<T>(
          settings: settings,
          pageBuilder: (_, __, ___) => child,
          transitionsBuilder: (_, animation, __, child) => RotationTransition(
            turns: CurvedAnimation(parent: animation, curve: curve),
            child: ScaleTransition(
              scale: CurvedAnimation(parent: animation, curve: curve),
              child: child,
            ),
          ),
          transitionDuration: duration,
        );
      case TransitionType.size:
        return PageRouteBuilder<T>(
          settings: settings,
          pageBuilder: (_, __, ___) => child,
          transitionsBuilder: (_, animation, __, child) => Align(
            child: SizeTransition(sizeFactor: animation, child: child),
          ),
          transitionDuration: duration,
        );
      case TransitionType.custom:
        if (customTransition != null) {
          return PageRouteBuilder<T>(
            settings: settings,
            pageBuilder: (_, __, ___) => child,
            transitionsBuilder: customTransition,
            transitionDuration: duration,
          );
        }
        // Fallback to fade if no custom transition provided
        return buildTransition(
          child,
          settings,
          duration: duration,
          transition: TransitionType.fade,
        );
    }
  }

  static PageRouteBuilder<T> _slideTransition<T>(
    Widget child,
    Offset beginOffset,
    RouteSettings settings,
    Duration duration,
    Curve curve,
  ) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (_, __, ___) => child,
      transitionsBuilder: (_, animation, __, child) => SlideTransition(
        position: Tween<Offset>(
          begin: beginOffset,
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: curve)),
        child: child,
      ),
      transitionDuration: duration,
    );
  }
}
