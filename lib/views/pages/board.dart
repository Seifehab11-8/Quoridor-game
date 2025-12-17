import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:quoridor_game/helper/helper_func.dart';
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

  int myNumOfWalls = 10;
  int oppNumOfWalls = 10;
  bool isMyTurn =
      true; // when isMyTurn is true i can either move the white pawn or add a wall

  late Map<int, List<int>> validMoves = createInitialValidMoves();
  Map<int, String> wallPos = {};

  int selectedRow = -1;
  int selectedCol = -1;

  int prevSelectedWall = -1;

  bool bfs(int startVertex, int targetRow) {
    Queue<int> tempQueue = Queue<int>();
    Set<int> visitedNodes = {};
    tempQueue.add(startVertex);
    int row;

    while (tempQueue.isNotEmpty) {
      int currentVertex = tempQueue.first;
      tempQueue.removeFirst();
      visitedNodes.add(currentVertex);
      final rowCol = calculateRowCol(currentVertex, boardRow);
      row = rowCol[0];
      if (row == targetRow) {
        return true;
      }

      for (int ver in validMoves[currentVertex]!) {
        if (!visitedNodes.contains(ver)) {
          tempQueue.add(ver);
        }
      }
    }
    return false;
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
    setState(() {
      // Reset Game Logic
      validMoves = createInitialValidMoves();
      myNumOfWalls = 10;
      oppNumOfWalls = 10;
      isMyTurn = true;
      wallPos = {};

      // Assuming you have variables for initial positions
      // Make sure these variables (myInitRow, etc.) are accessible here
      myPawn.currRow = myInitRow;
      myPawn.currCol = initCol;
      oppPawn.currRow = oppInitRow;
      oppPawn.currCol = initCol;
    });
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
                resetGame();
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

  void checkIfSelected(int row, int col) {
    int index = row * boardRow + col;
    setState(() {
      if (row == myPawn.currRow && col == myPawn.currCol && isMyTurn) {
        selectedRow = row;
        selectedCol = col;
      } else if (row == oppPawn.currRow &&
          col == oppPawn.currCol &&
          !isMyTurn) {
        selectedRow = row;
        selectedCol = col;
      }

      if ((validMoves[selectedRow * boardRow + selectedCol] == null
              ? false
              : validMoves[selectedRow * boardRow + selectedCol]!.contains(
                      index,
                    ) &&
                    myPawn.currRow == selectedRow &&
                    myPawn.currCol == selectedCol) &&
          isMyTurn) {
        isMyTurn = false;
        myPawn.currRow = row;
        myPawn.currCol = col;
        selectedRow = -1;
        selectedCol = -1;
      } else if ((validMoves[selectedRow * boardRow + selectedCol] == null
              ? false
              : validMoves[selectedRow * boardRow + selectedCol]!.contains(
                      index,
                    ) &&
                    oppPawn.currRow == selectedRow &&
                    oppPawn.currCol == selectedCol) &&
          !isMyTurn) {
        oppPawn.currRow = row;
        oppPawn.currCol = col;
        selectedRow = -1;
        selectedCol = -1;
        isMyTurn = true;
      }

      if (myPawn.currRow == oppInitRow) {
        _showDialog('You');
      } else if (oppPawn.currRow == myInitRow) {
        _showDialog('Opponent');
      }
    });
  }

  void addingWallEffect(
    int firstWall,
    int secondWall,
    int middleWall,
    int offset,
  ) {
    validMoves[firstWall - offset]!.remove(firstWall + offset);
    validMoves[firstWall + offset]!.remove(firstWall - offset);

    validMoves[secondWall - offset]!.remove(secondWall + offset);
    validMoves[secondWall + offset]!.remove(secondWall - offset);

    if (!bfs((myPawn.currRow) * boardRow + myPawn.currCol, oppInitRow)
    || !bfs((oppPawn.currRow) * boardRow + oppPawn.currCol, myInitRow)) {
      validMoves[firstWall - offset]!.add(firstWall + offset);
      validMoves[firstWall + offset]!.add(firstWall - offset);

      validMoves[secondWall - offset]!.add(secondWall + offset);
      validMoves[secondWall + offset]!.add(secondWall - offset);
      prevSelectedWall = -1;
      _showMoveNotAllowedMessage();
      return;
    }
    wallPos[firstWall] = isMyTurn ? myWallColor : oppWallColor;
    wallPos[secondWall] = isMyTurn ? myWallColor : oppWallColor;
    wallPos[middleWall] = isMyTurn ? myWallColor : oppWallColor;

    if (isMyTurn) {
      myNumOfWalls--;
    } else {
      oppNumOfWalls--;
    }

    isMyTurn = !isMyTurn;
    selectedRow = -1;
    selectedCol = -1;
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

  void addWallsToList(int firstWall, int secondWall, bool isRow) {
    int minWall = min(firstWall, secondWall);
    int middleWall = isRow ? (minWall + 1) : (minWall + boardRow);
    int middleWallRow = 0;
    int middleWallCol = 0;
    [middleWallRow, middleWallCol] = calculateRowCol(middleWall, boardRow);

    if (!(middleWallRow % 2 == 1 && middleWallCol % 2 == 1)) {
      return;
    }

    setState(() {
      if ((isMyTurn && myNumOfWalls > 0) || (!isMyTurn && oppNumOfWalls > 0)) {
        if (isRow && (!wallPos.containsKey(middleWall))) {
          addingWallEffect(firstWall, secondWall, middleWall, boardRow);
        } else if (!wallPos.containsKey(middleWall)) {
          addingWallEffect(firstWall, secondWall, middleWall, 1);
        }
      }
    });
  }

  void checkIfWallIsSelected(int row, int col) {
    int currentWallIndex = row * boardRow + col;
    //check if it is not a connection between a wall (1,1)
    if ((row % 2 != col % 2)) {
      if (prevSelectedWall == -1) {
        setState(() {
          prevSelectedWall = row * boardRow + col;
        });
      } else {
        //consectuive in col
        if ((prevSelectedWall - currentWallIndex).abs() == 2) {
          addWallsToList(prevSelectedWall, currentWallIndex, true);
        } else if ((prevSelectedWall - currentWallIndex).abs() == 34) {
          addWallsToList(prevSelectedWall, currentWallIndex, false);
        }

        setState(() {
          prevSelectedWall = -1;
        });
      }
    }
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
                  [row, col] = calculateRowCol(index, boardRow);
                  bool isSelected =
                      (selectedRow == row) && (selectedCol == col);
                  bool isValidMove = false;
                  if (row % 2 == 1 || col % 2 == 1) {
                    return Wall(
                      isWallSelected: wallPos.containsKey(index),
                      onTapFunc: () => checkIfWallIsSelected(row, col),
                      wallColortxt: wallPos[index],
                    );
                  } else {
                    if (row == myPawn.currRow && col == myPawn.currCol) {
                      return Square(
                        piece: myPawn,
                        isSelected: isSelected,
                        isValidMove: isValidMove,
                        onTapFunc: () => checkIfSelected(row, col),
                      );
                    } else if (row == oppPawn.currRow &&
                        col == oppPawn.currCol) {
                      return Square(
                        piece: oppPawn,
                        isSelected: isSelected,
                        isValidMove: isValidMove,
                        onTapFunc: () => checkIfSelected(row, col),
                      );
                    } else {
                      isValidMove =
                          validMoves[selectedRow * boardRow + selectedCol] ==
                              null
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
                  }
                },
                staggeredTileBuilder: (int index) {
                  // 1. Calculate which row and column this index belongs to
                  // (This assumes you know the total columns is 17)
                  int row = 0;
                  int col = 0;
                  [row, col] = calculateRowCol(index, boardRow);

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
            myNumOfWalls: myNumOfWalls,
            oppNumOfWalls: oppNumOfWalls,
            isMyTurn: isMyTurn,
          ),
        ],
      ),
    );
  }
}
