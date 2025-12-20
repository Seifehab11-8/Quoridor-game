import 'package:quoridor_game/game_logic/player.dart';
import 'package:quoridor_game/helper/game_state.dart';
import 'package:quoridor_game/helper/helper_func.dart';
import 'package:quoridor_game/helper/move_data.dart';

class ComputerPlayer extends Player {
  ComputerPlayer({
    required super.pawn,
    required super.validMoves,
    required super.wallPos,
    required super.wallColor,
    required super.myInitRow,
    required super.oppInitRow,
  });

  @override
  MoveData play(int row, int col, int oppCurrRow, int oppCurrCol) {
    int oppNumOfWalls =
        10 - (wallPos.values.where((wall) => wall != wallColor).length) ~/ 3;

    final allPossibleMoves = generateAllStates(
      GameState(
        validMoves: deepCopyValidMoves(validMoves),
        wallPos: copyWallPos(wallPos),
        myRow: pawn.currRow,
        myCol: pawn.currCol,
        oppRow: oppCurrRow,
        oppCol: oppCurrCol,
        numOfWalls: numOfWalls,
        oppNumOfWalls: oppNumOfWalls, alpha: double.negativeInfinity, beta: double.infinity,
      ),
    );

    GameState finalMove = allPossibleMoves.first;
    for (final state in allPossibleMoves) {
      final possibleMove = minimax(
        state.clone(),
        1,
        1,
        false,
      );
      if (finalMove.heuristicValue == null ||
          finalMove.heuristicValue! < possibleMove.heuristicValue!) {
        finalMove = state.clone();
        finalMove.heuristicValue = possibleMove.heuristicValue;
      }
    }

    validMoves
      ..clear()
      ..addAll(deepCopyValidMoves(finalMove.validMoves));
    wallPos
      ..clear()
      ..addAll(copyWallPos(finalMove.wallPos));

    pawn.currRow = finalMove.myRow;
    pawn.currCol = finalMove.myCol;
    numOfWalls = finalMove.numOfWalls;

    return MoveData.SUCCESSFUL_MOVE;
  }

  GameState minimax(
    GameState currentGameState,
    int currentLevel,
    int maxLevel,
    bool isMax,
  ) {
    int temp = currentGameState.numOfWalls;
    currentGameState.numOfWalls = currentGameState.oppNumOfWalls;
    currentGameState.oppNumOfWalls = temp;

    temp = currentGameState.myRow;
    currentGameState.myRow = currentGameState.oppRow;
    currentGameState.oppRow = temp;

    temp = currentGameState.myCol;
    currentGameState.myCol = currentGameState.oppCol;
    currentGameState.oppCol = temp;

    if (currentLevel > maxLevel) {
      currentGameState.heuristicValue = calculateHeuristic(
        isMax,
        currentGameState,
      );
      return currentGameState;
    }

    final states = generateAllStates(currentGameState);
    GameState bestMove = currentGameState.clone();

    for (final state in states) {
      final gamestate = minimax(
        state.clone(),
        currentLevel + 1,
        maxLevel,
        !isMax,
      );

      bestMove = isMax
          ? maxState(gamestate, bestMove)
          : minState(gamestate, bestMove);
      
      if(isMax){
        if(bestMove.heuristicValue! >= currentGameState.beta) {
          return bestMove;
        }

        if(bestMove.heuristicValue! > currentGameState.alpha) {
          currentGameState.alpha = bestMove.heuristicValue!;
        }
      }
      else {
        if(bestMove.heuristicValue! <= currentGameState.alpha) {
          return bestMove;
        }

        if(bestMove.heuristicValue! < currentGameState.beta) {
          currentGameState.beta = bestMove.heuristicValue!;
        }
      }
    }

    return bestMove;
  }

