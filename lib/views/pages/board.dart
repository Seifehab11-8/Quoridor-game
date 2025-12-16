import 'package:flutter/material.dart';
import 'package:quoridor_game/helper/helper_func.dart';
import 'package:quoridor_game/views/pages/pawn.dart';
import 'package:quoridor_game/views/pages/square.dart';

const int boardRow = 9;
const int boardCol = 9;

const int myInitRow = 8;
const int oppInitRow = 0;
const int initCol = 4;

class Board extends StatefulWidget {
  const Board({super.key});

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
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
  late Map<int, List<int>> validMoves = createInitialValidMoves();

  int selectedRow = -1;
  int selectedCol = -1;

  /// Populates the validMoves map with initial orthogonal connections
  /// for all 81 squares on a 9x9 Quoridor board.
  Map<int, List<int>> createInitialValidMoves() {
    Map<int, List<int>> moves = {};
    const int boardSize = boardRow; // The board is 9x9

    // Iterate through all 81 squares (indices 0 to 80)
    for (int index = 0; index < 81; index++) {
      List<int> currentMoves = [];

      // Convert the 1D index to 2D coordinates
      int row = index ~/ boardSize; // Row (0-8)
      int col = index % boardSize; // Column (0-8)

      // Calculate the potential moves (North, South, West, East)

      // 1. Check NORTH (move to row - 1)
      if (row > 0) {
        currentMoves.add(index - boardSize); // index - 9
      }

      // 2. Check SOUTH (move to row + 1)
      if (row < boardSize - 1) {
        currentMoves.add(index + boardSize); // index + 9
      }

      // 3. Check WEST (move to col - 1)
      if (col > 0) {
        currentMoves.add(index - 1);
      }

      // 4. Check EAST (move to col + 1)
      if (col < boardSize - 1) {
        currentMoves.add(index + 1);
      }

      // Assign the list of valid neighbors to the current square's index
      moves[index] = currentMoves;
    }

    return moves;
  }

  void _showDialog(String winner) {

    final Color dialogBgColor = const Color(0xFFF8E7BB); // Light Beige/Cream
    final Color buttonColor = const Color(0xFF8D6E63);   // Brown (matches squares)
    final Color textColor = const Color(0xFF5D4037);     // Darker Brown for text

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
              const Icon(Icons.emoji_events_rounded, size: 50, color: Colors.orange),
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
                  // Reset Game Logic
                  validMoves = createInitialValidMoves();
                  
                  // Assuming you have variables for initial positions
                  // Make sure these variables (myInitRow, etc.) are accessible here
                  myPawn.currRow = myInitRow;
                  myPawn.currCol = initCol;
                  oppPawn.currRow = oppInitRow;
                  oppPawn.currCol = initCol;
                });
              },
              // Styling the button to pop against the beige background
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor, // The brown square color
                foregroundColor: Colors.white, // White text/icon
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
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

  void checkIfSelected(int row, int col) {
    int index = row * boardRow + col;
    setState(() {
      if (row == myPawn.currRow && col == myPawn.currCol) {
        selectedRow = row;
        selectedCol = col;
      } else if (row == oppPawn.currRow && col == oppPawn.currCol) {
        selectedRow = row;
        selectedCol = col;
      }

      if ((validMoves[selectedRow * boardRow + selectedCol] == null
          ? false
          : validMoves[selectedRow * boardRow + selectedCol]!.contains(index) &&
                myPawn.currRow == selectedRow &&
                myPawn.currCol == selectedCol)) {
        myPawn.currRow = row;
        myPawn.currCol = col;
        selectedRow = -1;
        selectedCol = -1;
      } else if ((validMoves[selectedRow * boardRow + selectedCol] == null
          ? false
          : validMoves[selectedRow * boardRow + selectedCol]!.contains(index) &&
                oppPawn.currRow == selectedRow &&
                oppPawn.currCol == selectedCol)) {
        oppPawn.currRow = row;
        oppPawn.currCol = col;
        selectedRow = -1;
        selectedCol = -1;
      }

      if (myPawn.currRow == oppInitRow) {
        _showDialog('You');
      } else if (oppPawn.currRow == myInitRow) {
        _showDialog('Opponent');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          color: Colors.orange[100],
        ),
        padding: EdgeInsets.all(5.0),
        margin: EdgeInsets.all(10.0),
        child: AspectRatio(
          aspectRatio: 1.0,
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: boardCol * boardRow,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: boardRow,
            ),
            itemBuilder: (context, index) {
              int row = 0;
              int col = 0;
              [row, col] = calculateRowCol(index, boardRow);
              bool isSelected = (selectedRow == row) && (selectedCol == col);
              bool isValidMove = false;

              if (row == myPawn.currRow && col == myPawn.currCol) {
                return Square(
                  piece: myPawn,
                  isSelected: isSelected,
                  isValidMove: isValidMove,
                  onTapFunc: () => checkIfSelected(row, col),
                );
              } else if (row == oppPawn.currRow && col == oppPawn.currCol) {
                return Square(
                  piece: oppPawn,
                  isSelected: isSelected,
                  isValidMove: isValidMove,
                  onTapFunc: () => checkIfSelected(row, col),
                );
              } else {
                isValidMove =
                    validMoves[selectedRow * boardRow + selectedCol] == null
                    ? false
                    : validMoves[selectedRow * boardRow + selectedCol]!
                          .contains(index);
                return Square(
                  piece: null,
                  isSelected: isSelected,
                  isValidMove: isValidMove,
                  onTapFunc: () => checkIfSelected(row, col),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
