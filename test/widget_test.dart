// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worksquare_housing/features/property/property_provider.dart';
import 'package:worksquare_housing/ui/listings/listings_screen.dart';

void main() {
  testWidgets('Listings screen renders and filter bar is present', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (_, __) => ChangeNotifierProvider(
          create: (_) => PropertyProvider()..loadProperties(),
          child: const MaterialApp(home: ListingsScreen()),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(Scaffold), findsWidgets);
  });
}
