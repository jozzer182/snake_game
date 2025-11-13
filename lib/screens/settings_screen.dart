import 'package:flutter/material.dart';
import '../models/game_settings.dart';
import '../services/preferences_service.dart';

/// Settings screen for customizing game appearance and difficulty
/// Allows selection of snake color, background color, and game speed
class SettingsScreen extends StatefulWidget {
  final PreferencesService preferencesService;

  const SettingsScreen({
    super.key,
    required this.preferencesService,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late GameSettings _settings;

  @override
  void initState() {
    super.initState();
    _settings = widget.preferencesService.getSettings();
  }

  Future<void> _saveSettings() async {
    await widget.preferencesService.saveSettings(_settings);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Settings saved!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          // Save button
          TextButton.icon(
            onPressed: () async {
              await _saveSettings();
              if (mounted) {
                Navigator.of(context).pop();
              }
            },
            icon: const Icon(Icons.check),
            label: const Text('Save'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Snake Color Section
          _buildSectionTitle('Snake Color'),
          const SizedBox(height: 12),
          _buildColorSelector(
            currentColor: _settings.snakeColor,
            colors: SnakeColorTheme.themes,
            colorNames: SnakeColorTheme.themeNames,
            onColorSelected: (color) {
              setState(() {
                _settings = _settings.copyWith(snakeColor: color);
              });
            },
          ),
          const SizedBox(height: 24),

          // Background Color Section
          _buildSectionTitle('Background Color'),
          const SizedBox(height: 12),
          _buildColorSelector(
            currentColor: _settings.backgroundColor,
            colors: BackgroundColorTheme.themes,
            colorNames: BackgroundColorTheme.themeNames,
            onColorSelected: (color) {
              setState(() {
                _settings = _settings.copyWith(backgroundColor: color);
              });
            },
          ),
          const SizedBox(height: 24),

          // Game Speed Section
          _buildSectionTitle('Game Speed'),
          const SizedBox(height: 12),
          _buildSpeedSelector(),
          const SizedBox(height: 24),

          // Preview Section
          _buildSectionTitle('Preview'),
          const SizedBox(height: 12),
          _buildPreview(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildColorSelector({
    required Color currentColor,
    required List<Color> colors,
    required List<String> colorNames,
    required Function(Color) onColorSelected,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: List.generate(colors.length, (index) {
            final color = colors[index];
            final name = colorNames[index];
            final isSelected = color.value == currentColor.value;

            return InkWell(
              onTap: () => onColorSelected(color),
              borderRadius: BorderRadius.circular(12),
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey.shade300,
                        width: isSelected ? 3 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.3),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ]
                          : null,
                    ),
                    child: isSelected
                        ? Icon(
                            Icons.check,
                            color: color.computeLuminance() > 0.5
                                ? Colors.black
                                : Colors.white,
                            size: 30,
                          )
                        : null,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    name,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildSpeedSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: GameSpeed.values.map((speed) {
            final isSelected = speed == _settings.speed;
            return RadioListTile<GameSpeed>(
              title: Text(speed.displayName),
              subtitle: Text('${speed.intervalMs}ms per move'),
              value: speed,
              groupValue: _settings.speed,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _settings = _settings.copyWith(speed: value);
                  });
                }
              },
              selected: isSelected,
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildPreview() {
    return Card(
      child: Container(
        height: 150,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How it will look:',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: _settings.backgroundColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Snake preview (3 segments)
                      ...List.generate(3, (index) {
                        return Container(
                          width: 30,
                          height: 30,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: _settings.snakeColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }),
                      const SizedBox(width: 20),
                      // Fruit preview
                      Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE91E63),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
