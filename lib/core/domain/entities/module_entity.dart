class ModuleEntity {
  ModuleEntity({
    required this.id,
    required this.name,
    required this.description,
    this.boardgameId,
  });

  final int id;
  final String name;
  final String description;
  final int? boardgameId;

  ModuleEntity copyWith({
    int? id,
    String? name,
    String? description,
    int? boardgameId,
  }) {
    return ModuleEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      boardgameId: boardgameId ?? this.boardgameId,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ModuleEntity &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.boardgameId == boardgameId;
  }

  @override
  int get hashCode => Object.hash(id, name, description, boardgameId);
}
