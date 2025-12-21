import 'package:flutter/material.dart';
import 'package:quoridor_game/views/screens/start_screen.dart';

/// Entry point for the Quoridor game application.
/// 
/// Initializes the Flutter framework and launches the app.
void main() {
  runApp(const MyApp());
}

/// Root widget of the Quoridor application.
/// 
/// Sets up the app theme and navigation starting with [StartScreen].
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
          brightness: Brightness.light,
        ),
      ),
      home: StartScreen(),
    );
  }
}
