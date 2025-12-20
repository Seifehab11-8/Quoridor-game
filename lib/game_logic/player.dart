import 'dart:math';

import 'package:quoridor_game/helper/game_state.dart';
import 'package:quoridor_game/helper/helper_func.dart';
import 'package:quoridor_game/helper/move_data.dart';
import 'package:quoridor_game/views/pages/pawn.dart';

const int boardRow = 17;
const int boardCol = 17;
const bool kDebugMode = true;

abstract class Player {
  Pawn pawn;
  String wallColor;
  int selectedRow = -1;
  int selectedCol = -1;
  int numOfWalls = 10;
  bool isSpecialAdded = false;

  int myInitRow;
  int oppInitRow;
  Map<int, List<int>> validMoves;
  Map<int, String> wallPos;
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
  MoveData play(int row, int col, int oppCurrRow, int oppCurrCol);

  MoveData addingWallEffect(
    GameState currentGameState,
    int firstWall,
    int secondWall,
    int middleWall,
    int offset,
  ) {
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
