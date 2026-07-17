import 'package:flutter/foundation.dart';

/// A user-created worker tile preset with a custom name and tile quantities.
class CustomPresetEntity {
  const CustomPresetEntity({
    required this.id,
    required this.name,
    required this.tileQuantities,
  });

  /// Unique identifier (timestamp-based).
  final String id;

  /// User-provided display name.
  final String name;

  /// Map of tile distribution name → quantity per player.
  ///
  /// Example: `{"1-1-1-1": 3, "2-1-0-1": 4, "0-0-0-4": 1, ...}`.
  final Map<String, int> tileQuantities;

  /// Total number of worker tiles per player for this preset.
  int get tilesPerPlayer =>
      tileQuantities.values.fold(0, (sum, qty) => sum + qty);

  /// Creates a new unique id based on the current timestamp.
  static String generateId() =>
      'preset_${DateTime.now().millisecondsSinceEpoch}';

  factory CustomPresetEntity.fromJson(Map<String, dynamic> json) {
    return CustomPresetEntity(
      id: json['id'] as String,
      name: json['name'] as String,
      tileQuantities: (json['tileQuantities'] as Map<String, dynamic>).map(
        (k, v) => MapEntry(k, v as int),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'tileQuantities': tileQuantities,
  };

  CustomPresetEntity copyWith({
    String? id,
    String? name,
    Map<String, int>? tileQuantities,
  }) {
    return CustomPresetEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      tileQuantities: tileQuantities ?? this.tileQuantities,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CustomPresetEntity &&
        other.id == id &&
        other.name == name &&
        mapEquals(other.tileQuantities, tileQuantities);
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    // MapEntry has no value-based equality, so hash key/value pairs
    // explicitly (unordered, matching mapEquals semantics).
    Object.hashAllUnordered(
      tileQuantities.entries.map((e) => Object.hash(e.key, e.value)),
    ),
  );
}
