import 'package:equatable/equatable.dart';

import 'flask_entity.dart';
import '../enums/game_status.dart';

class PuzzleEntity extends Equatable {
  final List<FlaskEntity> flasks;

  final int movesCount;

  final GameStatus status;

  final DateTime lastPlayed;

  const PuzzleEntity({
    required this.flasks,
    this.movesCount = 0,
    this.status = GameStatus.notStarted,
    required this.lastPlayed,
  });

  factory PuzzleEntity.create({required List<FlaskEntity> flasks}) {
    return PuzzleEntity(flasks: flasks, lastPlayed: DateTime.now());
  }

  /// Проверка завершения уровня
  bool get isCompleted {
    return flasks.every((flask) {
      // пустые колбы разрешены
      if (flask.isEmpty) {
        return true;
      }

      return flask.isComplete;
    });
  }

  /// Глубокая копия состояния
  /// используется для Undo
  PuzzleEntity copyWith({
    List<FlaskEntity>? flasks,

    int? movesCount,

    GameStatus? status,
  }) {
    return PuzzleEntity(
      flasks: flasks ?? this.flasks.map((flask) => flask.clone()).toList(),

      movesCount: movesCount ?? this.movesCount,

      status: status ?? this.status,

      lastPlayed: DateTime.now(),
    );
  }

  /// Создание состояния после успешного хода
  PuzzleEntity makeMove({required List<FlaskEntity> updatedFlasks}) {
    final completed = updatedFlasks.every(
      (flask) => flask.isEmpty || flask.isComplete,
    );

    return copyWith(
      flasks: updatedFlasks,

      movesCount: movesCount + 1,

      status: completed ? GameStatus.won : GameStatus.inProgress,
    );
  }

  @override
  List<Object?> get props => [flasks, movesCount, status, lastPlayed];
}
