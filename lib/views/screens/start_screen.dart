import 'package:flutter/material.dart';
import 'package:quoridor_game/views/screens/game_screen.dart';

const String human = 'Human vs Human';
const String computer = 'Human vs Computer';

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
                child: PopupMenuButton<String>(
                  elevation: 8,
                  offset: const Offset(0, 14),
                  position: PopupMenuPosition.under,
                  color: const Color(0xFFF8E7BB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  constraints: const BoxConstraints(minWidth: 220),
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem<String>(
                      value: human,
                      child: const Text(
                        human,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF5D4037),
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: computer,
                      child: const Text(
                        computer,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF5D4037),
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                  ],
                  onSelected: (String value) {
                    final bool isOppHuman = (value == human);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GameScreen(isOppHuman: isOppHuman),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8D6E63),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 12,
                          offset: Offset(0, 6),
                        ),
                      ],
                      border: Border.all(
                        color: const Color(0xFF5D4037),
                        width: 1.4,
                      ),
                    ),
                    child: const Text(
                      'Start New Game',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFF5E1C8),
                        letterSpacing: 1.2,
                      ),
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
