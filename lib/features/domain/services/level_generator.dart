import 'dart:math';
import 'package:flask/features/domain/constants/game_colors.dart';
import 'package:flask/features/domain/constants/game_config.dart';
import '../entities/color_entity.dart';
import '../entities/flask_entity.dart';
import '../entities/puzzle_entity.dart';

class LevelGenerator {
  static PuzzleEntity generate({required int difficulty}) {
    final random = Random();

    // количество цветов растёт со сложностью, но не больше, чем есть в палитре
    final maxColors = min(GameConfig.maxColors, GameColors.palette.length);
    final colorCount = (difficulty + 2).clamp(3, maxColors);

    // сколько ДОПОЛНИТЕЛЬНЫХ заполненных колб добавить сверх числа цветов —
    // тот же объём жидкости размазывается по большему числу колб,
    // усложняя уровень даже когда colorCount уже упёрся в потолок палитры
    final extraFlasks = (difficulty ~/ 2).clamp(0, 4);

    final filledFlaskCount = colorCount + extraFlasks;

    final colors = GameColors.palette.take(colorCount).toList();
    final allLayers = <ColorEntity>[];

    for (int i = 0; i < colorCount; i++) {
      for (int j = 0; j < 4; j++) {
        allLayers.add(ColorEntity(colors[i]));
      }
    }

    allLayers.shuffle(random);

    final flasks = <FlaskEntity>[];

    // распределяем все слои по filledFlaskCount колбам максимально равномерно.
    // ни одна колба не превысит capacity, т.к. filledFlaskCount >= colorCount
    final totalUnits = allLayers.length;
    final baseSize = totalUnits ~/ filledFlaskCount;
    final remainder = totalUnits % filledFlaskCount;

    int cursor = 0;

    for (int i = 0; i < filledFlaskCount; i++) {
      final size = baseSize + (i < remainder ? 1 : 0);

      flasks.add(
        FlaskEntity(
          id: i,
          capacity: GameConfig.flaskCapacity,
          layers: allLayers.sublist(cursor, cursor + size),
        ),
      );

      cursor += size;
    }

    // пустые колбы — количество всегда фиксировано, не зависит от сложности
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
