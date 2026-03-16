class PreparationEntity {
  const PreparationEntity({
    required this.description,
    this.imagePath,
    this.isCompleted = false,
    this.color,
  });
  final String description;
  final String? imagePath;
  final bool isCompleted;
  final String? color;

  PreparationEntity copyWith({
    String? description,
    String? imagePath,
    bool? isCompleted,
    String? color,
  }) {
    return PreparationEntity(
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      isCompleted: isCompleted ?? this.isCompleted,
      color: color ?? this.color,
    );
  }
}
