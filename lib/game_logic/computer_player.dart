import 'package:quoridor_game/game_logic/player.dart';

class ComputerPlayer extends Player{
  ComputerPlayer({required super.pawn,  required super.validMoves, required super.wallPos, required super.wallColor, required super.myInitRow, required super.oppInitRow});
  
  @override
  bool play(int row, int col, int oppCurrRow, int oppCurrCol) {
    // TODO: implement play
    throw UnimplementedError();
  }
  

}
