import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:worksquare_housing/core/core.dart';
import 'package:worksquare_housing/features/property/property_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (_, __) => MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => PropertyProvider())],
        child: MaterialApp(
          title: 'Worksquare Housing',
          debugShowCheckedModeBanner: false,
          navigatorKey: NavKey.appNavKey,
          initialRoute: RoutePath.splashScreen,
          onGenerateRoute: AppRouter.onGenerateRoute,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: AppColor.brandBlue),
            scaffoldBackgroundColor: AppColor.white,
            appBarTheme: const AppBarTheme(backgroundColor: AppColor.brandBlue),
          ),
        ),
      ),
    );
  }
}
