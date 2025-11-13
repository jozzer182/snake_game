import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_settings.dart';

/// Service for persisting game data using shared_preferences
/// Handles high scores, recent scores, and game settings
/// Works across all platforms: Android, iOS, Web, Windows
class PreferencesService {
  static const String _keyHighScore = 'snake_high_score';
  static const String _keySettings = 'snake_settings';
  static const String _keyRecentScores = 'snake_recent_scores';

  late final SharedPreferences _prefs;

  /// Initialize the service by loading shared_preferences
  /// Must be called before using any other methods
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ============= High Score =============

  /// Get the highest score ever achieved
  /// Returns 0 if no high score has been saved
  int getHighScore() {
    return _prefs.getInt(_keyHighScore) ?? 0;
  }

  /// Save a new high score
  /// Only saves if the new score is higher than the current high score
  /// Returns true if a new high score was set
  Future<bool> saveHighScore(int score) async {
    final currentHigh = getHighScore();
    if (score > currentHigh) {
      await _prefs.setInt(_keyHighScore, score);
      return true;
    }
    return false;
  }

  /// Update high score if the given score is higher
  /// Also adds the score to recent scores
  Future<void> updateHighScoreIfNeeded(int score) async {
    await saveHighScore(score);
    await addRecentScore(score);
  }

  // ============= Recent Scores =============

  /// Get the list of recent scores (up to 5)
  /// Returns an empty list if no scores have been saved
  List<int> getRecentScores() {
    try {
      final List<String>? scoresList = _prefs.getStringList(_keyRecentScores);
      if (scoresList == null) {
        return [];
      }
      return scoresList.map((s) => int.parse(s)).toList();
    } catch (e) {
      // If there's a type mismatch, clear the corrupted data and return empty
      _prefs.remove(_keyRecentScores);
      return [];
    }
  }

  /// Add a score to the recent scores list
  /// Keeps only the last 5 scores
  Future<void> addRecentScore(int score) async {
    final recentScores = getRecentScores();
    recentScores.insert(0, score); // Add to beginning
    
    // Keep only the last 5 scores
    if (recentScores.length > 5) {
      recentScores.removeRange(5, recentScores.length);
    }
    
    await _prefs.setStringList(
      _keyRecentScores,
      recentScores.map((s) => s.toString()).toList(),
    );
  }

  // ============= Settings =============

  /// Get saved game settings
  /// Returns default settings if none have been saved
  GameSettings getSettings() {
    final String? settingsJson = _prefs.getString(_keySettings);
    if (settingsJson == null) {
      return GameSettings.defaults();
    }
    
    try {
      return GameSettings.fromJsonString(settingsJson);
    } catch (e) {
      // If there's an error parsing, return defaults
      return GameSettings.defaults();
    }
  }

  /// Save game settings
  Future<void> saveSettings(GameSettings settings) async {
    await _prefs.setString(_keySettings, settings.toJsonString());
  }

  // ============= Clear Data =============

  /// Clear all saved data (useful for testing or reset)
  Future<void> clearAll() async {
    await _prefs.remove(_keyHighScore);
    await _prefs.remove(_keySettings);
    await _prefs.remove(_keyRecentScores);
  }
}
