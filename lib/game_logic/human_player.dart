import 'package:quoridor_game/game_logic/player.dart';
import 'package:quoridor_game/helper/game_state.dart';
import 'package:quoridor_game/helper/move_data.dart';

/// Player implementation that handles human touch/click input.
/// 
/// Manages two-tap wall placement and validates pawn movement based on
/// tapped coordinates and current selection state.
class HumanPlayer extends Player {
  /// Previously selected wall segment index (for two-tap wall placement).
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

  /// Processes a tap at the given board coordinates.
  /// 
  /// Squares (even row and col) trigger pawn selection/movement via [checkIfSelected].
  /// Walls (mixed parity) trigger wall placement via [checkIfWallIsSelected].
  @override
  MoveData play(int row, int col, int oppCurrRow, int oppCurrCol) {
    // Squares live on even rows/cols; walls on mixed parity.
    if (row % 2 == 0 && col % 2 == 0) {
      return checkIfSelected(row, col, oppCurrRow, oppCurrCol);
    } else {
      return checkIfWallIsSelected(row, col, oppCurrRow, oppCurrCol);
    }
  }

  /// Handles taps on playable squares (pawn selection and movement).
  /// 
  /// First tap on own pawn selects it and adds special moves if facing opponent.
  /// Second tap on a valid destination moves the pawn there.
  /// 
  /// Returns:
  ///   - [MoveData.INTERMEDIATE_MOVE] if pawn selected
  ///   - [MoveData.SUCCESSFUL_MOVE] if pawn moved
  ///   - [MoveData.INVALID_MOVE] if tap is not allowed
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
      // Move pawn if tap hits a reachable square that is not occupied by opponent.
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

  /// Handles taps on wall segments (two-tap wall placement).
  /// 
  /// First tap selects a wall segment, second tap places the wall if valid.
  /// Cleans up any special moves before processing wall placement.
  /// 
  /// Valid walls must:
  /// - Connect two segments that are 2 apart (horizontal) or 34 apart (vertical)
  /// - Not block either player's path to victory
  /// 
  /// Returns the result of the wall placement attempt.
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
        // Build a sandboxed state to validate the wall placement.
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
