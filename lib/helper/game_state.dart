import 'package:quoridor_game/helper/helper_func.dart';

class GameState {
  Map<int, List<int>> validMoves;
  Map<int, String> wallPos;
  int myRow;
  int myCol;
  int oppRow;
  int oppCol;
  int numOfWalls;
  int oppNumOfWalls;
  double ?heuristicValue; // non-null for comparison
  double alpha;
  double beta;

  GameState({
    required this.validMoves,
    required this.wallPos,
    required this.myRow,
    required this.myCol,
    required this.oppRow,
    required this.oppCol,
    required this.alpha,
    required this.beta,
    this.numOfWalls = 10,
    this.oppNumOfWalls = 10,
  });

  GameState clone({
    double? heuristicOverride,
    double? alphaOverride,
    double? betaOverride,
  }) {
    final clonedValidMoves = deepCopyValidMoves(validMoves);
    final clonedWallPos = copyWallPos(wallPos);
    return GameState(
      validMoves: clonedValidMoves,
      wallPos: clonedWallPos,
      myRow: myRow,
      myCol: myCol,
      oppRow: oppRow,
      oppCol: oppCol,
      numOfWalls: numOfWalls,
      oppNumOfWalls: oppNumOfWalls,
      alpha: alphaOverride ?? alpha,
      beta: betaOverride ?? beta,
    );
  }
}

// Helpers that mirror max/min but use heuristicValue
GameState maxState(GameState a, GameState b) {
  if(a.heuristicValue == null) return b;
  if(b.heuristicValue == null) return a;
  return a.heuristicValue! > b.heuristicValue! ? a : b;
}

GameState minState(GameState a, GameState b) {
    if(a.heuristicValue == null) return b;
    if(b.heuristicValue == null) return a;
    return a.heuristicValue! > b.heuristicValue! ? b : a;
}

