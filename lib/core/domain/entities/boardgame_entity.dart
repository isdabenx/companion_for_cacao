import 'package:companion_for_cacao/core/domain/entities/module_entity.dart';
import 'package:companion_for_cacao/core/domain/entities/tile_entity.dart';
import 'package:flutter/foundation.dart';

class BoardgameEntity {
  BoardgameEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.filenameImage,
    this.requireId,
    this.modules = const [],
    this.tiles = const [],
  });

  final int id;
  final String name;
  final String description;
  final String filenameImage;
  final int? requireId;
  final List<ModuleEntity> modules;
  final List<TileEntity> tiles;

  BoardgameEntity copyWith({
    int? id,
    String? name,
    String? description,
    String? filenameImage,
    int? requireId,
    List<ModuleEntity>? modules,
    List<TileEntity>? tiles,
  }) {
    return BoardgameEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      filenameImage: filenameImage ?? this.filenameImage,
      requireId: requireId ?? this.requireId,
      modules: modules ?? this.modules,
      tiles: tiles ?? this.tiles,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BoardgameEntity &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.filenameImage == filenameImage &&
        other.requireId == requireId &&
        listEquals(other.modules, modules) &&
        listEquals(other.tiles, tiles);
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    description,
    filenameImage,
    requireId,
    Object.hashAll(modules),
    Object.hashAll(tiles),
  );
}
