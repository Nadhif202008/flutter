import 'package:flutter/material.dart';
import 'providers/app_state.dart';
import 'theme/app_theme.dart';
import 'pages/splash_screen_page.dart';

void main() {
  runApp(const FoodDeliveryApp());
}

class FoodDeliveryApp extends StatefulWidget {
  const FoodDeliveryApp({super.key});

  @override
  State<FoodDeliveryApp> createState() => _FoodDeliveryAppState();
}

class _FoodDeliveryAppState extends State<FoodDeliveryApp> {
  final AppState _appState = AppState();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _appState,
      builder: (context, _) {
        return MaterialApp(
          title: 'GrabFood Clone',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: SplashScreenPage(appState: _appState),
        );
      },
    );
  }
}
