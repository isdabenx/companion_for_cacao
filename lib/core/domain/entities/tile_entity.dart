import 'package:collection/collection.dart';
import 'package:companion_for_cacao/core/domain/entities/boardgame_entity.dart';
import 'package:companion_for_cacao/core/domain/entities/module_entity.dart';
import 'package:companion_for_cacao/core/domain/entities/tile_type_extension.dart';
import 'package:companion_for_cacao/core/utils/app_logger.dart';

enum TileType {
  player,
  market,
  plantation,
  goldMine,
  water,
  temple,
  sunWorshipingSite,
  // Chocolatl expansion
  watering,
  chocolateKitchen,
  chocolateMarket,
  mapTile,
  hut,
  // Diamante expansion
  gemMine,
  treeOfLife,
}

enum TileColor { red, purple, white, yellow }

class EntityLink<T> {
  const EntityLink([this.value]);

  final T? value;
}

class TileEntity {
  TileEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.filenameImage,
    required this.quantity,
    this.type,
    this.color,
    this.boardgameId,
    this.moduleId,
    this.hutCost,
    BoardgameEntity? boardgame,
    ModuleEntity? module,
  }) : boardgame = EntityLink<BoardgameEntity>(boardgame),
       module = EntityLink<ModuleEntity>(module);

  /// Parses a [TileType] from its serialized name.
  ///
  /// Returns null for unknown values (logging a warning) so a single
  /// malformed record in the seed data or database can't crash the
  /// whole tile catalog.
  static TileType? typeFromName(String? name) {
    if (name == null) return null;
    final type = TileType.values.firstWhereOrNull((t) => t.name == name);
    if (type == null) {
      AppLogger.warning(
        'TileEntity: unknown TileType "$name", loading tile untyped',
      );
    }
    return type;
  }

  /// Parses a [TileColor] from its serialized name.
  ///
  /// Returns null for unknown values (logging a warning) so a single
  /// malformed record in the seed data or database can't crash the
  /// whole tile catalog.
  static TileColor? colorFromName(String? name) {
    if (name == null) return null;
    final color = TileColor.values.firstWhereOrNull((c) => c.name == name);
    if (color == null) {
      AppLogger.warning(
        'TileEntity: unknown TileColor "$name", loading tile uncolored',
      );
    }
    return color;
  }

  final String id;
  final String name;
  final String description;
  final String filenameImage;
  final int quantity;

  final EntityLink<BoardgameEntity> boardgame;
  final EntityLink<ModuleEntity> module;

  final TileType? type;
  final TileColor? color;

  final int? boardgameId;
  final int? moduleId;
  final int? hutCost;

  String get typeAsString => type?.displayName ?? '';

  /// Default sort: huts last, then alphabetical by name.
  static int defaultSort(TileEntity a, TileEntity b) {
    if (a.type == TileType.hut && b.type != TileType.hut) return 1;
    if (a.type != TileType.hut && b.type == TileType.hut) return -1;
    return a.name.compareTo(b.name);
  }

  TileEntity copyWith({
    String? id,
    String? name,
    String? description,
    String? filenameImage,
    int? quantity,
    TileType? type,
    TileColor? color,
    int? boardgameId,
    int? moduleId,
    int? hutCost,
    BoardgameEntity? boardgame,
    ModuleEntity? module,
    bool clearBoardgame = false,
    bool clearModule = false,
  }) {
    return TileEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      filenameImage: filenameImage ?? this.filenameImage,
      quantity: quantity ?? this.quantity,
      type: type ?? this.type,
      color: color ?? this.color,
      boardgameId: boardgameId ?? this.boardgameId,
      moduleId: moduleId ?? this.moduleId,
      hutCost: hutCost ?? this.hutCost,
      boardgame: clearBoardgame ? null : (boardgame ?? this.boardgame.value),
      module: clearModule ? null : (module ?? this.module.value),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TileEntity &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.filenameImage == filenameImage &&
        other.quantity == quantity &&
        other.type == type &&
        other.color == color &&
        other.boardgameId == boardgameId &&
        other.moduleId == moduleId &&
        other.hutCost == hutCost &&
        other.boardgame.value == boardgame.value &&
        other.module.value == module.value;
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    description,
    filenameImage,
    quantity,
    type,
    color,
    boardgameId,
    moduleId,
    hutCost,
    boardgame.value,
    module.value,
  );
}
