import '../entities/color_entity.dart';

class FlaskEntity {
  final String id;

  /// Максимальная вместимость колбы
  final int capacity;

  /// Слои жидкости снизу вверх
  /// Последний элемент списка — верхний слой
  final List<ColorEntity> liquids;

  const FlaskEntity({
    required this.id,
    required this.capacity,
    required this.liquids,
  });

  /// Пустая колба
  bool get isEmpty => liquids.isEmpty;

  /// Колба заполнена
  bool get isFull => liquids.length >= capacity;

  /// Верхний цвет жидкости
  ColorEntity? get topColor {
    if (liquids.isEmpty) {
      return null;
    }

    return liquids.last;
  }

  /// Количество одинаковых цветов сверху
  int get topColorAmount {
    if (liquids.isEmpty) {
      return 0;
    }

    final color = liquids.last;

    int count = 0;

    for (int i = liquids.length - 1; i >= 0; i--) {
      if (liquids[i] == color) {
        count++;
      } else {
        break;
      }
    }

    return count;
  }

  /// Свободное место
  int get freeSpace => capacity - liquids.length;

  /// Создание копии состояния колбы
  FlaskEntity copyWith({
    String? id,
    int? capacity,
    List<ColorEntity>? liquids,
  }) {
    return FlaskEntity(
      id: id ?? this.id,
      capacity: capacity ?? this.capacity,
      liquids: liquids ?? List<ColorEntity>.from(this.liquids),
    );
  }

  /// Полная копия объекта
  FlaskEntity clone() {
    return FlaskEntity(
      id: id,
      capacity: capacity,
      liquids: List<ColorEntity>.from(liquids),
    );
  }

  /// Проверка: заполнена одним цветом
  bool get isCompleted {
    if (!isFull) {
      return false;
    }

    final first = liquids.first;

    return liquids.every((color) => color == first);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is FlaskEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
