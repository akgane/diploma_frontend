import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_tracker/core/router/app_router.dart';
import 'package:food_tracker/modules/settings/providers/settings_provider.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

// Роутер создаётся один раз на уровне приложения
final _router = AppRouter.createRouter();

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return MaterialApp.router(
      title: 'Food Tracker',
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      locale: Locale(settings.language),
      supportedLocales: const [
        Locale('en'),
        Locale('ru'),
      ],
    );
  }
}