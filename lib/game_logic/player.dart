import 'dart:math';

import 'package:quoridor_game/helper/game_state.dart';
import 'package:quoridor_game/helper/helper_func.dart';
import 'package:quoridor_game/helper/move_data.dart';
import 'package:quoridor_game/views/pages/pawn.dart';

const int boardRow = 17;
const int boardCol = 17;
const bool kDebugMode = true;

/// Base player class that holds shared pawn state, wall inventory, and move helpers.
/// 
/// Provides core logic for wall placement validation and special jump/diagonal moves.
/// Subclasses implement [play] to handle user input or AI decisions.
abstract class Player {
  /// The pawn controlled by this player.
  Pawn pawn;
  
  /// Color identifier for this player's walls ('r' or 'b').
  String wallColor;
  
  /// Row of the currently selected square (-1 if none).
  int selectedRow = -1;
  
  /// Column of the currently selected square (-1 if none).
  int selectedCol = -1;
  
  /// Number of walls this player has left to place.
  int numOfWalls = 10;
  
  /// Whether special jump/diagonal moves have been temporarily added.
  bool isSpecialAdded = false;

  /// The starting row for this player (goal row for opponent).
  int myInitRow;
  
  /// The starting row for the opponent (this player's goal row).
  int oppInitRow;
  
  /// Shared reference to the board's adjacency list.
  Map<int, List<int>> validMoves;
  
  /// Shared reference to placed wall positions.
  Map<int, String> wallPos;
  
  /// Creates a player with the given configuration.
  Player({
    required this.pawn,
    required this.validMoves,
    required this.wallPos,
    required this.wallColor,
    required this.myInitRow,
    required this.oppInitRow,
  }) {
    selectedRow = -1;
    selectedCol = -1;
  }
  
  /// Executes a player action (pawn move or wall placement) at the given position.
  /// 
  /// Subclasses must implement this to handle their specific input logic.
  /// 
  /// Parameters:
  ///   - [row], [col]: The tapped cell coordinates
  ///   - [oppCurrRow], [oppCurrCol]: Current opponent position
  /// 
  /// Returns a [MoveData] indicating success, intermediate state, or invalidity.
  MoveData play(int row, int col, int oppCurrRow, int oppCurrCol);

  /// Attempts to place a wall by removing edges from the graph, then validates paths.
  /// 
  /// If the wall would completely block either player from reaching their goal,
  /// the wall is rejected and edges are restored.
  /// 
  /// Parameters:
  ///   - [currentGameState]: The state to mutate
  ///   - [firstWall], [secondWall]: Indices of the two wall segments
  ///   - [middleWall]: The center connection point
  ///   - [offset]: Row/column offset to remove correct edges (1 or boardRow)
  /// 
  /// Returns [MoveData.SUCCESSFUL_MOVE] if valid, [MoveData.INVALID_MOVE] otherwise.
  MoveData addingWallEffect(
    GameState currentGameState,
    int firstWall,
    int secondWall,
    int middleWall,
    int offset,
  ) {
    // Remove edges that the new wall blocks
    currentGameState.validMoves[firstWall - offset]!.remove(firstWall + offset);
    currentGameState.validMoves[firstWall + offset]!.remove(firstWall - offset);
    currentGameState.validMoves[secondWall - offset]!.remove(
      secondWall + offset,
    );
    currentGameState.validMoves[secondWall + offset]!.remove(
      secondWall - offset,
    );

    // Validate paths using the mutated state's graph, not the player's global graph
    if (bfs(
              currentGameState.validMoves,
              (currentGameState.myRow) * boardRow + currentGameState.myCol,
              oppInitRow,
            ) ==
            -1 ||
        bfs(
              currentGameState.validMoves,
              (currentGameState.oppRow) * boardRow + currentGameState.oppCol,
              myInitRow,
            ) ==
            -1) {
      currentGameState.validMoves[firstWall - offset]!.add(firstWall + offset);
      currentGameState.validMoves[firstWall + offset]!.add(firstWall - offset);
      currentGameState.validMoves[secondWall - offset]!.add(
        secondWall + offset,
      );
      currentGameState.validMoves[secondWall + offset]!.add(
        secondWall - offset,
      );
      // _showMoveNotAllowedMessage();
      return MoveData.INVALID_MOVE;
    }
    currentGameState.wallPos[firstWall] = wallColor;
    currentGameState.wallPos[secondWall] = wallColor;
    currentGameState.wallPos[middleWall] = wallColor;

    currentGameState.numOfWalls--;
    return MoveData.SUCCESSFUL_MOVE;
  }

