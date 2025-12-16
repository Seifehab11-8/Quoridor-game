import 'package:flutter/material.dart';
import 'package:quoridor_game/views/pages/pawn.dart';

class Square extends StatelessWidget {
  final Pawn? piece;
  final bool isSelected;
  final bool isValidMove;
  final void Function() onTapFunc;
  const Square({
    super.key, 
    required this.piece,
    required this.isSelected,
    required this.isValidMove,
    required this.onTapFunc,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapFunc,
      child: Center(
        child: Container(
          padding: EdgeInsets.all(4.0),
          margin: EdgeInsets.all(4.0),
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
