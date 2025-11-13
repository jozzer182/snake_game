import 'package:flutter/material.dart';
import '../services/preferences_service.dart';

/// Scores screen displaying high score and recent scores
/// Shows local leaderboard with last 5 scores
class ScoresScreen extends StatelessWidget {
  final PreferencesService preferencesService;

  const ScoresScreen({
    super.key,
    required this.preferencesService,
  });

  @override
  Widget build(BuildContext context) {
    final highScore = preferencesService.getHighScore();
    final recentScores = preferencesService.getRecentScores();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scores'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // High Score Card
          Card(
            elevation: 4,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primaryContainer,
                    Theme.of(context).colorScheme.secondaryContainer,
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Icon(
                    Icons.emoji_events,
                    size: 60,
                    color: Colors.amber,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'High Score',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$highScore',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Recent Scores Section
          Text(
            'Recent Scores',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),

          if (recentScores.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(
                      Icons.sports_esports,
                      size: 60,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No games played yet',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Play a game to see your scores here!',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.6),
                          ),
                    ),
                  ],
                ),
              ),
            )
          else
            ...recentScores.asMap().entries.map((entry) {
              final index = entry.key;
              final score = entry.value;
              final isHighScore = score == highScore && highScore > 0;

              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isHighScore
                        ? Colors.amber
                        : Theme.of(context).colorScheme.primaryContainer,
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isHighScore
                            ? Colors.black
                            : Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  title: Row(
                    children: [
                      Text(
                        '$score',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      if (isHighScore) ...[
                        const SizedBox(width: 8),
                        Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 20,
                        ),
                      ],
                    ],
                  ),
                  subtitle: isHighScore
                      ? const Text('Personal Best')
                      : null,
                  trailing: isHighScore
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'BEST',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.amber,
                            ),
                          ),
                        )
                      : null,
                ),
              );
            }).toList(),
        ],
      ),
    );
  }
}
