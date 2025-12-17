import 'package:flutter/material.dart';
import 'package:quoridor_game/views/pages/board.dart';

class Wall extends StatelessWidget {
  final bool isWallSelected;
  final String? wallColortxt;
  final void Function() onTapFunc;
  const Wall({
    super.key, 
    required this.isWallSelected,
    required this.wallColortxt,
    required this.onTapFunc
  });

  @override
  Widget build(BuildContext context) {
    Color? wallColor = Colors.orange[100];

    if(isWallSelected) {
      wallColor = wallColortxt == myWallColor ? Colors.red : Colors.blue;
    }
    return GestureDetector(
      onTap: onTapFunc,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(2.0)),
            color: wallColor,
          ),
        ),
      ),
    );
  }
}
