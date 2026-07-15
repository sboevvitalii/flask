import '../entities/flask_entity.dart';

class PouringService {
  /// Проверка возможности переливания
  bool canPour({required FlaskEntity from, required FlaskEntity to}) {
    // нельзя переливать из пустой колбы
    if (from.isEmpty) {
      return false;
    }

    // заблокированная (собранная) колба недоступна для действий
    if (from.isComplete || to.isComplete) {
      return false;
    }

    // нельзя переливать в заполненную
    if (!to.hasSpace) {
      return false;
    }

    // нельзя переливать в себя
    if (from.id == to.id) {
      return false;
    }

    // пустая колба принимает любой цвет
    if (to.isEmpty) {
      return true;
    }

    // можно только одинаковый верхний цвет
    return from.topLayer == to.topLayer;
  }

  /// Выполнение переливания
  ({FlaskEntity from, FlaskEntity to, bool success}) pour({
    required FlaskEntity from,

    required FlaskEntity to,
  }) {
    if (!canPour(from: from, to: to)) {
      return (from: from, to: to, success: false);
    }

    final color = from.topLayer!;

    // количество одинакового цвета сверху
    final amount = from.topLayerCount;

    // сколько места есть в целевой колбе
    final freeSpace = to.capacity - to.layers.length;

    // сколько реально переносим
    final transferAmount = amount < freeSpace ? amount : freeSpace;

    final newFromLayers = List.of(from.layers);

    final newToLayers = List.of(to.layers);

    for (int i = 0; i < transferAmount; i++) {
      newFromLayers.removeLast();

      newToLayers.add(color);
    }

    return (
      from: from.copyWith(layers: newFromLayers),

      to: to.copyWith(layers: newToLayers),

      success: true,
    );
  }
}
