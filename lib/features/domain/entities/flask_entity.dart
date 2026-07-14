import 'package:equatable/equatable.dart';
import 'color_entity.dart';

class FlaskEntity extends Equatable {
  final int id;

  /// Слои снизу вверх.
  /// Последний элемент = верхний слой.
  final List<ColorEntity> layers;

  final int capacity;

  const FlaskEntity({
    required this.id,
    required this.capacity,
    this.layers = const [],
  });

  /// Пустая колба
  bool get isEmpty => layers.isEmpty;

  /// Есть свободное место
  bool get hasSpace => layers.length < capacity;

  /// Колба заполнена
  bool get isFull => layers.length >= capacity;

  /// Верхний цвет
  ColorEntity? get topLayer {
    if (layers.isEmpty) {
      return null;
    }

    return layers.last;
  }

  /// Количество одинакового цвета сверху
  int get topLayerCount {
    final top = topLayer;

    if (top == null) {
      return 0;
    }

    int count = 0;

    for (int i = layers.length - 1; i >= 0; i--) {
      if (layers[i] == top) {
        count++;
      } else {
        break;
      }
    }

    return count;
  }

  /// Проверка победы одной колбы
  bool get isComplete {
    if (!isFull) {
      return false;
    }

    if (layers.isEmpty) {
      return false;
    }

    final first = layers.first;

    return layers.every((color) => color == first);
  }

  factory FlaskEntity.empty({required int id, required int capacity}) {
    return FlaskEntity(id: id, capacity: capacity);
  }

  FlaskEntity copyWith({List<ColorEntity>? layers}) {
    return FlaskEntity(
      id: id,

      capacity: capacity,

      layers: layers ?? List<ColorEntity>.from(this.layers),
    );
  }

  /// Полная копия состояния
  FlaskEntity clone() {
    return FlaskEntity(
      id: id,

      capacity: capacity,

      layers: List<ColorEntity>.from(layers),
    );
  }

  @override
  List<Object?> get props => [id, layers, capacity];
}
