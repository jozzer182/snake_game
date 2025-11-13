import 'dart:ui';

/// Represents a position on the game board grid
class GridPosition {
  final int row;
  final int col;

  const GridPosition(this.row, this.col);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GridPosition &&
          runtimeType == other.runtimeType &&
          row == other.row &&
          col == other.col;

  @override
  int get hashCode => row.hashCode ^ col.hashCode;

  @override
  String toString() => 'GridPosition($row, $col)';
}

/// Direction the snake is moving
enum Direction {
  up,
  down,
  left,
  right;

  /// Check if this direction is opposite to another
  bool isOpposite(Direction other) {
    return (this == Direction.up && other == Direction.down) ||
        (this == Direction.down && other == Direction.up) ||
        (this == Direction.left && other == Direction.right) ||
        (this == Direction.right && other == Direction.left);
  }
}

/// Manages the game board and cell calculations
class SnakeBoard {
  /// Number of rows in the grid
  final int rows;

  /// Number of columns in the grid
  final int cols;

  /// Physical size of the board in pixels (width and height are equal)
  final double boardSize;

  /// Size of each cell in pixels
  late final double cellSize;

  SnakeBoard({
    required this.rows,
    required this.cols,
    required this.boardSize,
  }) {
    cellSize = boardSize / rows;
  }

  /// Convert grid position to pixel offset (top-left corner of cell)
  Offset gridToPixel(GridPosition pos) {
    return Offset(
      pos.col * cellSize,
      pos.row * cellSize,
    );
  }

  /// Check if a position is within the board bounds
  bool isInBounds(GridPosition pos) {
    return pos.row >= 0 && pos.row < rows && pos.col >= 0 && pos.col < cols;
  }

  /// Get a random position on the board
  GridPosition getRandomPosition() {
    final row = (DateTime.now().microsecondsSinceEpoch % rows);
    final col = (DateTime.now().millisecondsSinceEpoch % cols);
    return GridPosition(row, col);
  }
}
