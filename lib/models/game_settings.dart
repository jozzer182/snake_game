import 'dart:convert';
import 'package:flutter/material.dart';

/// Represents user-configurable game settings
/// Includes snake color, background color, and game speed
class GameSettings {
  /// The color of the snake
  final Color snakeColor;

  /// The background color of the game board
  final Color backgroundColor;

  /// The game speed level (slow, normal, fast, insane)
  final GameSpeed speed;

  const GameSettings({
    required this.snakeColor,
    required this.backgroundColor,
    required this.speed,
  });

  /// Default settings for first-time users
  factory GameSettings.defaults() {
    return const GameSettings(
      snakeColor: Color(0xFF4CAF50), // Green
      backgroundColor: Color(0xFF212121), // Dark gray
      speed: GameSpeed.normal,
    );
  }

  /// Create settings from JSON (loaded from shared_preferences)
  factory GameSettings.fromJson(Map<String, dynamic> json) {
    return GameSettings(
      snakeColor: Color(json['snakeColor'] as int),
      backgroundColor: Color(json['backgroundColor'] as int),
      speed: GameSpeed.values.firstWhere(
        (e) => e.name == json['speed'],
        orElse: () => GameSpeed.normal,
      ),
    );
  }

  /// Convert settings to JSON (for saving to shared_preferences)
  Map<String, dynamic> toJson() {
    return {
      'snakeColor': snakeColor.value,
      'backgroundColor': backgroundColor.value,
      'speed': speed.name,
    };
  }

  /// Create a copy of settings with optional changes
  GameSettings copyWith({
    Color? snakeColor,
    Color? backgroundColor,
    GameSpeed? speed,
  }) {
    return GameSettings(
      snakeColor: snakeColor ?? this.snakeColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      speed: speed ?? this.speed,
    );
  }

  /// Convert settings to JSON string
  String toJsonString() {
    return jsonEncode(toJson());
  }

  /// Create settings from JSON string
  factory GameSettings.fromJsonString(String jsonString) {
    return GameSettings.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
  }
}

/// Game speed levels that affect the snake movement interval
enum GameSpeed {
  slow(300), // 300ms per move
  normal(200), // 200ms per move
  fast(120), // 120ms per move
  insane(80); // 80ms per move

  /// The movement interval in milliseconds
  final int intervalMs;

  const GameSpeed(this.intervalMs);

  /// Get user-friendly display name
  String get displayName {
    switch (this) {
      case GameSpeed.slow:
        return 'Slow';
      case GameSpeed.normal:
        return 'Normal';
      case GameSpeed.fast:
        return 'Fast';
      case GameSpeed.insane:
        return 'Insane';
    }
  }
}

/// Predefined snake color themes
class SnakeColorTheme {
  static const List<Color> themes = [
    Color(0xFF4CAF50), // Green
    Color(0xFF2196F3), // Blue
    Color(0xFFFF9800), // Orange
    Color(0xFFE91E63), // Pink
  ];

  static const List<String> themeNames = [
    'Green',
    'Blue',
    'Orange',
    'Pink',
  ];
}

/// Predefined background color themes
class BackgroundColorTheme {
  static const List<Color> themes = [
    Color(0xFF212121), // Dark gray
    Color(0xFF1A237E), // Dark blue
    Color(0xFF004D40), // Dark teal
    Color(0xFFF5F5F5), // Light gray
  ];

  static const List<String> themeNames = [
    'Dark Gray',
    'Dark Blue',
    'Dark Teal',
    'Light Gray',
  ];
}
