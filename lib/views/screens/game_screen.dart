import 'package:flutter/material.dart';
import 'package:quoridor_game/views/pages/board.dart';

class GameScreen extends StatefulWidget {
  final bool isOppHuman;
  const GameScreen({super.key, required this.isOppHuman});

  @override
  // ignore: no_logic_in_create_state
  State<GameScreen> createState() => _GameScreenState(isOppHuman);
}

class _GameScreenState extends State<GameScreen> {
  final bool isOppHuman;

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
