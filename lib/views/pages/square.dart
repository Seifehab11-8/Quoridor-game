import 'package:flutter/material.dart';
import 'package:quoridor_game/views/pages/pawn.dart';

class Square extends StatefulWidget {
  final Pawn? piece;
  final bool Function() onTapFunc;
  final bool isValidMove;
  const Square({
    super.key, 
    required this.piece,
    required this.isValidMove,
    required this.onTapFunc,
  });

  @override
  // ignore: no_logic_in_create_state
  State<Square> createState() => _SquareState(isValidMove);
}

class _SquareState extends State<Square> {
  bool ?isSelected = false;
  bool isValidMove;

  _SquareState(this.isValidMove);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = widget.onTapFunc();
        });
      },
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(2.0)),
            color: (isSelected! || isValidMove)?Colors.orange[600]: const Color.fromARGB(255, 195, 138, 118),
          ),
          child: widget.piece != null
              ? Image.asset(
                  widget.piece!.imagePath,
                  color: widget.piece!.isWhite ? Colors.white : Colors.black,
                  fit: BoxFit.fill,
                )
              : null,
        ),
      ),
    );
  }
}
