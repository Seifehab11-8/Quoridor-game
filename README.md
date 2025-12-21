# Quoridor Game

A Flutter implementation of the classic two-player board game Quoridor, featuring both human vs human and human vs computer modes with an intelligent AI opponent.

![Game Screenshot](working_game_readme_photos/inital%20game%20screen.png)

## 📺 Demo Video

Watch the game in action: [Quoridor Game Demo](https://drive.google.com/file/d/1D5XlgzXLZ_jiUOJYFHFJF8QRc-KPJdm9/view?usp=sharing)

---

## 🎮 About Quoridor

Quoridor is a strategic board game where two players race to reach the opposite side of a 9×9 board while strategically placing walls to block their opponent's path. Each player starts with 10 walls and must balance between advancing their pawn and hindering their opponent.

### Objective
- **White player** (bottom) must reach the top row (row 0)
- **Black player** (top) must reach the bottom row (row 16)
- First player to reach their goal row wins!

---

## ✨ Features

- **Two Game Modes**: Play against another human or challenge the AI
- **Smart AI Opponent**: Computer player uses minimax with alpha-beta pruning and a weighted heuristic combining:
  - Positional advantage
  - Shortest path distance to goal
  - Opponent blocking strategy
- **Special Movement Rules**: Jump over or move diagonally around an adjacent opponent
- **Wall Validation**: Automatic path checking ensures both players always have a valid route to their goal
- **Clean UI**: Intuitive board visualization with color-coded walls and turn indicators
- **Cross-Platform**: Runs on iOS, Android, Web, macOS, Linux, and Windows

---

## 📸 Screenshots

### Start Screen - Select Game Mode
![Select Game Mode](working_game_readme_photos/selection%20of%20other%20player%20type.png)

### Game in Progress
![Orange Highlight Guide](working_game_readme_photos/orange%20high%20light%20on%20board%20guiding%20the%20player%20to%20where%20to%20place%20pawn.png)
*Orange highlights show valid moves for the selected pawn*

### Wall Placement
![Blue Opponent Walls](working_game_readme_photos/opponent%20wall%20colored%20in%20blue.png)
*Your walls are red, opponent's walls are blue*

### Advanced Game State
![Game with Multiple Moves](working_game_readme_photos/game%20after%20multiple%20moves%20with%20the%20ai.png)
*Strategic wall placement creates complex paths*

### Victory!
![Winning Screen](working_game_readme_photos/winning%20screen.png)
*Victory dialog with restart option*

---

## 🚀 Getting Started

### Prerequisites
- **Flutter SDK** (3.0 or higher) - [Install Flutter](https://docs.flutter.dev/get-started/install)
- **Dart SDK** (included with Flutter)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd quoridor_game
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

   Or select a specific platform:
   ```bash
   flutter run -d chrome        # Web
   flutter run -d macos         # macOS
   flutter run -d windows       # Windows
   flutter run -d linux         # Linux
   ```

### Supported Platforms
✅ iOS | ✅ Android | ✅ Web | ✅ macOS | ✅ Linux | ✅ Windows

---

## 🎯 How to Play

### Controls

#### Moving Your Pawn
1. **Tap your pawn** to select it (highlighted in orange)
2. **Tap an adjacent square** to move
   - Valid moves are highlighted in orange
   - You can move up, down, left, or right (one square at a time)
   - Cannot move through walls or onto occupied squares

#### Placing Walls
1. **Tap two adjacent wall segments** to place a 2-unit wall
   - First tap selects the first segment
   - Second tap places the wall if valid
2. **Wall colors**:
   - Your walls: **Red**
   - Opponent's walls: **Blue**
3. **Wall rules**:
   - Each player has 10 walls to place throughout the game
   - Walls block movement between squares
   - Cannot place walls that completely block a player's path to their goal

### Special Moves

When your pawn faces the opponent directly (same column, 2 rows apart):

- **Jump Over**: If the space behind the opponent is free, you can jump over them
- **Diagonal Move**: If blocked, you can move diagonally to either side of the opponent

### Winning the Game

- Be the first to reach the opposite side of the board
- White wins by reaching row 0 (top)
- Black wins by reaching row 16 (bottom)

---

## 🏗️ Project Structure

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

---

## 🤖 Technical Highlights

### AI Implementation
- **Algorithm**: Minimax with alpha-beta pruning
- **Search Depth**: Configurable (default: depth 2)
- **Heuristic Function**: Weighted combination of:
  - Position difference (0.60 weight)
  - Player's shortest path to goal (14.45 weight, minimized)
  - Opponent's shortest path to goal (6.52 weight, maximized)

### Board Representation
- **Grid**: 17×17 internal representation (9×9 playable squares with wall slots)
- **Graph Structure**: Adjacency list for valid pawn movements
- **Path Validation**: BFS algorithm ensures walls don't completely block paths

### Movement Rules
- Orthogonal movement (up, down, left, right)
- Dynamic graph updates when walls are placed
- Special case handling for jump and diagonal moves

---

## 📚 Documentation

- **API Documentation**: Run `dart doc` to generate comprehensive API docs
- **Source Code**: Fully commented with inline documentation
- **PDF Documentation**: See `Quoridor_Complete_Documentation.pdf` for detailed technical documentation

---

## 🛠️ Development

### Generate Documentation
```bash
# Generate Dart API documentation
dart doc

# View generated docs
open doc/api/index.html
```

### Run Tests
```bash
flutter test
```

### Build for Production

**Android**:
```bash
flutter build apk
```

**iOS**:
```bash
flutter build ios
```

**Web**:
```bash
flutter build web
```

**Desktop** (macOS/Windows/Linux):
```bash
flutter build macos
flutter build windows
flutter build linux
```

---

## 🎓 Game Strategy Tips

1. **Balance offense and defense**: Don't use all your walls too early
2. **Block smartly**: Place walls to maximize your opponent's path length
3. **Plan ahead**: Consider both immediate moves and long-term positioning
4. **Control the center**: Central positions offer more movement options
5. **Watch for jumps**: Exploit diagonal opportunities when facing your opponent

---

## 📝 License

This project is available for educational and personal use.

---

## 🙏 Acknowledgments

- Classic Quoridor board game by Mirko Marchesi
- Flutter framework by Google
- Dart programming language

---

## 📧 Contact

For questions, suggestions, or issues, please open an issue on GitHub.

---

**Enjoy playing Quoridor! May the best strategist win! 🏆**
