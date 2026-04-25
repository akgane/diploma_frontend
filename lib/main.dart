import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_tracker/core/fcm/fcm_provider.dart';
import 'package:food_tracker/core/router/app_router.dart';
import 'package:food_tracker/modules/settings/providers/settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

// Single router for whole application
final _router = AppRouter.createRouter();

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    ref.read(fcmServiceProvider).listenTokenRefresh();

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