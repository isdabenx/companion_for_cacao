import 'package:companion_for_cacao/core/utils/string_extensions.dart';

class PlayerEntity {
  PlayerEntity({
    required this.name,
    required this.color,
    this.isSelected = false,
  });
  final String name;
  final String color;
  final bool isSelected;

  /// Name to show in the UI: the typed name, or the capitalized color for
  /// unnamed players.
  String get displayName => name.isNotEmpty ? name : color.capitalized;

  PlayerEntity copyWith({String? name, String? color, bool? isSelected}) {
    return PlayerEntity(
      name: name ?? this.name,
      color: color ?? this.color,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PlayerEntity &&
        other.name == name &&
        other.color == color &&
        other.isSelected == isSelected;
  }

  @override
  int get hashCode => Object.hash(name, color, isSelected);
}
