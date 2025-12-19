import 'package:flutter/material.dart';
import 'package:quoridor_game/game_logic/computer_player.dart';
import 'package:quoridor_game/game_logic/human_player.dart';
import 'package:quoridor_game/game_logic/player.dart';
import 'package:quoridor_game/helper/helper_func.dart';
import 'package:quoridor_game/helper/move_data.dart';
import 'package:quoridor_game/views/pages/pawn.dart';
import 'package:quoridor_game/views/pages/scoreboard_walls.dart';
import 'package:quoridor_game/views/pages/square.dart';
import 'package:quoridor_game/views/pages/wall.dart';
import 'package:staggered_grid_view/flutter_staggered_grid_view.dart';

const int boardRow = 17;
const int boardCol = 17;

const int myInitRow = 16;
const int oppInitRow = 0;
const int initCol = 8;

const String myWallColor = 'r';
const String oppWallColor = 'b';

class Board extends StatefulWidget {
  final bool isOppHuman;
  const Board({super.key, required this.isOppHuman});

  @override
  // ignore: no_logic_in_create_state
  State<Board> createState() => _BoardState(isOppHuman);
}

class _BoardState extends State<Board> {
  bool isOppHuman;
  Pawn myPawn = Pawn(
    isWhite: true,
    imagePath: 'assets/images/pawn.png',
    currRow: myInitRow,
    currCol: initCol,
  );
  Pawn oppPawn = Pawn(
    isWhite: false,
    imagePath: 'assets/images/pawn.png',
    currRow: oppInitRow,
    currCol: initCol,
  );

  bool isMyTurn =
      true; // when isMyTurn is true i can either move the white pawn or add a wall

  late Map<int, List<int>> validMoves = createInitialValidMoves();
  Map<int, String> wallPos = {};

  late Player player1 = HumanPlayer(
    pawn: myPawn,
    validMoves: validMoves,
    wallPos: wallPos,
    wallColor: myWallColor,
    myInitRow: myInitRow,
    oppInitRow: oppInitRow,
  );

  late Player player2 = isOppHuman
      ? HumanPlayer(
          pawn: oppPawn,
          validMoves: validMoves,
          wallPos: wallPos,
          wallColor: oppWallColor,
          myInitRow: oppInitRow,
          oppInitRow: myInitRow,
        )
      : ComputerPlayer(
          pawn: oppPawn,
          validMoves: validMoves,
          wallPos: wallPos,
          wallColor: oppWallColor,
          myInitRow: oppInitRow,
          oppInitRow: myInitRow,
        );

  late Player currentPlayer = player1;

  _BoardState(this.isOppHuman) {
    resetGame();
  }

  /// Populates the validMoves map with initial orthogonal connections
  /// for all 81 squares on a 9x9 Quoridor board.
  Map<int, List<int>> createInitialValidMoves() {
    Map<int, List<int>> moves = {};
    const int boardSize = boardRow; // The board is 9x9

    // Iterate through all 81 squares (indices 0 to 80)
    for (int index = 0; index < boardCol * boardRow; index++) {
      List<int> currentMoves = [];

      // Convert the 1D index to 2D coordinates
      int row = index ~/ boardSize; // Row (0-8)
      int col = index % boardSize; // Column (0-8)

      // Calculate the potential moves (North, South, West, East)
      if (row % 2 == 1 || col % 2 == 1) {
        continue;
      }
      // 1. Check NORTH (move to row - 1)
      if (row > 1) {
        currentMoves.add(index - (boardSize * 2)); // index - 9
      }

      // 2. Check SOUTH (move to row + 1)
      if (row < boardSize - 2) {
        currentMoves.add(index + (boardSize * 2)); // index + 9
      }

      // 3. Check WEST (move to col - 1)
      if (col > 1) {
        currentMoves.add(index - 2);
      }

      // 4. Check EAST (move to col + 1)
      if (col < boardSize - 2) {
        currentMoves.add(index + 2);
      }

      // Assign the list of valid neighbors to the current square's index
      moves[index] = currentMoves;
    }

    return moves;
  }

  void resetGame() {
    // Reset Game Logic
    // Keep shared map reference so Player and Board stay in sync
    validMoves
      ..clear()
      ..addAll(createInitialValidMoves());
    player1.numOfWalls = 10;
    player2.numOfWalls = 10;
    isMyTurn = true;
    wallPos.clear();

    // Assuming you have variables for initial positions
    // Make sure these variables (myInitRow, etc.) are accessible here
    player1.pawn.currRow = myInitRow;
    player1.pawn.currCol = initCol;
    player2.pawn.currRow = oppInitRow;
    player2.pawn.currCol = initCol;
  }

