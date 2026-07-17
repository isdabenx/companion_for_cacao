import 'package:companion_for_cacao/core/data/models/boardgame_model.dart';
import 'package:companion_for_cacao/core/data/models/module_model.dart';
import 'package:companion_for_cacao/core/data/models/tile_model.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/worker_selection_entity.dart';
import 'package:flutter/foundation.dart';

class GameSetupStateEntity {
  GameSetupStateEntity({
    this.players = const [],
    this.expansions = const [],
    this.modules = const [],
    this.tiles = const [],
    this.preparation = const [],
    this.colorOrder = const ['white', 'red', 'purple', 'yellow'],
    this.isStarted = false,
    this.isBigGame = false,
    this.workerSelection,
  });
  final List<PlayerEntity> players;
  final List<BoardgameModel> expansions;
  final List<ModuleModel> modules;
  final List<TileModel> tiles;
  final List<PreparationEntity> preparation;
  final List<String> colorOrder;
  final bool isStarted;
  final bool isBigGame;

  /// Worker tile selection for Module D (The New Workers).
  /// Null when Module D is not active or using default behavior (addAll).
  final WorkerSelectionEntity? workerSelection;

  GameSetupStateEntity copyWith({
    List<PlayerEntity>? players,
    List<BoardgameModel>? expansions,
    List<ModuleModel>? modules,
    List<TileModel>? tiles,
    List<PreparationEntity>? preparation,
    List<String>? colorOrder,
    bool? isStarted,
    bool? isBigGame,
    WorkerSelectionEntity? workerSelection,
    bool clearWorkerSelection = false,
  }) {
    return GameSetupStateEntity(
      players: players ?? this.players,
      expansions: expansions ?? this.expansions,
      modules: modules ?? this.modules,
      tiles: tiles ?? this.tiles,
      preparation: preparation ?? this.preparation,
      colorOrder: colorOrder ?? this.colorOrder,
      isStarted: isStarted ?? this.isStarted,
      isBigGame: isBigGame ?? this.isBigGame,
      workerSelection: clearWorkerSelection
          ? null
          : (workerSelection ?? this.workerSelection),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GameSetupStateEntity &&
        listEquals(other.players, players) &&
        listEquals(other.expansions, expansions) &&
        listEquals(other.modules, modules) &&
        listEquals(other.tiles, tiles) &&
        listEquals(other.preparation, preparation) &&
        listEquals(other.colorOrder, colorOrder) &&
        other.isStarted == isStarted &&
        other.isBigGame == isBigGame &&
        other.workerSelection == workerSelection;
  }

  @override
  int get hashCode => Object.hash(
    Object.hashAll(players),
    Object.hashAll(expansions),
    Object.hashAll(modules),
    Object.hashAll(tiles),
    Object.hashAll(preparation),
    Object.hashAll(colorOrder),
    isStarted,
    isBigGame,
    workerSelection,
  );
}
