import 'package:flutter/material.dart';
import 'screens/presentation_screen.dart';

void main() => runApp(const SlidesApp());

class SlidesApp extends StatelessWidget {
  const SlidesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Condicionador de Sinais',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF007AFF),
          secondary: Color(0xFF00C7FF),
          surface: Color(0xFF1C1C1E),
          onSurface: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const PresentationScreen(),
    );
  }
}
