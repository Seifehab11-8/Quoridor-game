import 'package:flutter/material.dart';
import 'package:quoridor_game/helper/helper_func.dart';
import 'package:quoridor_game/views/pages/pawn.dart';
import 'package:quoridor_game/views/pages/square.dart';

const int boardRow = 9;
const int boardCol = 9;

class Board extends StatefulWidget {
  const Board({super.key});

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  Pawn myPawn = Pawn(
    isWhite: true,
    imagePath: 'assets/images/pawn.png',
    currRow: 8,
    currCol: 4,
  );
  Pawn oppPawn = Pawn(
    isWhite: false,
    imagePath: 'assets/images/pawn.png',
    currRow: 0,
    currCol: 4,
  );
  Map<int, List<int>> get validMoves => createInitialValidMoves();

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

  void checkIfSelected(int row, int col) {
    setState(() {
      if (row == myPawn.currRow && col == myPawn.currCol) {
        selectedRow = row;
        selectedCol = col;
      } else if (row == oppPawn.currRow && col == oppPawn.currCol) {
        selectedRow = row;
        selectedCol = col;
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
              //TODO:implement a way to light up available moves for a selected pawn

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
