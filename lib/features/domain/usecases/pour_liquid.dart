import 'package:flask/features/domain/enums/game_status.dart';

import '../entities/puzzle_entity.dart';
import '../services/pouring_service.dart';

class PourLiquid {
  final PouringService _pouringService;

  PourLiquid(this._pouringService);

  PuzzleEntity execute(PuzzleEntity puzzle, int fromIndex, int toIndex) {
    if (fromIndex < 0 ||
        toIndex < 0 ||
        fromIndex >= puzzle.flasks.length ||
        toIndex >= puzzle.flasks.length) {
      return puzzle;
    }

    final fromFlask = puzzle.flasks[fromIndex];

    final toFlask = puzzle.flasks[toIndex];

    final result = _pouringService.pour(from: fromFlask, to: toFlask);

    // невозможный ход
    if (!result.success) {
      return puzzle;
    }

    final newFlasks = puzzle.flasks.map((flask) => flask.clone()).toList();

    newFlasks[fromIndex] = result.from;

    newFlasks[toIndex] = result.to;

    final updatedPuzzle = puzzle.copyWith(
      flasks: newFlasks,
      movesCount: puzzle.movesCount + 1,
    );

    return updatedPuzzle.copyWith(
      status: updatedPuzzle.isCompleted
          ? GameStatus.won
          : GameStatus.inProgress,
    );
  }
}
