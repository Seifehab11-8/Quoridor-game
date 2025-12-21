import 'package:flutter/material.dart';
import 'package:quoridor_game/views/pages/board.dart';

/// Main game screen that hosts the board for either human vs human or vs computer.
/// 
/// Wraps the [Board] widget in a Scaffold with an app bar showing the game title.
class GameScreen extends StatefulWidget {
  /// Whether the opponent is human (true) or AI (false).
  final bool isOppHuman;
  const GameScreen({super.key, required this.isOppHuman});

  @override
  // ignore: no_logic_in_create_state
  State<GameScreen> createState() => _GameScreenState(isOppHuman);
}

/// State for the GameScreen widget.
class _GameScreenState extends State<GameScreen> {
  /// Whether the opponent is controlled by a human.
  final bool isOppHuman;

  /// Creates the state with the opponent type.
  _GameScreenState(this.isOppHuman);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'QUORIDOR',
          style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w500, // The logo is relatively thin
              letterSpacing: 3.0, // The logo has wide spacing
              color: Colors.black, // or your dark brown color
            ),
        ),
      ),
      body: Board(isOppHuman: isOppHuman,),
    );
  }
}
