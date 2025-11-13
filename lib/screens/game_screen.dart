import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/game.dart';
import '../game/snake_game.dart';
import '../game/snake_board.dart';
import '../models/game_settings.dart';
import '../services/preferences_service.dart';
import '../widgets/overlays/score_bar.dart';
import '../widgets/overlays/pause_overlay.dart';
import '../widgets/overlays/game_over_overlay.dart';

/// Main game screen that hosts the Flame game
/// Supports keyboard controls (desktop/web) and touch controls (mobile)
/// Adapts to portrait and landscape orientations
class GameScreen extends StatefulWidget {
  final PreferencesService preferencesService;

  const GameScreen({
    super.key,
    required this.preferencesService,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late SnakeGame _game;
  late GameSettings _settings;
  int _currentScore = 0;
  GameState _gameState = GameState.playing;
  int _currentHighScore = 0;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _settings = widget.preferencesService.getSettings();
    _currentHighScore = widget.preferencesService.getHighScore();
    _initializeGame();
    
    // Request focus after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  void _initializeGame() {
    _game = SnakeGame(
      settings: _settings,
      preferencesService: widget.preferencesService,
      onScoreChanged: (score) {
        setState(() {
          _currentScore = score;
        });
      },
      onGameStateChanged: (state) {
        setState(() {
          _gameState = state;
        });
      },
      onGameOver: (currentScore, highScore) {
        setState(() {
          _currentScore = currentScore;
          _currentHighScore = highScore;
          _gameState = GameState.gameOver;
        });
      },
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _handlePause() {
    _game.pause();
  }

  void _handleResume() {
    _game.resume();
    _focusNode.requestFocus();
  }

  void _handleBackToMenu() {
    Navigator.of(context).pop();
  }

  void _handlePlayAgain() {
    _game.reset();
    setState(() {
      _currentScore = 0;
      _gameState = GameState.playing;
    });
    _focusNode.requestFocus();
  }

  void _handleSwipe(DragEndDetails details) {
    final velocity = details.velocity.pixelsPerSecond;
    final dx = velocity.dx.abs();
    final dy = velocity.dy.abs();

    // Determine if swipe is more horizontal or vertical
    if (dx > dy) {
      // Horizontal swipe
      if (velocity.dx > 0) {
        _game.handleSwipe(Direction.right);
      } else {
        _game.handleSwipe(Direction.left);
      }
    } else {
      // Vertical swipe
      if (velocity.dy > 0) {
        _game.handleSwipe(Direction.down);
      } else {
        _game.handleSwipe(Direction.up);
      }
    }
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      _game.handleKeyEvent(event.logicalKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: KeyboardListener(
          focusNode: _focusNode,
          onKeyEvent: _handleKeyEvent,
          autofocus: true,
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Determine if we're in landscape or portrait
              final isLandscape = constraints.maxWidth > constraints.maxHeight;
              final isMobile = _isMobile();
              
              // In landscape mode on mobile, don't show control buttons at all
              // Users can use swipe gestures instead
              return _buildGameLayout(
                context: context,
                constraints: constraints,
                isLandscape: isLandscape,
                showButtons: isMobile && !isLandscape,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildGameLayout({
    required BuildContext context,
    required BoxConstraints constraints,
    required bool isLandscape,
    required bool showButtons,
  }) {
    return Column(
      children: [
        _buildScoreBar(),
        Expanded(
          child: _buildGameArea(constraints),
        ),
        // Only show control buttons in portrait mode on mobile
        // In landscape, rely on swipe gestures only
        if (showButtons && _gameState == GameState.playing)
          Padding(
            padding: const EdgeInsets.only(bottom: 8, top: 4),
            child: _buildTouchControls(),
          ),
        // Show swipe hint in landscape mode on mobile
        if (_isMobile() && isLandscape && _gameState == GameState.playing)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Swipe to control',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildScoreBar() {
    return ScoreBar(
      score: _currentScore,
      speedLevel: _settings.speed.displayName,
      onPause: _handlePause,
    );
  }

  Widget _buildGameArea(BoxConstraints constraints) {
    return Stack(
      children: [
        // Game widget with gesture detection for swipes (only when playing)
        GestureDetector(
          onPanEnd: _gameState == GameState.playing ? _handleSwipe : null,
          onTap: _gameState == GameState.playing
              ? () {
                  // Ensure focus when user clicks on game area (important for Windows)
                  _focusNode.requestFocus();
                }
              : null,
          behavior: _gameState == GameState.playing
              ? HitTestBehavior.opaque
              : HitTestBehavior.deferToChild,
          child: Center(
            child: AspectRatio(
              aspectRatio: 1, // Keep game board square
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                    width: 2,
                  ),
                ),
                child: GameWidget(game: _game),
              ),
            ),
          ),
        ),

        // Pause overlay
        if (_gameState == GameState.paused)
          PauseOverlay(
            onResume: _handleResume,
            onBackToMenu: _handleBackToMenu,
          ),

        // Game over overlay
        if (_gameState == GameState.gameOver)
          GameOverOverlay(
            currentScore: _currentScore,
            highScore: _currentHighScore,
            onPlayAgain: _handlePlayAgain,
            onBackToMenu: _handleBackToMenu,
          ),
      ],
    );
  }

  Widget _buildTouchControls() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Up button
          _buildDirectionButton(
            icon: Icons.arrow_upward,
            onPressed: () => _game.handleSwipe(Direction.up),
          ),
          const SizedBox(height: 6),
          // Left, Down, Right buttons
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildDirectionButton(
                icon: Icons.arrow_back,
                onPressed: () => _game.handleSwipe(Direction.left),
              ),
              const SizedBox(width: 6),
              _buildDirectionButton(
                icon: Icons.arrow_downward,
                onPressed: () => _game.handleSwipe(Direction.down),
              ),
              const SizedBox(width: 6),
              _buildDirectionButton(
                icon: Icons.arrow_forward,
                onPressed: () => _game.handleSwipe(Direction.right),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Hint text
          Text(
            'Swipe or use buttons',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  fontSize: 10,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildDirectionButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 56,
      height: 56,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Icon(icon, size: 28),
      ),
    );
  }

  /// Check if we're on a mobile platform (for showing touch controls)
  /// On web/desktop, we assume keyboard is available
  bool _isMobile() {
    // Check platform
    final platform = Theme.of(context).platform;
    return platform == TargetPlatform.android || platform == TargetPlatform.iOS;
  }
}
