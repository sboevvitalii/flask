import 'dart:math';
import 'package:flask/features/domain/constants/game_colors.dart';
import '../entities/color_entity.dart';
import '../entities/flask_entity.dart';
import '../entities/puzzle_entity.dart';

class PuzzleGeneratorService {
  final Random _random;

  PuzzleGeneratorService({Random? random}) : _random = random ?? Random();

  PuzzleEntity generate({
    required int flaskCount,

    required int colorsPerFlask,
  }) {
    final colorCount = flaskCount - 2;

    if (colorCount < 2) {
      throw ArgumentError('Минимум 4 колбы');
    }
    final palette = GameColors.palette.take(colorCount).toList();

    final allLayers = <ColorEntity>[];

    for (final color in palette) {
      for (int i = 0; i < colorsPerFlask; i++) {
        allLayers.add(ColorEntity(color));
      }
    }

    allLayers.shuffle(_random);

    final flasks = <FlaskEntity>[];

    int layerIndex = 0;

    // заполненные колбы
    for (int i = 0; i < colorCount; i++) {
      flasks.add(
        FlaskEntity(
          id: i,

          capacity: colorsPerFlask,

          layers: [
            for (int j = 0; j < colorsPerFlask; j++) allLayers[layerIndex++],
          ],
        ),
      );
    }

    // пустые буферные колбы
    for (int i = colorCount; i < flaskCount; i++) {
      flasks.add(FlaskEntity.empty(id: i, capacity: colorsPerFlask));
    }

    return PuzzleEntity.create(flasks: flasks);
  }
}
