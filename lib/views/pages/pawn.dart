/// Represents a player's pawn on the board.
/// 
/// Stores position and visual properties for rendering.
class Pawn {
  /// Whether this pawn belongs to the white (bottom) player.
  final bool isWhite;
  
  /// Asset path to the pawn image.
  final String imagePath;
  
  /// Current row position (0-16, even numbers only).
  int currRow;
  
  /// Current column position (0-16, even numbers only).
  int currCol;

  /// Creates a new pawn with the given properties.
  Pawn({
    required this.isWhite,
    required this.imagePath,
    required this.currRow,
    required this.currCol
  });
}
