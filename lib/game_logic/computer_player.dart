import 'package:quoridor_game/game_logic/player.dart';
import 'package:quoridor_game/helper/move_data.dart';

class ComputerPlayer extends Player{
  ComputerPlayer({required super.pawn,  required super.validMoves, required super.wallPos, required super.wallColor, required super.myInitRow, required super.oppInitRow});
  
  @override
  MoveData play(int row, int col, int oppCurrRow, int oppCurrCol) {
    pawn.currRow = pawn.currRow + 2;
    return MoveData.SUCCESSFUL_MOVE;
  }
  

}
