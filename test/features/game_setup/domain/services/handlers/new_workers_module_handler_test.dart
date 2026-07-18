import 'package:companion_for_cacao/core/domain/entities/boardgame_entity.dart';
import 'package:companion_for_cacao/core/domain/entities/tile_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_phase.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/worker_selection_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/handlers/new_workers_module_handler.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/game_fixtures.dart';
import '../../../../../support/tile_fixtures.dart';

void main() {
  group('NewWorkersModuleHandler', () {
    late List<TileEntity> baseWorkerTiles;
    late BoardgameEntity diamanteExpansion;
    late List<PlayerEntity> mockPlayers2;

    setUp(() {
      baseWorkerTiles = [
        ...baseWorkerTilesForColor(TileColor.red),
        ...baseWorkerTilesForColor(TileColor.purple),
      ];

      diamanteExpansion = makeBoardgame(
        id: 3,
        name: 'Diamante',
        tiles: [
          ...diamanteWorkerTilesForColor(TileColor.red),
          ...diamanteWorkerTilesForColor(TileColor.purple),
        ],
      );

      mockPlayers2 = [
        PlayerEntity(name: 'Player 1', color: 'red'),
        PlayerEntity(name: 'Player 2', color: 'purple'),
      ];
    });

    int qty(List<TileEntity> tiles, String id) {
      final matches = tiles.where((t) => t.id == id);
      if (matches.isEmpty) return 0;
      return matches.fold(0, (sum, t) => sum + t.quantity);
    }

    group('adjustTiles', () {
      test('should have correct moduleId', () {
        expect(NewWorkersModuleHandler.moduleId, equals(8));
      });

      test('defaults to addAll behavior when workerSelection is null', () {
        final handler = NewWorkersModuleHandler();

        final result = handler.adjustTiles(
          baseWorkerTiles,
          2,
          activeExpansions: [diamanteExpansion],
        );

        // Base quantities preserved
        expect(qty(result, 'base.worker_red_1-1-1-1'), 4);
        expect(qty(result, 'base.worker_red_2-1-0-1'), 5);
        expect(qty(result, 'base.worker_red_3-0-0-1'), 1);
        expect(qty(result, 'base.worker_red_3-1-0-0'), 1);

        // All 4 new tiles added for each color
        for (final color in ['red', 'purple']) {
          expect(qty(result, 'diamante.worker_${color}_0-0-0-4'), 1);
          expect(qty(result, 'diamante.worker_${color}_0-0-2-2'), 1);
          expect(qty(result, 'diamante.worker_${color}_0-2-0-2'), 1);
          expect(qty(result, 'diamante.worker_${color}_0-1-0-3'), 1);
        }
      });

      test('baseOnly preset keeps base tiles and adds no new tiles', () {
        final handler = NewWorkersModuleHandler(
          workerSelection: const WorkerSelectionEntity(
            presetType: WorkerPresetType.baseOnly,
          ),
        );

        final result = handler.adjustTiles(
          baseWorkerTiles,
          2,
          activeExpansions: [diamanteExpansion],
        );

        expect(qty(result, 'base.worker_red_1-1-1-1'), 4);
        expect(qty(result, 'base.worker_red_2-1-0-1'), 5);
        expect(result.any((t) => t.id.startsWith('diamante.worker_')), isFalse);
      });

      test('replaceWithNew preset zeroes 1-1-1-1 and adds all new tiles', () {
        final handler = NewWorkersModuleHandler(
          workerSelection: const WorkerSelectionEntity(
            presetType: WorkerPresetType.replaceWithNew,
          ),
        );

        final result = handler.adjustTiles(
          baseWorkerTiles,
          2,
          activeExpansions: [diamanteExpansion],
        );

        expect(qty(result, 'base.worker_red_1-1-1-1'), 0);
        expect(qty(result, 'base.worker_purple_1-1-1-1'), 0);
        expect(qty(result, 'base.worker_red_2-1-0-1'), 5);
        expect(qty(result, 'diamante.worker_red_0-0-0-4'), 1);
        expect(qty(result, 'diamante.worker_red_0-0-2-2'), 1);
        expect(qty(result, 'diamante.worker_red_0-2-0-2'), 1);
        expect(qty(result, 'diamante.worker_red_0-1-0-3'), 1);
      });

      test('baseWith0004 preset adds only the 0-0-0-4 tile', () {
        final handler = NewWorkersModuleHandler(
          workerSelection: const WorkerSelectionEntity(
            presetType: WorkerPresetType.baseWith0004,
          ),
        );

        final result = handler.adjustTiles(
          baseWorkerTiles,
          2,
          activeExpansions: [diamanteExpansion],
        );

        expect(qty(result, 'base.worker_red_1-1-1-1'), 4);
        expect(qty(result, 'diamante.worker_red_0-0-0-4'), 1);
        expect(qty(result, 'diamante.worker_purple_0-0-0-4'), 1);
        expect(qty(result, 'diamante.worker_red_0-0-2-2'), 0);
        expect(qty(result, 'diamante.worker_red_0-2-0-2'), 0);
        expect(qty(result, 'diamante.worker_red_0-1-0-3'), 0);
      });

      test('manual quantities override base and new tile quantities', () {
        final handler = NewWorkersModuleHandler(
          workerSelection: const WorkerSelectionEntity(
            mode: WorkerSelectionMode.manual,
            tileQuantities: {'1-1-1-1': 2, '2-1-0-1': 3, '0-0-2-2': 2},
          ),
        );

        final result = handler.adjustTiles(
          baseWorkerTiles,
          2,
          activeExpansions: [diamanteExpansion],
        );

        expect(qty(result, 'base.worker_red_1-1-1-1'), 2);
        expect(qty(result, 'base.worker_red_2-1-0-1'), 3);
        expect(qty(result, 'diamante.worker_red_0-0-2-2'), 2);
        expect(qty(result, 'diamante.worker_purple_0-0-2-2'), 2);
        // New distributions absent from a manual selection default to 0
        expect(qty(result, 'diamante.worker_red_0-0-0-4'), 0);
      });

      test('Big Game returns tiles unchanged', () {
        final handler = NewWorkersModuleHandler();

        final result = handler.adjustTiles(
          baseWorkerTiles,
          2,
          activeExpansions: [diamanteExpansion],
          isBigGame: true,
        );

        expect(result, same(baseWorkerTiles));
      });

      group('Tree of Life 2p enforcement', () {
        late List<TileEntity> tilesWithTreeOfLife;

        setUp(() {
          tilesWithTreeOfLife = [
            ...baseWorkerTiles,
            makeTile(
              id: 'diamante.jungle_tree_of_life',
              name: 'Tree of Life',
              quantity: 2,
              type: TileType.treeOfLife,
              boardgameId: 3,
              moduleId: 6,
            ),
          ];
        });

        test('forces 0-0-0-4 to at least 1 for 2 players even with '
            'baseOnly', () {
          final handler = NewWorkersModuleHandler(
            workerSelection: const WorkerSelectionEntity(
              presetType: WorkerPresetType.baseOnly,
            ),
          );

          final result = handler.adjustTiles(
            tilesWithTreeOfLife,
            2,
            activeExpansions: [diamanteExpansion],
          );

          expect(
            qty(result, 'diamante.worker_red_0-0-0-4'),
            greaterThanOrEqualTo(1),
          );
          expect(
            qty(result, 'diamante.worker_purple_0-0-0-4'),
            greaterThanOrEqualTo(1),
          );
          // Other new tiles still excluded by baseOnly
          expect(qty(result, 'diamante.worker_red_0-0-2-2'), 0);
        });

        test('does not force 0-0-0-4 for 3 players with baseOnly', () {
          final handler = NewWorkersModuleHandler(
            workerSelection: const WorkerSelectionEntity(
              presetType: WorkerPresetType.baseOnly,
            ),
          );

          final result = handler.adjustTiles(
            tilesWithTreeOfLife,
            3,
            activeExpansions: [diamanteExpansion],
          );

          expect(qty(result, 'diamante.worker_red_0-0-0-4'), 0);
        });

        test('does not force 0-0-0-4 when Tree of Life tiles have '
            'quantity 0', () {
          final handler = NewWorkersModuleHandler(
            workerSelection: const WorkerSelectionEntity(
              presetType: WorkerPresetType.baseOnly,
            ),
          );

          final tiles = [
            ...baseWorkerTiles,
            makeTile(
              id: 'diamante.jungle_tree_of_life',
              name: 'Tree of Life',
              quantity: 0,
              type: TileType.treeOfLife,
              boardgameId: 3,
              moduleId: 6,
            ),
          ];

          final result = handler.adjustTiles(
            tiles,
            2,
            activeExpansions: [diamanteExpansion],
          );

          expect(qty(result, 'diamante.worker_red_0-0-0-4'), 0);
        });
      });
    });

    group('modifyPreparationSteps', () {
      late List<PreparationEntity> mockSteps;

      setUp(() {
        mockSteps = [
          const PreparationEntity(
            id: 'setup_remove_worker_1_red',
            description: 'Remove 1-1-1-1 for red',
            phase: PreparationPhase.playerSetup,
          ),
          const PreparationEntity(
            id: 'setup_remove_worker_2_red',
            description: 'Remove 2-1-0-1 for red',
            phase: PreparationPhase.playerSetup,
          ),
          const PreparationEntity(
            id: 'setup_tree_of_life_add_0004_red',
            description: 'Add 0-0-0-4 for red',
            phase: PreparationPhase.playerSetup,
          ),
          const PreparationEntity(
            id: 'setup_shuffle_workers',
            description: 'Shuffle workers',
            phase: PreparationPhase.playerSetup,
          ),
          const PreparationEntity(
            id: 'setup_jungle_draw_pile',
            description: 'Mix remaining jungle tiles',
            phase: PreparationPhase.boardSetup,
          ),
        ];
      });

      test('removes worker removal and tree of life 0-0-0-4 steps', () {
        final handler = NewWorkersModuleHandler();

        final result = handler.modifyPreparationSteps(
          mockPlayers2,
          baseWorkerTiles,
          mockSteps,
        );

        expect(
          result.any((s) => s.id.startsWith('setup_remove_worker_1_')),
          isFalse,
        );
        expect(
          result.any((s) => s.id.startsWith('setup_remove_worker_2_')),
          isFalse,
        );
        expect(
          result.any((s) => s.id.startsWith('setup_tree_of_life_add_0004_')),
          isFalse,
        );
      });

      test(
        'inserts selection step immediately before setup_shuffle_workers',
        () {
          final handler = NewWorkersModuleHandler();

          final result = handler.modifyPreparationSteps(
            mockPlayers2,
            baseWorkerTiles,
            mockSteps,
          );

          final selectionIndex = result.indexWhere(
            (s) => s.id == NewWorkersModuleHandler.selectionStepId,
          );
          final shuffleIndex = result.indexWhere(
            (s) => s.id == 'setup_shuffle_workers',
          );

          expect(selectionIndex, isNonNegative);
          expect(selectionIndex, shuffleIndex - 1);
          expect(result[selectionIndex].phase, PreparationPhase.playerSetup);
        },
      );

      test('appends selection step when setup_shuffle_workers is absent', () {
        final handler = NewWorkersModuleHandler();

        final steps = [
          const PreparationEntity(
            id: 'setup_jungle_draw_pile',
            description: 'Mix remaining jungle tiles',
            phase: PreparationPhase.boardSetup,
          ),
        ];

        final result = handler.modifyPreparationSteps(
          mockPlayers2,
          baseWorkerTiles,
          steps,
        );

        expect(result.last.id, NewWorkersModuleHandler.selectionStepId);
      });

      test('Big Game returns steps unchanged', () {
        final handler = NewWorkersModuleHandler();

        final result = handler.modifyPreparationSteps(
          mockPlayers2,
          baseWorkerTiles,
          mockSteps,
          isBigGame: true,
        );

        expect(result, same(mockSteps));
        expect(
          result.any((s) => s.id == NewWorkersModuleHandler.selectionStepId),
          isFalse,
        );
      });
    });
  });
}
