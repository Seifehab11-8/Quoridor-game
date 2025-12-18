import 'dart:collection';

List<int> calculateRowCol(int index, {int boardSize = 17}) {
  List<int> rowCol = [];
  rowCol.add(index ~/ boardSize);
  rowCol.add(index % boardSize);
  return rowCol;
}


bool bfs(Map<int, List<int>>validMoves, int startVertex, int targetRow) {
    Queue<int> tempQueue = Queue<int>();
    Set<int> visitedNodes = {};
    tempQueue.add(startVertex);
    int row;

    while (tempQueue.isNotEmpty) {
      int currentVertex = tempQueue.first;
      tempQueue.removeFirst();
      visitedNodes.add(currentVertex);
      final rowCol = calculateRowCol(currentVertex);
      row = rowCol[0];
      if (row == targetRow) {
        return true;
      }

      for (int ver in validMoves[currentVertex]!) {
        if (!visitedNodes.contains(ver)) {
          tempQueue.add(ver);
        }
      }
    }
    return false;
  }