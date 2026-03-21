import 'package:companion_for_cacao/core/data/database/app_database.dart';
import 'package:companion_for_cacao/core/data/models/boardgame_model.dart';
import 'package:companion_for_cacao/core/data/models/module_model.dart';
import 'package:companion_for_cacao/core/data/models/tile_type_extension.dart';

enum TileType {
  player,
  market,
  plantation,
  goldMine,
  water,
  temple,
  sunWorshipingSite,
}

enum TileColor { red, purple, white, yellow }

class ModelLink<T> {
  ModelLink([this.value]);

  T? value;
}

class TileModel {
  TileModel({
    required this.id,
    required this.name,
    required this.description,
    required this.filenameImage,
    required this.quantity,
    this.type,
    this.color,
    this.boardgameId,
    this.moduleId,
    BoardgameModel? boardgame,
    ModuleModel? module,
  }) : boardgame = ModelLink<BoardgameModel>(boardgame),
       module = ModelLink<ModuleModel>(module);

  factory TileModel.fromJson(Map<String, dynamic> json) {
    return TileModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      filenameImage: json['filenameImage'] as String,
      quantity: json['quantity'] as int,
      type: json['type'] != null
          ? TileType.values.firstWhere(
              (type) => type.toString() == 'TileType.${json['type']}',
            )
          : null,
      color: json['color'] != null
          ? TileColor.values.firstWhere(
              (color) => color.toString() == 'TileColor.${json['color']}',
            )
          : null,
      boardgameId: json['boardgame'] as int,
      moduleId: json['module'] as int?,
    );
  }

  factory TileModel.fromDrift(Tile row) {
    return TileModel(
      id: row.id,
      name: row.name,
      description: row.description,
      filenameImage: row.filenameImage,
      quantity: row.quantity,
      type: row.type != null
          ? TileType.values.firstWhere(
              (type) => type.toString() == 'TileType.${row.type}',
            )
          : null,
      color: row.color != null
          ? TileColor.values.firstWhere(
              (color) => color.toString() == 'TileColor.${row.color}',
            )
          : null,
      boardgameId: row.boardgameId,
      moduleId: row.moduleId,
    );
  }

  final int id;
  final String name;
  final String description;
  final String filenameImage;
  final int quantity;

  final ModelLink<BoardgameModel> boardgame;
  final ModelLink<ModuleModel> module;

  final TileType? type;
  final TileColor? color;

  final int? boardgameId;
  final int? moduleId;

  String get typeAsString => type?.displayName ?? '';

  TileModel copyWith({
    int? id,
    String? name,
    String? description,
    String? filenameImage,
    int? quantity,
    TileType? type,
    TileColor? color,
    int? boardgameId,
    int? moduleId,
    BoardgameModel? boardgame,
    ModuleModel? module,
    bool clearBoardgame = false,
    bool clearModule = false,
  }) {
    return TileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      filenameImage: filenameImage ?? this.filenameImage,
      quantity: quantity ?? this.quantity,
      type: type ?? this.type,
      color: color ?? this.color,
      boardgameId: boardgameId ?? this.boardgameId,
      moduleId: moduleId ?? this.moduleId,
      boardgame: clearBoardgame ? null : (boardgame ?? this.boardgame.value),
      module: clearModule ? null : (module ?? this.module.value),
    );
  }
}
