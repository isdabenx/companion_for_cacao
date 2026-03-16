class PlayerEntity {
  PlayerEntity({
    required this.name,
    required this.color,
    this.isSelected = false,
  });
  final String name;
  final String color;
  final bool isSelected;

  PlayerEntity copyWith({String? name, String? color, bool? isSelected}) {
    return PlayerEntity(
      name: name ?? this.name,
      color: color ?? this.color,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
