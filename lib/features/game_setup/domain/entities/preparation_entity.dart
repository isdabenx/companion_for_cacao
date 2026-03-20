class PreparationEntity {
  const PreparationEntity({
    required this.id,
    required this.description,
    this.imagePath,
    this.isCompleted = false,
    this.color,
    this.variables,
  });
  final String id;
  final String description;
  final String? imagePath;
  final bool isCompleted;
  final String? color;
  final Map<String, String>? variables;

  PreparationEntity copyWith({
    String? id,
    String? description,
    String? imagePath,
    bool? isCompleted,
    String? color,
    Map<String, String>? variables,
  }) {
    return PreparationEntity(
      id: id ?? this.id,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      isCompleted: isCompleted ?? this.isCompleted,
      color: color ?? this.color,
      variables: variables ?? this.variables,
    );
  }
}
