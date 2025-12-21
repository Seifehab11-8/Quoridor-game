import 'package:flutter/material.dart';
import 'package:quoridor_game/views/pages/board.dart';

/// Renders a wall segment cell and shows ownership color.
/// 
/// Wall segments are displayed in red (human) or blue (opponent)
/// when placed, otherwise in the default background color.
class Wall extends StatelessWidget {
  /// Whether a wall has been placed at this position.
  final bool isWallSelected;
  
  /// Color identifier ('r' for red, 'b' for blue) if wall is placed.
  final String? wallColortxt;
  
  /// Callback invoked when this wall segment is tapped.
  final void Function() onTapFunc;
  
  /// Creates a wall widget with the given properties.
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
