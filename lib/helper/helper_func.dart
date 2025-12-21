import 'dart:collection';

/// Converts a flattened board index into (row, col) coordinates.
/// 
/// The board is stored as a 1D list but conceptually represents a 2D grid.
/// This function translates between the two representations.
/// 
/// Parameters:
///   - [index]: The 1D array index (0 to boardSize² - 1)
///   - [boardSize]: Width/height of the square board (default: 17)
/// 
/// Returns a list `[row, col]` where both are 0-based.
List<int> calculateRowCol(int index, {int boardSize = 17}) {
  List<int> rowCol = [];
  rowCol.add(index ~/ boardSize);
  rowCol.add(index % boardSize);
  return rowCol;
}

/// Finds the shortest path from a starting position to any cell in the target row.
/// 
/// Uses breadth-first search (BFS) to explore the graph of valid moves.
/// This is used to validate that wall placements don't completely block a player.
/// 
/// Parameters:
///   - [validMoves]: Adjacency list mapping each cell index to its reachable neighbors
///   - [startVertex]: The 1D index of the starting cell
///   - [targetRow]: The row number the player is trying to reach
/// 
/// Returns the minimum number of moves required, or -1 if unreachable.
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

/// Creates a deep copy of the validMoves adjacency list.
/// 
/// Each inner list is cloned so modifications don't affect the original.
/// Used when simulating moves during AI search.
Map<int, List<int>> deepCopyValidMoves(Map<int, List<int>> src) {
  return src.map((k, v) => MapEntry(k, List<int>.from(v)));
}

/// Creates a shallow copy of the wall positions map.
/// 
/// Walls are immutable strings, so a shallow copy is sufficient.
Map<int, String> copyWallPos(Map<int, String> src) => Map<int, String>.from(src);