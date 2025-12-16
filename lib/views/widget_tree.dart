import 'package:flutter/material.dart';
import 'package:quoridor_game/views/pages/board.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
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
      body: Board(),
    );
  }
}
