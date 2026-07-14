import 'package:flutter/material.dart';

class FlaskPainter extends CustomPainter {
  final bool selected;

  FlaskPainter({this.selected = false});

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    final strokeColor = selected
        ? Colors.amber
        : Colors.white.withAlpha((0.65 * 255).round());

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = selected ? 4 : 3
      ..color = strokeColor
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final glassFill = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white.withAlpha((0.08 * 255).round());

    final path = Path();

    final neckWidth = width * 0.35;
    final neckLeft = (width - neckWidth) / 2;

    // Начало горлышка
    path.moveTo(neckLeft, 0);

    path.lineTo(neckLeft, height * 0.15);

    // Переход от горлышка к колбе
    path.quadraticBezierTo(
      width * 0.15,
      height * 0.22,
      width * 0.12,
      height * 0.35,
    );

    // Левая стенка
    path.lineTo(width * 0.12, height * 0.72);

    // Дно
    path.quadraticBezierTo(
      width * 0.12,
      height * 0.95,
      width / 2,
      height * 0.95,
    );

    path.quadraticBezierTo(
      width * 0.88,
      height * 0.95,
      width * 0.88,
      height * 0.72,
    );

    // Правая стенка
    path.lineTo(width * 0.88, height * 0.35);

    path.quadraticBezierTo(
      width * 0.85,
      height * 0.22,
      neckLeft + neckWidth,
      height * 0.15,
    );

    path.lineTo(neckLeft + neckWidth, 0);

    // Закрываем верх
    path.lineTo(neckLeft, 0);

    // Стекло
    canvas.drawPath(path, glassFill);

    // Контур
    canvas.drawPath(path, paint);

    // Горлышко
    final neckPaint = Paint()
      ..color = Colors.white.withAlpha((0.5 * 255).round())
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(neckLeft, height * 0.08),
      Offset(neckLeft + neckWidth, height * 0.08),
      neckPaint,
    );

    // Блик на стекле
    final shine = Paint()
      ..color = Colors.white.withAlpha((0.45 * 255).round())
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final shinePath = Path();

    shinePath.moveTo(width * 0.28, height * 0.28);

    shinePath.lineTo(width * 0.28, height * 0.7);

    canvas.drawPath(shinePath, shine);

    // Маленький блик сверху
    canvas.drawLine(
      Offset(width * 0.42, height * 0.05),
      Offset(width * 0.58, height * 0.05),
      Paint()
        ..color = Colors.white.withAlpha((0.7 * 255).round())
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant FlaskPainter oldDelegate) {
    return oldDelegate.selected != selected;
  }
}
