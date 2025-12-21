/// Results for a player's attempted action.
/// 
/// Used to communicate the outcome of tap interactions and AI moves.
enum MoveData {
  // ignore: constant_identifier_names
  /// The move was valid and completed successfully (pawn moved or wall placed).
  SUCCESSFUL_MOVE,
  // ignore: constant_identifier_names
  /// The action is incomplete (e.g., first wall segment selected, awaiting second).
  INTERMEDIATE_MOVE,
  // ignore: constant_identifier_names
  /// The attempted action violates game rules.
  INVALID_MOVE
}