import 'package:worksquare_housing/core/core.dart';

class ScreenNotFound extends StatelessWidget {
  final String? routeName;

  const ScreenNotFound({this.routeName, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('404 - Page Not Found', style: AppTypography.text24),
            const SizedBox(height: 8),
            const Text(
              'The requested page could not be found',
              style: TextStyle(fontSize: 16),
            ),
            if (routeName != null) ...[
              const SizedBox(height: 8),
              Text(
                'Attempted route: $routeName',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacementNamed(
                context,
                RoutePath.bottomNavScreen,
              ),
              child: const Text('Return to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
