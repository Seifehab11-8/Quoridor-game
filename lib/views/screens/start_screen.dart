import 'package:flutter/material.dart';
import 'package:quoridor_game/views/screens/game_screen.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/wood_background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'QUORIDOR',
                style: TextStyle(
                  fontSize: 100,
                  fontWeight: FontWeight.w700, // The logo is relatively thin
                  letterSpacing: 4.0, // The logo has wide spacing
                  color: Colors.black, // or your dark brown color
                ),
              ),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5C3B1E),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    elevation: 12,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                      side: const BorderSide(
                        color: Color(0xFFD7B377),
                        width: 2,
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GameScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Start New Game',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF5E1C8),
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
