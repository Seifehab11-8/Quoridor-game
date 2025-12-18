import 'dart:math';

import 'package:quoridor_game/helper/helper_func.dart';
import 'package:quoridor_game/views/pages/pawn.dart';

const int boardRow = 17;
const int boardCol = 17;

abstract class Player {
  Pawn pawn;
  String wallColor;
  int? prevSelectedWall;
  int? selectedRow = -1;
  int? selectedCol = -1;
  int numOfWalls = 10;

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
  });
  bool play(int row, int col, int oppCurrRow, int oppCurrCol);

  bool addingWallEffect(
    int firstWall,
    int secondWall,
    int middleWall,
    int offset,
    int oppCurrRow,
    int oppCurrCol
  ) {
    validMoves[firstWall - offset]!.remove(firstWall + offset);
    validMoves[firstWall + offset]!.remove(firstWall - offset);

    validMoves[secondWall - offset]!.remove(secondWall + offset);
    validMoves[secondWall + offset]!.remove(secondWall - offset);

    if (!bfs(
          validMoves,
          (pawn.currRow) * boardRow + pawn.currCol,
          oppInitRow,
        ) ||
        !bfs(
          validMoves,
          (oppCurrRow) * boardRow + oppCurrCol,
          myInitRow,
        )) {
      validMoves[firstWall - offset]!.add(firstWall + offset);
      validMoves[firstWall + offset]!.add(firstWall - offset);

      validMoves[secondWall - offset]!.add(secondWall + offset);
      validMoves[secondWall + offset]!.add(secondWall - offset);
      prevSelectedWall = -1;
      // _showMoveNotAllowedMessage();
      return false;
    }
    wallPos[firstWall] = wallColor;
    wallPos[secondWall] = wallColor;
    wallPos[middleWall] = wallColor;

    numOfWalls--;
    selectedRow = -1;
    selectedCol = -1;
    return true;
  }

  bool addWallsToList(int firstWall, int secondWall,int oppCurrRow,
    int oppCurrCol, bool isRow) {
    int minWall = min(firstWall, secondWall);
    int middleWall = isRow ? (minWall + 1) : (minWall + boardRow);
    int middleWallRow = 0;
    int middleWallCol = 0;
    bool isCorrectMove = true;
    [middleWallRow, middleWallCol] = calculateRowCol(
      middleWall,
      boardSize: boardRow,
    );

    if (!(middleWallRow % 2 == 1 && middleWallCol % 2 == 1)) {
      return false;
    }

    if ((numOfWalls > 0) || (numOfWalls > 0)) {
      if (isRow && (!wallPos.containsKey(middleWall))) {
        isCorrectMove = addingWallEffect(firstWall, secondWall, middleWall, boardRow, oppCurrRow, oppCurrCol);
      } else if (!wallPos.containsKey(middleWall)) {
        isCorrectMove = addingWallEffect(firstWall, secondWall, middleWall, 1, oppCurrRow, oppCurrCol);
      }
    }

    return isCorrectMove;
  }
}
