import 'dart:math';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/game_settings.dart';
import '../services/preferences_service.dart';
import 'snake.dart';
import 'snake_board.dart';
import 'fruit.dart';

/// Game states
enum GameState {
  playing,
  paused,
  gameOver,
}

/// Main game class using Flame engine
/// Handles game loop, input, collision detection, and scoring
class SnakeGame extends FlameGame {
  /// Game settings (speed, colors, etc.)
  GameSettings settings;

  /// Preferences service for saving scores
  final PreferencesService preferencesService;

  /// Callback when score changes
  final Function(int score)? onScoreChanged;

  /// Callback when game state changes
  final Function(GameState state)? onGameStateChanged;

  /// Callback when game is over (passes current score and high score)
  final Function(int currentScore, int highScore)? onGameOver;

  /// Current game state
  GameState gameState = GameState.playing;

  /// The game board
  late SnakeBoard board;

  /// The snake
  late Snake snake;

  /// The fruit
  late Fruit fruit;

  /// Current score
  int score = 0;

  /// Timer for snake movement
  double _timeSinceLastMove = 0;

  /// Movement interval in seconds (from settings)
  late double _moveInterval;

  /// Random number generator
  final Random _random = Random();

  SnakeGame({
    required this.settings,
    required this.preferencesService,
    this.onScoreChanged,
    this.onGameStateChanged,
    this.onGameOver,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Calculate board size (the game will be rendered in a square)
    // We'll use the smaller dimension to keep it square
    final double boardSize = min(size.x, size.y);

    // Initialize board (20x20 grid)
    board = SnakeBoard(
      rows: 20,
      cols: 20,
      boardSize: boardSize,
    );

    // Create snake at center
    snake = Snake.initial(
      board: board,
      color: settings.snakeColor,
    );

    // Create initial fruit
    fruit = Fruit(
      gridPosition: _getRandomFreePosition(),
      board: board,
    );

    // Set movement interval from settings
    _moveInterval = settings.speed.intervalMs / 1000.0;

    // Add components to game
    add(snake);
    add(fruit);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Only update game logic when playing
    if (gameState != GameState.playing) {
      return;
    }

    _timeSinceLastMove += dt;

    // Move snake when enough time has passed
    if (_timeSinceLastMove >= _moveInterval) {
      _timeSinceLastMove = 0;
      _moveSnake();
    }
  }

  /// Move the snake and handle collisions
  void _moveSnake() {
    // Check if snake will eat fruit
    final nextHeadPos = _getNextHeadPosition();
    final willEatFruit = nextHeadPos == fruit.gridPosition;

    // Move snake (grow if eating fruit)
    snake.move(shouldGrow: willEatFruit);

    // Check wall collision
    if (!board.isInBounds(snake.head)) {
      _handleGameOver();
      return;
    }

    // Check self collision
    if (snake.checkSelfCollision()) {
      _handleGameOver();
      return;
    }

    // If fruit was eaten, update score and spawn new fruit
    if (willEatFruit) {
      score++;
      onScoreChanged?.call(score);
      _spawnNewFruit();
    }
  }

  /// Get the next head position (for lookahead collision detection)
  GridPosition _getNextHeadPosition() {
    final direction = snake.nextDirection ?? snake.currentDirection;
    final currentHead = snake.head;

    switch (direction) {
      case Direction.up:
        return GridPosition(currentHead.row - 1, currentHead.col);
      case Direction.down:
        return GridPosition(currentHead.row + 1, currentHead.col);
      case Direction.left:
        return GridPosition(currentHead.row, currentHead.col - 1);
      case Direction.right:
        return GridPosition(currentHead.row, currentHead.col + 1);
    }
  }

  /// Spawn a new fruit at a random free position
  void _spawnNewFruit() {
    fruit.moveTo(_getRandomFreePosition());
  }

  /// Get a random position that is not occupied by the snake
  GridPosition _getRandomFreePosition() {
    GridPosition pos;
    int attempts = 0;
    const maxAttempts = 100;

    do {
      pos = GridPosition(
        _random.nextInt(board.rows),
        _random.nextInt(board.cols),
      );
      attempts++;
    } while (snake.occupies(pos) && attempts < maxAttempts);

    return pos;
  }

  /// Handle game over
  void _handleGameOver() {
    gameState = GameState.gameOver;
    onGameStateChanged?.call(gameState);

    // Save score
    final highScore = preferencesService.getHighScore();
    preferencesService.updateHighScoreIfNeeded(score);

    // Notify game over with updated high score
    final newHighScore = max(highScore, score);
    onGameOver?.call(score, newHighScore);
  }

  /// Pause the game
  void pause() {
    if (gameState == GameState.playing) {
      gameState = GameState.paused;
      onGameStateChanged?.call(gameState);
    }
  }

  /// Resume the game
  void resume() {
    if (gameState == GameState.paused) {
      gameState = GameState.playing;
      onGameStateChanged?.call(gameState);
    }
  }

  /// Reset the game for a new round
  void reset() {
    score = 0;
    onScoreChanged?.call(score);

    // Reset snake
    snake.body = [
      GridPosition(board.rows ~/ 2, board.cols ~/ 2),
      GridPosition(board.rows ~/ 2, board.cols ~/ 2 - 1),
      GridPosition(board.rows ~/ 2, board.cols ~/ 2 - 2),
    ];
    snake.currentDirection = Direction.right;
    snake.nextDirection = null;

    // Update snake color from settings
    snake.color = settings.snakeColor;

    // Reset fruit
    fruit.moveTo(_getRandomFreePosition());

    // Reset game state
    gameState = GameState.playing;
    onGameStateChanged?.call(gameState);
    _timeSinceLastMove = 0;

    // Update movement interval from settings
    _moveInterval = settings.speed.intervalMs / 1000.0;
  }

  /// Apply new settings to the game
  void applySettings(GameSettings newSettings) {
    settings = newSettings;
    _moveInterval = settings.speed.intervalMs / 1000.0;
    snake.color = settings.snakeColor;
  }

  /// Handle keyboard input
  void handleKeyEvent(LogicalKeyboardKey key) {
    if (gameState != GameState.playing) {
      return;
    }

    // Arrow keys
    if (key == LogicalKeyboardKey.arrowUp) {
      snake.changeDirection(Direction.up);
    } else if (key == LogicalKeyboardKey.arrowDown) {
      snake.changeDirection(Direction.down);
    } else if (key == LogicalKeyboardKey.arrowLeft) {
      snake.changeDirection(Direction.left);
    } else if (key == LogicalKeyboardKey.arrowRight) {
      snake.changeDirection(Direction.right);
    }

    // WASD keys
    else if (key == LogicalKeyboardKey.keyW) {
      snake.changeDirection(Direction.up);
    } else if (key == LogicalKeyboardKey.keyS) {
      snake.changeDirection(Direction.down);
    } else if (key == LogicalKeyboardKey.keyA) {
      snake.changeDirection(Direction.left);
    } else if (key == LogicalKeyboardKey.keyD) {
      snake.changeDirection(Direction.right);
    }
  }

  @override
  void render(Canvas canvas) {
    // Draw background
    final backgroundPaint = Paint()..color = settings.backgroundColor;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, board.boardSize, board.boardSize),
      backgroundPaint,
    );

    // Draw grid lines (subtle)
    final gridPaint = Paint()
      ..color = settings.backgroundColor.computeLuminance() > 0.5
          ? Colors.black.withOpacity(0.1)
          : Colors.white.withOpacity(0.1)
      ..strokeWidth = 1;

    for (int i = 0; i <= board.rows; i++) {
      final y = i * board.cellSize;
      canvas.drawLine(
        Offset(0, y),
        Offset(board.boardSize, y),
        gridPaint,
      );
    }

    for (int i = 0; i <= board.cols; i++) {
      final x = i * board.cellSize;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, board.boardSize),
        gridPaint,
      );
    }

    super.render(canvas);
  }

  /// Handle swipe gestures (for mobile touch controls)
  void handleSwipe(Direction direction) {
    if (gameState == GameState.playing) {
      snake.changeDirection(direction);
    }
  }
}
