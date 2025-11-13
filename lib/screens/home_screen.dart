import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Home/Main menu screen
/// Entry point of the app with navigation to Play, Settings, and Scores
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primaryContainer,
              Theme.of(context).colorScheme.secondaryContainer,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Title with snake emoji
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.videogame_asset,
                                size: 60,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 16),
                              Text(
                                'Fidi',
                                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Snake Game',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                                ),
                          ),
                          const SizedBox(height: 60),

                          // Play button
                          SizedBox(
                            width: 250,
                            child: FilledButton.icon(
                              onPressed: () {
                                Navigator.of(context).pushNamed('/game');
                              },
                              icon: const Icon(Icons.play_arrow, size: 28),
                              label: const Text('Play'),
                              style: FilledButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                textStyle: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Settings button
                          SizedBox(
                            width: 250,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.of(context).pushNamed('/settings');
                              },
                              icon: const Icon(Icons.settings),
                              label: const Text('Settings'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                textStyle: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Scores button
                          SizedBox(
                            width: 250,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.of(context).pushNamed('/scores');
                              },
                              icon: const Icon(Icons.leaderboard),
                              label: const Text('Scores'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                textStyle: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              
              // Footer
              _buildFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Build the footer with copyright and developer information
  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Developed with love line
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Developed with ',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.7),
                    ),
              ),
              Icon(
                Icons.favorite,
                size: 16,
                color: Colors.red.shade400,
              ),
              Text(
                ' by ',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.7),
                    ),
              ),
              GestureDetector(
                onTap: () => _launchWebsite(),
                child: Text(
                  'Zarabanda Dev',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        decorationColor: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          
          // Copyright line
          Text(
            '© ${DateTime.now().year} Zarabanda Dev. All rights reserved.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withOpacity(0.5),
                ),
          ),
        ],
      ),
    );
  }

  /// Launch the Zarabanda Dev website
  Future<void> _launchWebsite() async {
    final Uri url = Uri.parse('https://zarabanda-dev.web.app/');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      // Handle error silently or show a toast
      debugPrint('Could not launch website: $e');
    }
  }
}
