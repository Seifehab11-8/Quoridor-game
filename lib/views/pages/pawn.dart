class Pawn {
  final bool isWhite;
  final String imagePath;
  int ?currRow;
  int ?currCol;

  Pawn({
    required this.isWhite,
    required this.imagePath,
    required this.currRow,
    required this.currCol
  });
}