  void _showDialog(String winner) {
    final Color dialogBgColor = const Color(0xFFF8E7BB); // Light Beige/Cream
    final Color buttonColor = const Color(
      0xFF8D6E63,
    ); // Brown (matches squares)
    final Color textColor = const Color(0xFF5D4037); // Darker Brown for text

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent clicking outside to close
      builder: (context) {
        return AlertDialog(
          // Rounded corners for a softer, modern feel
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: dialogBgColor,

          // Centered Title with distinct styling
          title: Column(
            children: [
              const Icon(
                Icons.emoji_events_rounded,
                size: 50,
                color: Colors.orange,
              ),
              const SizedBox(height: 10),
              Text(
                '$winner Won!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto', // Or your app's custom font
                ),
              ),
            ],
          ),

          // Center the actions at the bottom
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.only(bottom: 20, top: 10),

          actions: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  resetGame();
                });
              },
              // Styling the button to pop against the beige background
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor, // The brown square color
                foregroundColor: Colors.white, // White text/icon
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5, // Slight shadow for depth
              ),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text(
                'Restart Game',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showMoveNotAllowedMessage() {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        const SnackBar(
          backgroundColor: Color.fromARGB(255, 242, 154, 154),
          content: Center(
            child: Text(
              'Move NOT Allowed',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w700,
                color: Color.fromARGB(255, 51, 49, 49),
              ),
            ),
          ),
          duration: Duration(seconds: 1),
        ),
      );
  }

  void _handleTap(int row, int col) {
    final current = isMyTurn ? player1 : player2;
    final other = isMyTurn ? player2 : player1;
    MoveData didAct = MoveData.SUCCESSFUL_MOVE;
    setState(() {
      didAct = current.play(row, col, other.pawn.currRow, other.pawn.currCol);
    });

    if (didAct == MoveData.INVALID_MOVE) {
      _showMoveNotAllowedMessage();
      return;
    }

    final bool currentWon = current == player1
        ? current.pawn.currRow == other.myInitRow
        : current.pawn.currRow == other.myInitRow;

    if (currentWon) {
      _showDialog(current == player1 ? 'White' : 'Black');
      return;
    }

    setState(() {

      if(didAct == MoveData.SUCCESSFUL_MOVE) {
        isMyTurn = !isMyTurn;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Cross-axis must match the summed widths of squares (4 units) and walls (1 unit).
    final int squareCountPerRow =
        (boardCol + 1) ~/ 2; // even indices are squares
    final int wallCountPerRow =
        boardCol - squareCountPerRow; // odd indices are walls
    final int crossAxisUnits =
        squareCountPerRow * 4 + wallCountPerRow; // 9*4 + 8*1 = 44

    return Center(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              color: Colors.orange[100],
            ),
            padding: EdgeInsets.all(5.0),
            margin: EdgeInsets.all(10.0),
            child: AspectRatio(
              aspectRatio: 1.0,
              child: StaggeredGridView.countBuilder(
                shrinkWrap: true,
                itemCount: boardCol * boardRow,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: crossAxisUnits,
                itemBuilder: (context, index) {
                  int row = 0;
                  int col = 0;
                  [row, col] = calculateRowCol(index, boardSize: boardRow);
                  if (row == player1.pawn.currRow &&
                      col == player1.pawn.currCol) {
                    currentPlayer = player1;
                  } else if (row == player2.pawn.currRow &&
                      col == player2.pawn.currCol) {
                    currentPlayer = player2;
                  }

                  final player = isMyTurn ? player1 : player2;

                  bool isValidMove = (validMoves[player.selectedRow * boardRow +
                              player.selectedCol] ?? []).contains(index);
                          
                  bool isSelected = 
                      (row == player.selectedRow) &&
                      (col == player.selectedCol);

                  if (row % 2 == 1 || col % 2 == 1) {
                    return Wall(
                      isWallSelected: wallPos.containsKey(index),
                      onTapFunc: () => _handleTap(row, col),
                      wallColortxt: wallPos[index],
                    );
                  } else {
                    return Square(
                      piece:
                          ((row == currentPlayer.pawn.currRow) &&
                              (col == currentPlayer.pawn.currCol))
                          ? currentPlayer.pawn
                          : null,
                      onTapFunc: () => _handleTap(row, col),
                      isValidMove: isValidMove,
                      isSelected: isSelected,
                    );
                  }
                },
                staggeredTileBuilder: (int index) {
                  // 1. Calculate which row and column this index belongs to
                  // (This assumes you know the total columns is 17)
                  int row = 0;
                  int col = 0;
                  [row, col] = calculateRowCol(index, boardSize: boardRow);

                  // 2. Decide size based on row/col parity
                  bool isSquareRow = row % 2 == 0;
                  bool isSquareCol = col % 2 == 0;

                  if (isSquareRow && isSquareCol) {
                    return StaggeredTile.count(4, 4); // Square
                  }
                  if (isSquareRow && !isSquareCol) {
                    return StaggeredTile.count(1, 4); // V-Wall
                  }
                  if (!isSquareRow && isSquareCol) {
                    return StaggeredTile.count(4, 1); // H-Wall
                  }
                  return StaggeredTile.count(1, 1); // Intersection
                },
              ),
            ),
          ),
          ScoreboardWalls(
            myNumOfWalls: player1.numOfWalls,
            oppNumOfWalls: player2.numOfWalls,
            isMyTurn: isMyTurn,
          ),
        ],
      ),
    );
  }
}
