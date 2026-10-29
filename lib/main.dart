import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Vercel hostname only, such as deep-link-test.vercel.app. No https://.
const String deepLinkHost = 'example.com';

void main() {
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => DeepLinkPage(uri: state.uri),
      routes: [
        GoRoute(
          path: ':location(.*)',
          builder: (context, state) => DeepLinkPage(uri: state.uri),
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Deep Link Test',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      routerConfig: _router,
    );
  }
}

class DeepLinkPage extends StatelessWidget {
  const DeepLinkPage({required this.uri, super.key});

  final Uri uri;

  bool get _openedFromLink =>
      uri.path != '/' || uri.query.isNotEmpty || uri.fragment.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lines = uri.queryParameters.entries.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Deep Link Test')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            _openedFromLink ? 'Opened from a link' : 'Opened from the icon',
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          SelectableText(uri.toString(), style: theme.textTheme.titleMedium),
          if (lines.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text('Query', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            for (final entry in lines) Text('${entry.key}: ${entry.value}'),
          ],
          const SizedBox(height: 32),
          Text(
            'Any https://$deepLinkHost/... address opens this app after the .well-known files are deployed.',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
