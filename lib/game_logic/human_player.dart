import 'package:quoridor_game/game_logic/player.dart';
import 'package:quoridor_game/helper/move_data.dart';

class HumanPlayer extends Player {
  int? prevSelectedWall;
  HumanPlayer({
    required super.pawn,
    required super.validMoves,
    required super.wallPos,
    required super.wallColor,
    required super.myInitRow,
    required super.oppInitRow,
  }){
    prevSelectedWall = -1;
  }

  @override
  MoveData play(int row, int col, int oppCurrRow, int oppCurrCol) {
    if (row % 2 == 0 && col % 2 == 0) {
      return checkIfSelected(row, col);
    } else {
      return checkIfWallIsSelected(row, col, oppCurrRow, oppCurrCol);
    }
  }

  MoveData checkIfSelected(int row, int col) {
    int index = row * boardRow + col;
    if (row == pawn.currRow && col == pawn.currCol) {
      selectedRow = row;
      selectedCol = col;
      return MoveData.INTERMEDIATE_MOVE;
    }

    if (selectedRow != -1 &&
        selectedCol != -1 &&
        (validMoves[selectedRow * boardRow + selectedCol] == null
            ? false
            : validMoves[selectedRow * boardRow + selectedCol]!.contains(
                    index,
                  ) &&
                  pawn.currRow == selectedRow &&
                  pawn.currCol == selectedCol)) {
      pawn.currRow = row;
      pawn.currCol = col;
      selectedRow = -1;
      selectedCol = -1;
      return MoveData.SUCCESSFUL_MOVE;
    }

    return MoveData.INVALID_MOVE;
  }

  MoveData checkIfWallIsSelected(int row, int col, int oppCurrRow, int oppCurrCol) {
    int currentWallIndex = row * boardRow + col;
    MoveData isCorrectMove = MoveData.SUCCESSFUL_MOVE;
    //check if it is not a connection between a wall (1,1)
    if ((row % 2 != col % 2)) {
      if (prevSelectedWall == -1) {
        prevSelectedWall = row * boardRow + col;
        // First tap just selects a wall segment; not an invalid move yet.
        return MoveData.INTERMEDIATE_MOVE;
      } else {
        //consectuive in col
        if ((prevSelectedWall! - currentWallIndex).abs() == 2) {
          isCorrectMove = addWallsToList(
            prevSelectedWall!,
            currentWallIndex,
            oppCurrRow,
            oppCurrCol,
            true,
          );
        } else if ((prevSelectedWall! - currentWallIndex).abs() == 34) {
          isCorrectMove = addWallsToList(
            prevSelectedWall!,
            currentWallIndex,
            oppCurrRow,
            oppCurrCol,
            false,
          );
        }
        else {
          isCorrectMove = MoveData.INVALID_MOVE;
        }

        prevSelectedWall = -1;
      }
    }
    return isCorrectMove;
  }
}
