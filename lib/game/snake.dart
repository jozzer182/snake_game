import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'snake_board.dart';

/// Represents the snake in the game
/// The snake is a list of grid positions, with the head at index 0
class Snake extends Component {
  /// List of grid positions making up the snake's body
  /// Index 0 is the head, last index is the tail
  List<GridPosition> body;

  /// Current direction of movement
  Direction currentDirection;

  /// Next direction (queued input to prevent instant reversals)
  Direction? nextDirection;

  /// The game board reference for cell size calculations
  final SnakeBoard board;

  /// Color of the snake
  Color color;

  Snake({
    required this.body,
    required this.currentDirection,
    required this.board,
    required this.color,
  });

  /// Factory constructor to create a snake at the center of the board
  factory Snake.initial({
    required SnakeBoard board,
    required Color color,
  }) {
    final centerRow = board.rows ~/ 2;
    final centerCol = board.cols ~/ 2;

    return Snake(
      body: [
        GridPosition(centerRow, centerCol), // Head
        GridPosition(centerRow, centerCol - 1), // Body
        GridPosition(centerRow, centerCol - 2), // Tail
      ],
      currentDirection: Direction.right,
      board: board,
      color: color,
    );
  }

  /// Get the head position
  GridPosition get head => body.first;

  /// Get the tail position
  GridPosition get tail => body.last;

  /// Change the direction (queued for next move)
  /// Prevents instant 180-degree turns
  void changeDirection(Direction newDirection) {
    // Don't allow reversing into itself
    if (!newDirection.isOpposite(currentDirection)) {
      nextDirection = newDirection;
    }
  }

  /// Calculate the next head position based on current direction
  GridPosition _getNextHeadPosition() {
    // Use queued direction if available
    final direction = nextDirection ?? currentDirection;

    final currentHead = head;
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

  /// Move the snake forward by one cell
  /// Returns the new head position
  /// If shouldGrow is false, removes the tail (normal movement)
  /// If shouldGrow is true, keeps the tail (snake grows)
  GridPosition move({bool shouldGrow = false}) {
    // Update current direction from queued direction
    if (nextDirection != null) {
      currentDirection = nextDirection!;
      nextDirection = null;
    }

    final newHead = _getNextHeadPosition();
    body.insert(0, newHead);

    if (!shouldGrow) {
      body.removeLast();
    }

    return newHead;
  }

  /// Check if the snake collides with its own body
  bool checkSelfCollision() {
    final headPos = head;
    // Check if head position appears elsewhere in the body
    for (int i = 1; i < body.length; i++) {
      if (body[i] == headPos) {
        return true;
      }
    }
    return false;
  }

  /// Check if a position is occupied by the snake's body
  bool occupies(GridPosition pos) {
    return body.contains(pos);
  }

  /// Render the snake on the canvas
  void renderSnake(Canvas canvas) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final headPaint = Paint()
      ..color = color.withOpacity(0.9)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < body.length; i++) {
      final pos = body[i];
      final pixelPos = board.gridToPixel(pos);
      final rect = Rect.fromLTWH(
        pixelPos.dx + 1, // Small gap between cells
        pixelPos.dy + 1,
        board.cellSize - 2,
        board.cellSize - 2,
      );

      // Head is slightly different (could add eyes, etc.)
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(4)),
        i == 0 ? headPaint : paint,
      );

      // Draw eyes on the head
      if (i == 0) {
        _drawEyes(canvas, pixelPos);
      }
    }
  }

  /// Draw simple eyes on the snake's head
  void _drawEyes(Canvas canvas, Offset headPixelPos) {
    final eyePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final cellSize = board.cellSize;
    final eyeRadius = cellSize * 0.1;

    Offset leftEye;
    Offset rightEye;

    // Position eyes based on current direction
    switch (currentDirection) {
      case Direction.up:
        leftEye = Offset(headPixelPos.dx + cellSize * 0.3, headPixelPos.dy + cellSize * 0.3);
        rightEye = Offset(headPixelPos.dx + cellSize * 0.7, headPixelPos.dy + cellSize * 0.3);
        break;
      case Direction.down:
        leftEye = Offset(headPixelPos.dx + cellSize * 0.3, headPixelPos.dy + cellSize * 0.7);
        rightEye = Offset(headPixelPos.dx + cellSize * 0.7, headPixelPos.dy + cellSize * 0.7);
        break;
      case Direction.left:
        leftEye = Offset(headPixelPos.dx + cellSize * 0.3, headPixelPos.dy + cellSize * 0.3);
        rightEye = Offset(headPixelPos.dx + cellSize * 0.3, headPixelPos.dy + cellSize * 0.7);
        break;
      case Direction.right:
        leftEye = Offset(headPixelPos.dx + cellSize * 0.7, headPixelPos.dy + cellSize * 0.3);
        rightEye = Offset(headPixelPos.dx + cellSize * 0.7, headPixelPos.dy + cellSize * 0.7);
        break;
    }

    canvas.drawCircle(leftEye, eyeRadius, eyePaint);
    canvas.drawCircle(rightEye, eyeRadius, eyePaint);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    renderSnake(canvas);
  }
}
