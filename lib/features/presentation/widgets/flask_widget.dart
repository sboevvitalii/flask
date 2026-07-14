import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/flask_entity.dart';
import '../controllers/game_controller.dart';
import 'flask_painter.dart';

class FlaskWidget extends ConsumerWidget {
  final FlaskEntity flask;

  final int index;

  const FlaskWidget({super.key, required this.flask, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedFlaskIndexProvider);

    final isSelected = selectedIndex == index;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Реальный размер выделенной под колбу ячейки грида —
        // именно от него, а не от ширины экрана, считаем пропорции,
        // иначе при смене crossAxisCount слои перестают совпадать
        // с фактическими границами колбы.
        final flaskWidth = constraints.maxWidth;

        final flaskHeight = constraints.maxHeight;

        // Один слой = 20% высоты колбы
        final layerHeight = flaskHeight * 0.20;

        final glassPadding = flaskWidth * 0.12;

        return GestureDetector(
          onTap: () {
            ref.read(gameControllerProvider.notifier).onTapFlask(index);
          },

          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),

            transform: Matrix4.translationValues(0, isSelected ? -15 : 0, 0),

            width: flaskWidth,

            height: flaskHeight,

            child: Stack(
              alignment: Alignment.center,

              children: [
                // Жидкость внутри колбы
                Positioned(
                  left: glassPadding,

                  right: glassPadding,

                  bottom: glassPadding,

                  top: flaskHeight * 0.10,

                  child: ClipPath(
                    clipper: FlaskClipper(),

                    child: Align(
                      alignment: Alignment.bottomCenter,

                      child: Column(
                        mainAxisSize: MainAxisSize.min,

                        children: [
                          // flask.layers идёт снизу вверх (последний = верхний слой),
                          // а Column рисует первый children сверху — поэтому reversed
                          for (final layer in flask.layers.reversed)
                            if (layer.value != Colors.transparent)
                              SizedBox(
                                height: layerHeight,

                                width: double.infinity,

                                child: Container(
                                  decoration: BoxDecoration(
                                    color: layer.value,

                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,

                                      end: Alignment.bottomCenter,

                                      colors: [
                                        layer.value.withValues(alpha: 0.95),

                                        layer.value.withValues(alpha: 0.65),
                                      ],
                                    ),

                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Стекло колбы
                Positioned.fill(
                  child: CustomPaint(
                    painter: FlaskPainter(selected: isSelected),
                  ),
                ),

                // Номер колбы
                Positioned(
                  bottom: -25,

                  child: Text(
                    '${flask.id + 1}',

                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class FlaskClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    final neckWidth = size.width * 0.35;

    final left = (size.width - neckWidth) / 2;

    path.moveTo(left, 0);

    path.lineTo(left, size.height * 0.15);

    path.quadraticBezierTo(
      size.width * 0.12,

      size.height * 0.25,

      size.width * 0.12,

      size.height * 0.4,
    );

    path.lineTo(size.width * 0.12, size.height * 0.7);

    path.quadraticBezierTo(
      size.width * 0.12,

      size.height * 0.95,

      size.width / 2,

      size.height * 0.95,
    );

    path.quadraticBezierTo(
      size.width * 0.88,

      size.height * 0.95,

      size.width * 0.88,

      size.height * 0.7,
    );

    path.lineTo(size.width * 0.88, size.height * 0.4);

    path.quadraticBezierTo(
      size.width * 0.88,

      size.height * 0.25,

      left + neckWidth,

      size.height * 0.15,
    );

    path.lineTo(left + neckWidth, 0);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
