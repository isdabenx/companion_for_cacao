import 'package:companion_for_cacao/core/domain/entities/boardgame_entity.dart';
import 'package:companion_for_cacao/core/domain/entities/module_entity.dart';
import 'package:companion_for_cacao/core/domain/entities/tile_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/hut_layout_entity.dart';
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
    this.hutLayout,
  });
  final List<PlayerEntity> players;
  final List<BoardgameEntity> expansions;
  final List<ModuleEntity> modules;
  final List<TileEntity> tiles;
  final List<PreparationEntity> preparation;
  final List<String> colorOrder;
  final bool isStarted;
  final bool isBigGame;

  /// Worker tile selection for Module D (The New Workers).
  /// Null when Module D is not active or using default behavior (addAll).
  final WorkerSelectionEntity? workerSelection;

  /// Registered hut throw for the Hut Module (Chocolatl).
  /// Null when the module is inactive or the throw was not registered.
  final HutLayoutEntity? hutLayout;

  /// Total number of modules across all expansions
  /// (Chocolatl 4 + Diamante 4).
  static const int totalModuleCount = 8;

  /// Big Game rule (single source of truth): requires ALL modules
  /// selected and 3–4 players.
  bool get canEnableBigGame =>
      modules.length >= totalModuleCount &&
      players.length >= 3 &&
      players.length <= 4;

  GameSetupStateEntity copyWith({
    List<PlayerEntity>? players,
    List<BoardgameEntity>? expansions,
    List<ModuleEntity>? modules,
    List<TileEntity>? tiles,
    List<PreparationEntity>? preparation,
    List<String>? colorOrder,
    bool? isStarted,
    bool? isBigGame,
    WorkerSelectionEntity? workerSelection,
    bool clearWorkerSelection = false,
    HutLayoutEntity? hutLayout,
    bool clearHutLayout = false,
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
      hutLayout: clearHutLayout ? null : (hutLayout ?? this.hutLayout),
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
        other.workerSelection == workerSelection &&
        other.hutLayout == hutLayout;
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
    hutLayout,
  );
}
