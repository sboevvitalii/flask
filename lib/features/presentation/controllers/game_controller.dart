import 'package:flask/core/utils/logger.dart';
import 'package:flask/features/domain/entities/puzzle_entity.dart';
import 'package:flask/features/domain/enums/game_status.dart';
import 'package:flask/features/domain/services/level_generator.dart';
import 'package:flask/features/domain/services/pouring_service.dart';
import 'package:flask/features/domain/usecases/pour_liquid.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final pouringServiceProvider = Provider<PouringService>(
  (ref) => PouringService(),
);

final pourLiquidProvider = Provider<PourLiquid>(
  (ref) => PourLiquid(ref.read(pouringServiceProvider)),
);

final selectedFlaskIndexProvider = StateProvider<int?>((ref) => null);

final currentLevelProvider = StateProvider<int>((ref) => 1);

final gameControllerProvider =
    StateNotifierProvider<GameController, PuzzleEntity>((ref) {
      return GameController(ref);
    });

class GameController extends StateNotifier<PuzzleEntity> {
  final Ref _ref;

  late final PourLiquid _pourLiquid;

  /// История ходов для Undo
  final List<PuzzleEntity> _history = [];

  GameController(this._ref) : super(LevelGenerator.generate(difficulty: 1)) {
    _pourLiquid = _ref.read(pourLiquidProvider);
  }

  void onTapFlask(int index) {
    final selectedIndex = _ref.read(selectedFlaskIndexProvider);

    if (selectedIndex == null) {
      if (!state.flasks[index].isEmpty) {
        _ref.read(selectedFlaskIndexProvider.notifier).state = index;
      }

      return;
    }

    if (selectedIndex == index) {
      _ref.read(selectedFlaskIndexProvider.notifier).state = null;

      return;
    }

    makeMove(selectedIndex, index);

    _ref.read(selectedFlaskIndexProvider.notifier).state = null;
  }

  void makeMove(int fromIndex, int toIndex) {
    if (state.status == GameStatus.won) {
      return;
    }

    final newState = _pourLiquid.execute(state, fromIndex, toIndex);

    // ход не изменил состояние
    if (newState.movesCount == state.movesCount) {
      Logger.i('Invalid move');

      return;
    }

    // сохраняем состояние ДО хода
    _history.add(state.copyWith());

    state = newState;
  }

  void undo() {
    if (_history.isEmpty) {
      return;
    }

    state = _history.removeLast();
  }

  void newLevel(int difficulty) {
    _history.clear();

    state = LevelGenerator.generate(difficulty: difficulty);

    _ref.read(selectedFlaskIndexProvider.notifier).state = null;
  }

  /// Переход на следующий уровень: сложность растёт, генерируется новая игра
  void nextLevel() {
    _history.clear();

    final level = _ref.read(currentLevelProvider) + 1;

    _ref.read(currentLevelProvider.notifier).state = level;

    state = LevelGenerator.generate(difficulty: level);

    _ref.read(selectedFlaskIndexProvider.notifier).state = null;
  }

  void resetGame() {
    _history.clear();

    final level = _ref.read(currentLevelProvider);

    state = LevelGenerator.generate(difficulty: level);

    _ref.read(selectedFlaskIndexProvider.notifier).state = null;
  }

  bool get canUndo => _history.isNotEmpty;
}
