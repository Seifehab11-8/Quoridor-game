List<int> calculateRowCol(int index, int boardSize) {
  List<int> rowCol = [];
  rowCol.add(index ~/ boardSize);
  rowCol.add(index % boardSize);
  return rowCol;
}


