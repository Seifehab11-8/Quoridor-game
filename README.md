# Quoridor Game

A Flutter implementation of the classic two-player board game Quoridor, featuring both human vs human and human vs computer modes.

## About Quoridor

Quoridor is a strategic board game where two players race to reach the opposite side of a 9×9 board while strategically placing walls to block their opponent's path. Each player starts with 10 walls and must balance between advancing their pawn and hindering their opponent.

## Features

- **Two Game Modes**: Play against another human or challenge the AI
- **Smart AI Opponent**: Computer player uses minimax with alpha-beta pruning and a weighted heuristic combining positional advantage, shortest path distance, and opponent blocking
- **Special Movement Rules**: Jump over or move diagonally around an adjacent opponent
- **Wall Validation**: Automatic path checking ensures both players always have a valid route to their goal
- **Clean UI**: Intuitive board visualization with color-coded walls and turn indicators

## How to Play

### Objective
- **White player** (bottom) must reach the top row (row 0)
- **Black player** (top) must reach the bottom row (row 16)

### Controls
1. **Move Your Pawn**: Tap your pawn to select it (highlighted in orange), then tap an adjacent square to move
2. **Place a Wall**: Tap two adjacent wall segments to place a 2-unit wall blocking movement
   - Walls are displayed in red (your walls) or blue (opponent's walls)
   - Each player has 10 walls to place throughout the game
   - Walls cannot completely block a player's path to their goal

### Special Moves
When your pawn faces the opponent directly:
- If the space behind them is free, you can **jump over** them
- If blocked, you can move **diagonally** to either side of the opponent

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── game_logic/                  # Core game mechanics
│   ├── player.dart              # Base player class with wall & movement logic
│   ├── human_player.dart        # Handles human input (tap validation)
│   └── computer_player.dart     # AI with minimax search & heuristics
├── helper/                      # Utilities and data structures
│   ├── game_state.dart          # Board snapshot for minimax exploration
│   ├── helper_func.dart         # BFS pathfinding & graph utilities
│   └── move_data.dart           # Move result enum
└── views/                       # UI components
    ├── screens/
    │   ├── start_screen.dart    # Game mode selection
    │   └── game_screen.dart     # Main game container
    └── pages/
        ├── board.dart           # Board state & rendering orchestration
        ├── square.dart          # Playable square widget
        ├── wall.dart            # Wall segment widget
        ├── pawn.dart            # Pawn data model
        └── scoreboard_walls.dart # Turn & wall count display
```

## Getting Started

### Prerequisites
- Flutter SDK (3.0 or higher recommended)
- Dart SDK

### Installation
```bash
# Clone the repository
git clone <repository-url>
cd quoridor_game

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Platform Support
This project supports iOS, Android, Web, macOS, Linux, and Windows.

## Technical Highlights

- **Minimax AI**: The computer player evaluates moves using a depth-limited minimax algorithm with alpha-beta pruning for efficient search
- **Graph-based Movement**: The board is represented as an adjacency list where walls dynamically remove edges
- **BFS Pathfinding**: Validates that wall placements never completely block a player's route to victory
- **Immutable Game States**: Each AI simulation clones the board state to avoid mutating the live game

## Resources

For help getting started with Flutter development:
- [Flutter Documentation](https://docs.flutter.dev/)
- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)
