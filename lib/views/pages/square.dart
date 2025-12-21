import 'package:flutter/material.dart';
import 'package:quoridor_game/views/pages/pawn.dart';

/// Renders a playable square on the board and highlights selection/valid moves.
/// 
/// Displays a pawn image if occupied, and changes color to indicate
/// selection or valid move destinations.
class Square extends StatelessWidget {
  /// The pawn occupying this square (null if empty).
  final Pawn? piece;
  
  /// Callback invoked when the square is tapped.
  final void Function() onTapFunc;
  
  /// Whether this square is a valid move destination for the selected pawn.
  final bool isValidMove;
  
  /// Whether this square is currently selected by the player.
  final bool isSelected;
  
  /// Creates a square widget with the given properties.
  const Square({
    super.key, 
    required this.piece,
    required this.isValidMove,
    required this.isSelected,
    required this.onTapFunc,
  });


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapFunc,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(2.0)),
            color: (isSelected || isValidMove)?Colors.orange[600]: const Color.fromARGB(255, 195, 138, 118),
          ),
          child: piece != null
              ? Image.asset(
                  piece!.imagePath,
                  color: piece!.isWhite ? Colors.white : Colors.black,
                  fit: BoxFit.fill,
                )
              : null,
        ),
      ),
    );
  }
}
