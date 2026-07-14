import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ColorEntity extends Equatable {
  final Color value;

  const ColorEntity(this.value);

  /// Прозрачный слой
  bool get isEmpty => value == Colors.transparent;

  /// Копия объекта
  ColorEntity clone() {
    return ColorEntity(value);
  }

  @override
  List<Object?> get props => [value];
}
