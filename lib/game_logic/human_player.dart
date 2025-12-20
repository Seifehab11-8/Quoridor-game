import 'package:quoridor_game/game_logic/player.dart';
import 'package:quoridor_game/helper/game_state.dart';
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
  }) {
    prevSelectedWall = -1;
  }

  @override
  MoveData play(int row, int col, int oppCurrRow, int oppCurrCol) {
    if (row % 2 == 0 && col % 2 == 0) {
      return checkIfSelected(row, col, oppCurrRow, oppCurrCol);
    } else {
      return checkIfWallIsSelected(row, col, oppCurrRow, oppCurrCol);
    }
  }

  MoveData checkIfSelected(int row, int col, int oppCurrRow, oppCurrCol) {
    int index = row * boardRow + col;
    if (row == pawn.currRow && col == pawn.currCol) {
      selectedRow = row;
      selectedCol = col;
      addSpecialCase(
        GameState(
          validMoves: validMoves,
          wallPos: wallPos,
          myRow: pawn.currRow,
          myCol: pawn.currCol,
          oppRow: oppCurrRow,
          oppCol: oppCurrCol, alpha: double.negativeInfinity, beta: double.infinity,
        ),
        myInitRow > oppCurrRow,
      );
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
                  pawn.currCol == selectedCol) && !(row == oppCurrRow && col == oppCurrCol)) {
      if(isSpecialAdded) {
        removeSpecialCases(
          GameState(
            validMoves: validMoves,
            wallPos: wallPos,
            myRow: pawn.currRow,
            myCol: pawn.currCol,
            oppRow: oppCurrRow,
            oppCol: oppCurrCol, alpha: double.negativeInfinity, beta: double.infinity,
            
          ),
          selectedRow,
          selectedCol,
          myInitRow > oppInitRow,
        );
        isSpecialAdded = false;
        if (kDebugMode) {
          // ignore: avoid_print
          print('attempted to delete the special case');
        }
      }
      pawn.currRow = row;
      pawn.currCol = col;
      selectedRow = -1;
      selectedCol = -1;
      return MoveData.SUCCESSFUL_MOVE;
    }
    return MoveData.INVALID_MOVE;
  }

  MoveData checkIfWallIsSelected(
    int row,
    int col,
    int oppCurrRow,
    int oppCurrCol,
  ) {
    int currentWallIndex = row * boardRow + col;
    MoveData isCorrectMove = MoveData.INVALID_MOVE;
    //check if it is not a connection between a wall (1,1)

    if(isSpecialAdded) {  
      removeSpecialCases(
          GameState(
            validMoves: validMoves,
            wallPos: wallPos,
            myRow: pawn.currRow,
            myCol: pawn.currCol,
            oppRow: oppCurrRow,
            oppCol: oppCurrCol, alpha: double.negativeInfinity, beta: double.infinity,
          ),
          selectedRow,
          selectedCol,
          myInitRow > oppInitRow,
        );
        isSpecialAdded = false;
        if (kDebugMode) {
          // ignore: avoid_print
          print('attempted to delete the special case');
        }
    }
    if ((row % 2 != col % 2)) {
      if (prevSelectedWall == -1) {
        prevSelectedWall = row * boardRow + col;
        // First tap just selects a wall segment; not an invalid move yet.
        return MoveData.INTERMEDIATE_MOVE;
      } else {
        // Create GameState once and reuse it
        GameState gameState = GameState(
          validMoves: validMoves,
          wallPos: wallPos,
          myRow: pawn.currRow,
          myCol: pawn.currCol,
          oppRow: oppCurrRow,
          oppCol: oppCurrCol,
          numOfWalls: numOfWalls, alpha: double.negativeInfinity, beta: double.infinity,
        );

        //consectuive in col
        if ((prevSelectedWall! - currentWallIndex).abs() == 2) {
          isCorrectMove = addWallsToList(
            gameState,
            prevSelectedWall!,
            currentWallIndex,
            true,
          );
        } else if ((prevSelectedWall! - currentWallIndex).abs() == 34) {
          isCorrectMove = addWallsToList(
            gameState,
            prevSelectedWall!,
            currentWallIndex,
            false,
          );
        } else {
          isCorrectMove = MoveData.INVALID_MOVE;
        }

        // Update player's state if wall placement was successful
        if (isCorrectMove == MoveData.SUCCESSFUL_MOVE) {
          numOfWalls = gameState.numOfWalls;
        }
        prevSelectedWall = -1;
      }
      selectedRow = -1;
      selectedCol = -1;
    }

    return isCorrectMove;
  }
}
