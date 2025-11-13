import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'snake_board.dart';

/// Represents the fruit that the snake eats
/// Renders as a red circle on the game board
class Fruit extends PositionComponent {
  /// Grid position of the fruit
  GridPosition gridPosition;

  /// The game board reference for cell size calculations
  final SnakeBoard board;

  /// Color of the fruit
  final Color color;

  Fruit({
    required this.gridPosition,
    required this.board,
    this.color = const Color(0xFFE91E63), // Pink/Red
  }) : super(size: Vector2.all(board.cellSize));

  @override
  void onMount() {
    super.onMount();
    _updatePosition();
  }

  /// Update the visual position based on grid position
  void _updatePosition() {
    final pixelPos = board.gridToPixel(gridPosition);
    position = Vector2(pixelPos.dx, pixelPos.dy);
  }

  /// Move the fruit to a new grid position
  void moveTo(GridPosition newPosition) {
    gridPosition = newPosition;
    _updatePosition();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Draw fruit as a circle
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final center = Offset(size.x / 2, size.y / 2);
    final radius = size.x * 0.4; // 40% of cell size

    canvas.drawCircle(center, radius, paint);
  }
}
