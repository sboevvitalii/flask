import 'package:flutter/material.dart';
import '../../domain/entities/color_entity.dart';

class LiquidLayerWidget extends StatelessWidget {
  final ColorEntity color;

  final double height;

  const LiquidLayerWidget({
    super.key,

    required this.color,

    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,

      width: double.infinity,

      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color.value,

          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),

          gradient: LinearGradient(
            begin: Alignment.topCenter,

            end: Alignment.bottomCenter,

            colors: [
              color.value.withValues(alpha: 0.9),

              color.value.withValues(alpha: 0.6),
            ],
          ),

          boxShadow: [
            BoxShadow(
              color: color.value.withValues(alpha: 0.4),

              blurRadius: 4,

              offset: const Offset(0, 2),
            ),
          ],
        ),
      ),
    );
  }
}
