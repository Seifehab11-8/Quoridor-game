import 'package:flutter/material.dart';

/// Displays remaining walls for each side and whose turn it is.
/// 
/// Shows a colored indicator for the active player and wall counts
/// for both human and opponent.
class ScoreboardWalls extends StatelessWidget {
  /// Number of walls remaining for the human player.
  final int myNumOfWalls;
  
  /// Number of walls remaining for the opponent.
  final int oppNumOfWalls;
  
  /// Whether it's currently the human player's turn.
  final bool isMyTurn;

  /// Creates a scoreboard widget with the given game state.
  const ScoreboardWalls({
    super.key,
    required this.myNumOfWalls,
    required this.oppNumOfWalls,
    required this.isMyTurn
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withAlpha((0.05 * 255).round()),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.shield_outlined, size: 40),
                    const SizedBox(width: 8),
                    Text(
                      'You - $myNumOfWalls walls',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.shield, size: 40),
                    const SizedBox(width: 8),
                    Text(
                      'Opponent - $oppNumOfWalls walls',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isMyTurn ? Colors.red[100] : Colors.blue[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                isMyTurn ? 'Your Turn' : 'Opponent Turn',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 30,
                      letterSpacing: 0.5,
                    ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