  /// Validates and places a wall spanning two adjacent segments.
  /// 
  /// Checks that:
  /// - The middle cell is at an odd row/col intersection
  /// - No wall already exists at those positions
  /// - The player has walls remaining
  /// - Both players retain a path to their goals
  /// 
  /// Parameters:
  ///   - [currentGameState]: State to modify
  ///   - [firstWall], [secondWall]: The two endpoints of the wall
  ///   - [isRow]: True for horizontal walls, false for vertical
  /// 
  /// Returns the result of the wall placement attempt.
  MoveData addWallsToList(
    GameState currentGameState,
    int firstWall,
    int secondWall,
    bool isRow,
  ) {
    int minWall = min(firstWall, secondWall);
    int middleWall = isRow ? (minWall + 1) : (minWall + boardRow);
    int middleWallRow = 0;
    int middleWallCol = 0;
    MoveData isCorrectMove = MoveData.INVALID_MOVE;
    [middleWallRow, middleWallCol] = calculateRowCol(
      middleWall,
      boardSize: boardRow,
    );

    if (middleWall > boardCol * boardRow || secondWall > boardRow * boardCol) {
      return MoveData.INVALID_MOVE;
    }
    if (!(middleWallRow % 2 == 1 && middleWallCol % 2 == 1)) {
      return MoveData.INVALID_MOVE;
    }

    // Use the wall count from the simulated state, not the player's live count
    if ((currentGameState.numOfWalls > 0)) {
      if (!(currentGameState.wallPos.containsKey(firstWall) ||
          currentGameState.wallPos.containsKey(secondWall) ||
          currentGameState.wallPos.containsKey(middleWall))) {
        if (isRow) {
          isCorrectMove = addingWallEffect(
            currentGameState,
            firstWall,
            secondWall,
            middleWall,
            boardRow,
          );
        } else {
          isCorrectMove = addingWallEffect(
            currentGameState,
            firstWall,
            secondWall,
            middleWall,
            1,
          );
        }
      }
    }

    return isCorrectMove;
  }

  /// Temporarily adds jump or diagonal moves when facing the opponent.
  /// 
  /// If the opponent blocks the forward path:
  /// - Allow jumping over them if the space behind is free
  /// - Otherwise allow diagonal moves to either side
  /// 
  /// These edges are removed by [removeSpecialCases] after the move.
  /// 
  /// Parameters:
  ///   - [currentGameState]: State to modify
  ///   - [isMyRowMax]: True if this player starts at a higher row than opponent
  void addSpecialCase(GameState currentGameState, bool isMyRowMax) {
    int offset = isMyRowMax ? -2 : 2;
    int targetRow = currentGameState.myRow + offset;
    int myPosition = currentGameState.myRow * boardRow + currentGameState.myCol;
    int oppPosition = currentGameState.oppRow * boardRow + currentGameState.oppCol;
    
    // Check if opponent is directly in front of current player (same column)
    bool isOpponentBlocking = (targetRow == currentGameState.oppRow) &&
        (currentGameState.myCol == currentGameState.oppCol);
    
    // currentGameState.validMoves[myPosition]!.remove(oppPosition);

    if (isOpponentBlocking) {
      int jumpOverPosition = (currentGameState.oppRow + offset) * boardRow + currentGameState.oppCol;
      int diagonalPosition = (currentGameState.oppRow) * boardRow + currentGameState.oppCol + offset;
      int otherDiagonalPosition = (currentGameState.oppRow) * boardRow + currentGameState.oppCol - offset;

        // If opponent can move forward, allow jumping over them
      bool canOpponentMoveForward = 
          currentGameState.validMoves[oppPosition]!.contains(jumpOverPosition);
      
      if (canOpponentMoveForward) {
        currentGameState.validMoves[myPosition]!.add(jumpOverPosition);
      }
      else {
        if(currentGameState.validMoves[oppPosition]!.contains(diagonalPosition)) {
          currentGameState.validMoves[myPosition]!.add(diagonalPosition);
        }

        if(currentGameState.validMoves[oppPosition]!.contains(otherDiagonalPosition)) {
          currentGameState.validMoves[myPosition]!.add(otherDiagonalPosition);
        }
      }
      isSpecialAdded = true;
    }
  }

  /// Cleans up the temporary jump/diagonal edges added by [addSpecialCase].
  /// 
  /// Removes the special movement options after a pawn has moved or
  /// the player has switched to wall placement.
  /// 
  /// Parameters:
  ///   - [currentGameState]: State to modify
  ///   - [row], [col]: The position to clean up from
  ///   - [isMyRowMax]: Direction context for calculating positions
  void removeSpecialCases(GameState currentGameState, int row, int col, bool isMyRowMax) {
    int index = row*boardRow + col;
    // int oppPosition = currentGameState.oppRow * boardRow + currentGameState.oppCol;
    int offset = isMyRowMax ? -2 : 2;

    int jumpOverPosition = (currentGameState.oppRow + offset) * boardRow + currentGameState.oppCol;
    int diagonalPosition = (currentGameState.oppRow) * boardRow + currentGameState.oppCol + offset;
    int otherDiagonalPosition = (currentGameState.oppRow) * boardRow + currentGameState.oppCol - offset;

    currentGameState.validMoves[index]!.remove(jumpOverPosition);
    currentGameState.validMoves[index]!.remove(diagonalPosition);
    currentGameState.validMoves[index]!.remove(otherDiagonalPosition);

    // currentGameState.validMoves[index]??[].add(oppPosition);
  }
}