  List<GameState> generateAllStates(GameState currentState) {
    List<GameState> allPossibleStates = [];

    //Pawn Movements
    int index = currentState.myRow * boardRow + currentState.myCol;
    int oppIndex = currentState.oppRow * boardRow + currentState.oppCol;

    // Check if pawns are facing each other (same column, 2 rows apart)
    bool arePawnsFacing = (currentState.myCol == currentState.oppCol) &&
        ((currentState.myRow - currentState.oppRow).abs() == 2);

    if (arePawnsFacing) {
      // Add special case moves (jump or diagonal)
      bool isMyRowMax = myInitRow > currentState.oppRow;
      int offset = isMyRowMax ? -2 : 2;
      int jumpOverPosition = (currentState.oppRow + offset) * boardRow + currentState.oppCol;
      int diagonalLeft = currentState.oppRow * boardRow + (currentState.oppCol - 2);
      int diagonalRight = currentState.oppRow * boardRow + (currentState.oppCol + 2);

      // Check if can jump over opponent
      if (currentState.validMoves[oppIndex]!.contains(jumpOverPosition)) {
        GameState jumpState = currentState.clone();
        jumpState.myRow = currentState.oppRow + offset;
        jumpState.myCol = currentState.oppCol;
        allPossibleStates.add(jumpState);
      } else {
        // If can't jump, check diagonal moves
        if (currentState.validMoves[oppIndex]!.contains(diagonalLeft)) {
          GameState diagonalLeftState = currentState.clone();
          diagonalLeftState.myRow = currentState.oppRow;
          diagonalLeftState.myCol = currentState.oppCol - 2;
          allPossibleStates.add(diagonalLeftState);
        }

        if (currentState.validMoves[oppIndex]!.contains(diagonalRight)) {
          GameState diagonalRightState = currentState.clone();
          diagonalRightState.myRow = currentState.oppRow;
          diagonalRightState.myCol = currentState.oppCol + 2;
          allPossibleStates.add(diagonalRightState);
        }
      }
    }

    // Standard pawn movements
    GameState movePawnInRowRight = currentState.clone();
    if (movePawnInRowRight.validMoves[index]!.contains(index + 2) &&
        oppIndex != (index + 2)) {
      movePawnInRowRight.myCol = movePawnInRowRight.myCol + 2;
      allPossibleStates.add(movePawnInRowRight);
    }

    GameState movePawnInRowLeft = currentState.clone();
    if (movePawnInRowLeft.validMoves[index]!.contains(index - 2) &&
        oppIndex != (index - 2)) {
      movePawnInRowLeft.myCol = movePawnInRowLeft.myCol - 2;
      allPossibleStates.add(movePawnInRowLeft);
    }

    GameState movePawnInColUp = currentState.clone();
    if (movePawnInColUp.validMoves[index]!.contains(index + 2 * boardRow) &&
        oppIndex != (index + 2 * boardRow)) {
      movePawnInColUp.myRow = movePawnInColUp.myRow + 2;
      allPossibleStates.add(movePawnInColUp);
    }

    GameState movePawnInColDown = currentState.clone();
    if (movePawnInColDown.validMoves[index]!.contains(index - 2 * boardRow) &&
        oppIndex != (index - 2 * boardRow)) {
      movePawnInColDown.myRow = movePawnInColDown.myRow - 2;
      allPossibleStates.add(movePawnInColDown);
    }

    for (int i = 1; i < boardRow; i += 2) {
      for (int j = 0; j < boardCol; j += 2) {
        GameState wallPlacementState = currentState.clone();
        MoveData isAllowed = addWallsToList(
          wallPlacementState,
          i * boardRow + j,
          (i * boardRow + j) + 2,
          true,
        );
        if (!(isAllowed == MoveData.INVALID_MOVE)) {
          allPossibleStates.add(wallPlacementState);
        }
      }
    }

    for (int i = 1; i < boardCol; i += 2) {
      for (int j = 0; j < boardRow; j += 2) {
        GameState wallPlacementState = currentState.clone();
        MoveData isAllowed = addWallsToList(
          wallPlacementState,
          j * boardRow + i,
          (boardRow * j + i) + 2 * boardRow,
          false,
        );
        if (!(isAllowed == MoveData.INVALID_MOVE)) {
          allPossibleStates.add(wallPlacementState);
        }
      }
    }

    return allPossibleStates;
  }

  double calculateHeuristic(bool isMax, GameState current) {
    double hValue = 0;
    int lMyInitRow = isMax ? oppInitRow : myInitRow;
    int lOppInitRow = isMax ? myInitRow : oppInitRow;
    hValue +=
        0.6001 *
        (current.myRow - current.oppRow); // position difference feature
    hValue +=
        14.45 *
        (lMyInitRow - bfs(
          current.validMoves,
          current.myRow * boardRow + current.myCol,
          lMyInitRow,
        )).abs(); // minimize my distance from the goal
    hValue +=
        6.52 *
        bfs(
          current.validMoves,
          current.oppRow * boardRow + current.oppCol,
          lOppInitRow,
        ); // maxmize opponent distance
    return hValue;
  }
}
