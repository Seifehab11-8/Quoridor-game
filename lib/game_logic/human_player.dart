import 'package:quoridor_game/game_logic/player.dart';

class HumanPlayer extends Player {
  HumanPlayer({
    required super.pawn,
    required super.validMoves,
    required super.wallPos,
    required super.wallColor,
    required super.myInitRow,
    required super.oppInitRow,
  });

  @override
  bool play(int row, int col, int oppCurrRow, int oppCurrCol) {
    if (row % 2 == 0 && col % 2 == 0) {
      checkIfSelected(row, col);
      return ((selectedRow == row) && (selectedCol == col));
    } else {
      return checkIfWallIsSelected(row, col, oppCurrRow, oppCurrCol);
    }
  }

  void checkIfSelected(int row, int col) {
    int index = row * boardRow + col;
    if (row == pawn.currRow && col == pawn.currCol) {
      selectedRow = row;
      selectedCol = col;
    }

    if (selectedRow != -1 &&
        selectedCol != -1 &&
        (validMoves[selectedRow! * boardRow + selectedCol!] == null
            ? false
            : validMoves[selectedRow! * boardRow + selectedCol!]!.contains(
                    index,
                  ) &&
                  pawn.currRow == selectedRow &&
                  pawn.currCol == selectedCol)) {
      pawn.currRow = row;
      pawn.currCol = col;
      selectedRow = -1;
      selectedCol = -1;
    }
  }

  bool checkIfWallIsSelected(int row, int col, int oppCurrRow, int oppCurrCol) {
    int currentWallIndex = row * boardRow + col;
    //check if it is not a connection between a wall (1,1)
    if ((row % 2 != col % 2)) {
      if (prevSelectedWall == -1) {
        prevSelectedWall = row * boardRow + col;
      } else {
        //consectuive in col
        if ((prevSelectedWall! - currentWallIndex).abs() == 2) {
          return addWallsToList(
            prevSelectedWall!,
            currentWallIndex,
            oppCurrRow,
            oppCurrCol,
            true,
          );
        } else if ((prevSelectedWall! - currentWallIndex).abs() == 34) {
          return addWallsToList(
            prevSelectedWall!,
            currentWallIndex,
            oppCurrRow,
            oppCurrCol,
            false,
          );
        }

        prevSelectedWall = -1;
      }
    }
    return false;
  }
}
