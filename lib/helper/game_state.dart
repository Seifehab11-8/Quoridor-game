import 'package:quoridor_game/helper/helper_func.dart';

/// Immutable snapshot of a board position used by both UI and minimax search.
/// 
/// Represents the complete state needed to evaluate moves and generate successors.
/// The AI clones this state for each simulation to avoid mutating the live game.
class GameState {
  /// Adjacency list of valid pawn movements between cells.
  Map<int, List<int>> validMoves;
  
  /// Maps cell indices to wall colors ('r' for red, 'b' for blue).
  Map<int, String> wallPos;
  
  /// Current row of the active player (0-16, even only).
  int myRow;
  
  /// Current column of the active player (0-16, even only).
  int myCol;
  
  /// Current row of the opponent (0-16, even only).
  int oppRow;
  
  /// Current column of the opponent (0-16, even only).
  int oppCol;
  
  /// Number of walls remaining for the active player.
  int numOfWalls;
  
  /// Number of walls remaining for the opponent.
  int oppNumOfWalls;
  
  /// Computed score for this position (set by minimax).
  double ?heuristicValue;
  
  /// Alpha value for alpha-beta pruning.
  double alpha;
  
  /// Beta value for alpha-beta pruning.
  double beta;

  /// Creates a game state with the specified board configuration.
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

  /// Creates a deep copy of this game state for simulation.
  /// 
  /// Clones the validMoves and wallPos graphs so minimax exploration
  /// cannot mutate sibling branches or the live game state.
  /// 
  /// Optional overrides allow updating alpha/beta bounds during search.
  GameState clone({
    double? heuristicOverride,
    double? alphaOverride,
    double? betaOverride,
  }) {
    // Deep copy graphs so minimax exploration cannot mutate siblings.
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

/// Returns the GameState with the higher heuristic value.
/// 
/// If either state has a null heuristic, returns the non-null one.
/// Used during max nodes in minimax search.
GameState maxState(GameState a, GameState b) {
  if(a.heuristicValue == null) return b;
  if(b.heuristicValue == null) return a;
  return a.heuristicValue! > b.heuristicValue! ? a : b;
}

/// Returns the GameState with the lower heuristic value.
/// 
/// If either state has a null heuristic, returns the non-null one.
/// Used during min nodes in minimax search.
GameState minState(GameState a, GameState b) {
    if(a.heuristicValue == null) return b;
    if(b.heuristicValue == null) return a;
    return a.heuristicValue! > b.heuristicValue! ? b : a;
}

