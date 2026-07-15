import 'dart:math';
import 'package:flask/features/domain/constants/game_colors.dart';
import 'package:flask/features/domain/constants/game_config.dart';
import '../entities/color_entity.dart';
import '../entities/flask_entity.dart';
import '../entities/puzzle_entity.dart';

class LevelGenerator {
  static PuzzleEntity generate({required int difficulty}) {
    final random = Random();

    final maxColors = min(GameConfig.maxColors, GameColors.palette.length);

    final colorCount = (3 + (difficulty - 1) ~/ 3).clamp(3, maxColors);

    final maxExtraFlasks = max(
      0,
      GameConfig.maxTotalFlasks - GameConfig.emptyFlasks - maxColors,
    );

    final extraFlasks = (difficulty ~/ 3).clamp(0, maxExtraFlasks);
    final filledFlaskCount = colorCount + extraFlasks;
    final colors = GameColors.palette.take(colorCount).toList();
    final baseQuads = filledFlaskCount ~/ colorCount;
    final remainderQuads = filledFlaskCount % colorCount;
    final allLayers = <ColorEntity>[];

    for (int i = 0; i < colorCount; i++) {
      final quads = baseQuads + (i < remainderQuads ? 1 : 0);

      for (int q = 0; q < quads; q++) {
        for (int layer = 0; layer < GameConfig.flaskCapacity; layer++) {
          allLayers.add(ColorEntity(colors[i]));
        }
      }
    }

    allLayers.shuffle(random);

    final flasks = <FlaskEntity>[];

    for (int i = 0; i < filledFlaskCount; i++) {
      final start = i * GameConfig.flaskCapacity;

      flasks.add(
        FlaskEntity(
          id: i,
          capacity: GameConfig.flaskCapacity,
          layers: allLayers.sublist(start, start + GameConfig.flaskCapacity),
        ),
      );
    }

    for (int i = 0; i < GameConfig.emptyFlasks; i++) {
      flasks.add(
        FlaskEntity.empty(
          id: filledFlaskCount + i,
          capacity: GameConfig.flaskCapacity,
        ),
      );
    }

    return PuzzleEntity.create(flasks: flasks);
  }
}
