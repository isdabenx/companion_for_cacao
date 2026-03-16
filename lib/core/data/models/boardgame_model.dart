import 'package:companion_for_cacao/core/data/database/app_database.dart';
import 'package:companion_for_cacao/core/data/models/module_model.dart';
import 'package:companion_for_cacao/core/data/models/tile_model.dart';

class BoardgameModel {
  BoardgameModel({
    required this.id,
    required this.name,
    required this.description,
    required this.filenameImage,
    this.requireId,
    this.modules = const [],
    this.tiles = const [],
  });

  factory BoardgameModel.fromJson(Map<String, dynamic> json) {
    return BoardgameModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      filenameImage: json['filenameImage'] as String,
      requireId: json['require'] as int?,
    );
  }

  factory BoardgameModel.fromDrift(Boardgame row) {
    return BoardgameModel(
      id: row.id,
      name: row.name,
      description: row.description,
      filenameImage: row.filenameImage,
      requireId: row.requireId,
    );
  }

  final int id;
  final String name;
  final String description;
  final String filenameImage;
  final int? requireId;
  final List<ModuleModel> modules;
  final List<TileModel> tiles;

  BoardgameModel copyWith({
    int? id,
    String? name,
    String? description,
    String? filenameImage,
    int? requireId,
    List<ModuleModel>? modules,
    List<TileModel>? tiles,
  }) {
    return BoardgameModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      filenameImage: filenameImage ?? this.filenameImage,
      requireId: requireId ?? this.requireId,
      modules: modules ?? this.modules,
      tiles: tiles ?? this.tiles,
    );
  }
}
