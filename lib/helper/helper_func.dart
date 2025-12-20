import 'dart:collection';

List<int> calculateRowCol(int index, {int boardSize = 17}) {
  List<int> rowCol = [];
  rowCol.add(index ~/ boardSize);
  rowCol.add(index % boardSize);
  return rowCol;
}


int bfs(Map<int, List<int>> validMoves, int startVertex, int targetRow) {
  // Standard layered BFS to return the shortest path length (in steps) to any
  // cell whose row equals targetRow. Returns -1 if unreachable.
  Queue<int> queue = Queue<int>();
  Set<int> visited = {};
  queue.add(startVertex);
  visited.add(startVertex);
  int distance = 0;

  while (queue.isNotEmpty) {
    final levelSize = queue.length;
    for (int i = 0; i < levelSize; i++) {
      final current = queue.removeFirst();
      final rowCol = calculateRowCol(current);
      if (rowCol[0] == targetRow) {
        return distance;
      }

      for (final next in validMoves[current] ?? const <int>[]) {
        if (!visited.contains(next)) {
          visited.add(next);
          queue.add(next);
        }
      }
    }
    distance++;
  }
  return -1;
}

  
Map<int, List<int>> deepCopyValidMoves(Map<int, List<int>> src) {
  return src.map((k, v) => MapEntry(k, List<int>.from(v)));
}

Map<int, String> copyWallPos(Map<int, String> src) => Map<int, String>.from(src);