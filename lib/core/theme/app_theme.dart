import 'package:flutter/material.dart';

class _LiquidColors extends ThemeExtension<_LiquidColors> {
  final Color liquidRed;
  final Color liquidBlue;
  final Color liquidGreen;
  final Color liquidYellow;
  final Color liquidPurple;

  _LiquidColors({
    required this.liquidRed,
    required this.liquidBlue,
    required this.liquidGreen,
    required this.liquidYellow,
    required this.liquidPurple,
  });

  @override
  ThemeExtension<_LiquidColors> copyWith({
    Color? liquidRed,
    Color? liquidBlue,
    Color? liquidGreen,
    Color? liquidYellow,
    Color? liquidPurple,
  }) {
    return _LiquidColors(
      liquidRed: liquidRed ?? this.liquidRed,
      liquidBlue: liquidBlue ?? this.liquidBlue,
      liquidGreen: liquidGreen ?? this.liquidGreen,
      liquidYellow: liquidYellow ?? this.liquidYellow,
      liquidPurple: liquidPurple ?? this.liquidPurple,
    );
  }

  @override
  ThemeExtension<_LiquidColors> lerp(
    ThemeExtension<_LiquidColors>? other,
    double t,
  ) {
    if (other is! _LiquidColors) {
      return this;
    }
    return _LiquidColors(
      liquidRed: Color.lerp(liquidRed, other.liquidRed, t)!,
      liquidBlue: Color.lerp(liquidBlue, other.liquidBlue, t)!,
      liquidGreen: Color.lerp(liquidGreen, other.liquidGreen, t)!,
      liquidYellow: Color.lerp(liquidYellow, other.liquidYellow, t)!,
      liquidPurple: Color.lerp(liquidPurple, other.liquidPurple, t)!,
    );
  }
}

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFEFEFEF),
    cardColor: Colors.white.withValues(alpha: 0.6),
    // Кастомные цвета для жидкостей (используем ThemeExtension)
    extensions: <ThemeExtension<dynamic>>[
      _LiquidColors(
        liquidRed: const Color(0xFFF44336).withValues(alpha: 0.8),
        liquidBlue: const Color(0xFF2196F3).withValues(alpha: 0.8),
        liquidGreen: const Color(0xFF4CAF50).withValues(alpha: 0.8),
        liquidYellow: const Color(0xFFFFEB3B).withValues(alpha: 0.8),
        liquidPurple: const Color(0xFF9C27B0).withValues(alpha: 0.8),
      ),
    ],

    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    ),
  );
}
