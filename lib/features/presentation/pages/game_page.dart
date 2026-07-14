import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/enums/game_status.dart';
import '../controllers/game_controller.dart';
import '../widgets/flask_widget.dart';

class GamePage extends ConsumerWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final puzzle = ref.watch(gameControllerProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.exit_to_app),
          tooltip: 'На главную',
          onPressed: () {
            context.go('/');
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Сбросить',
            onPressed: () => _showResetDialog(context, ref),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Column(
            children: [
              Text(
                'Ходов: ${puzzle.movesCount}',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    int crossAxisCount = 4;
                    if (puzzle.flasks.length <= 6) crossAxisCount = 3;

                    const spacing = 16.0;
                    const flaskRatio = 1 / 2.4; // ширина : высота колбы

                    final rowCount = (puzzle.flasks.length / crossAxisCount)
                        .ceil();

                    // ширина ячейки, если отталкиваться от доступной ширины
                    final cellWidth =
                        (constraints.maxWidth -
                            spacing * (crossAxisCount - 1)) /
                        crossAxisCount;

                    // высота ячейки по ширине (сохраняя пропорции колбы)
                    final heightByWidth = cellWidth / flaskRatio;

                    // высота ячейки, если отталкиваться от доступной высоты
                    final heightByHeight =
                        (constraints.maxHeight - spacing * (rowCount - 1)) /
                        rowCount;

                    // берём меньшее — иначе колбы не влезут по вертикали
                    // и лишние ряды обрежутся (грид не скроллится)
                    final cellHeight = heightByWidth < heightByHeight
                        ? heightByWidth
                        : heightByHeight;

                    return GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: spacing,
                      mainAxisSpacing: spacing,
                      childAspectRatio: cellWidth / cellHeight,
                      shrinkWrap: true,
                      children: List.generate(puzzle.flasks.length, (index) {
                        return FlaskWidget(
                          flask: puzzle.flasks[index],
                          index: index,
                        );
                      }),
                    );
                  },
                ),
              ),
              _buildActionButton(context, ref, puzzle.status),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    WidgetRef ref,
    GameStatus status,
  ) {
    return ElevatedButton.icon(
      onPressed: status == GameStatus.won
          ? () => ref.read(gameControllerProvider.notifier).nextLevel()
          : null,
      label: Text(
        status == GameStatus.won ? 'Уровень пройден' : 'Собери цвета',
      ),
      icon: const Icon(Icons.check_circle),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Future<void> _showResetDialog(BuildContext context, WidgetRef ref) async {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Сбросить уровень?'),
        content: const Text('Вы действительно хотите начать уровень заново?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              ref.read(gameControllerProvider.notifier).resetGame();
              Navigator.pop(context);
            },
            child: const Text('Сбросить', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
