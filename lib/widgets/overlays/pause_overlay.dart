import 'package:flutter/material.dart';

/// Overlay shown when the game is paused
/// Provides Resume and Back to Menu options
class PauseOverlay extends StatelessWidget {
  final VoidCallback onResume;
  final VoidCallback onBackToMenu;

  const PauseOverlay({
    super.key,
    required this.onResume,
    required this.onBackToMenu,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Card(
          margin: const EdgeInsets.all(32),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Pause icon
                Icon(
                  Icons.pause_circle_outline,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 24),

                // Title
                Text(
                  'Paused',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 32),

                // Resume button
                SizedBox(
                  width: 200,
                  child: FilledButton.icon(
                    onPressed: onResume,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Resume'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Back to menu button
                SizedBox(
                  width: 200,
                  child: OutlinedButton.icon(
                    onPressed: onBackToMenu,
                    icon: const Icon(Icons.home),
                    label: const Text('Back to Menu'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
