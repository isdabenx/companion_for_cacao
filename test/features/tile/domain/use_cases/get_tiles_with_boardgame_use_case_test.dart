import 'package:companion_for_cacao/core/data/models/boardgame_model.dart';
import 'package:companion_for_cacao/core/data/models/tile_model.dart';
import 'package:companion_for_cacao/core/data/repositories/boardgame_repository.dart';
import 'package:companion_for_cacao/features/tile/data/repositories/tile_repository.dart';
import 'package:companion_for_cacao/features/tile/domain/use_cases/get_tiles_with_boardgame_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTileRepository extends Mock implements TileRepository {}

class MockBoardgameRepository extends Mock implements BoardgameRepository {}

void main() {
  late GetTilesWithBoardgameUseCase useCase;
  late MockTileRepository mockTileRepository;
  late MockBoardgameRepository mockBoardgameRepository;

  setUp(() {
    mockTileRepository = MockTileRepository();
    mockBoardgameRepository = MockBoardgameRepository();
    useCase = GetTilesWithBoardgameUseCase(
      mockTileRepository,
      mockBoardgameRepository,
    );
  });

  test(
    'execute should return all tiles with their boardgames when idsList is null',
    () async {
      final boardgames = [
        BoardgameModel(
          id: 1,
          name: 'Cacao',
          description: 'Base',
          filenameImage: 'cacao.png',
        ),
        BoardgameModel(
          id: 2,
          name: 'Chocolatl',
          description: 'Exp 1',
          filenameImage: 'chocolatl.png',
        ),
      ];

      final tiles = [
        TileModel(
          id: 'test_tile_1',
          name: 'Tile 1',
          description: 'Desc 1',
          filenameImage: 't1.png',
          quantity: 1,
          boardgameId: 1,
        ),
        TileModel(
          id: 'test_tile_2',
          name: 'Tile 2',
          description: 'Desc 2',
          filenameImage: 't2.png',
          quantity: 1,
          boardgameId: 2,
        ),
        TileModel(
          id: 'test_tile_3',
          name: 'Tile 3',
          description: 'Desc 3',
          filenameImage: 't3.png',
          quantity: 1,
          boardgameId: 99,
        ), // Unknown boardgame
      ];

      when(
        () => mockTileRepository.getAllTiles(),
      ).thenAnswer((_) async => tiles);
      when(
        () => mockBoardgameRepository.getAllBoardgames(),
      ).thenAnswer((_) async => boardgames);

      final result = await useCase.execute();

      expect(result.length, 3);
      expect(result[0].boardgame.value?.name, 'Cacao');
      expect(result[1].boardgame.value?.name, 'Chocolatl');
      expect(result[2].boardgame.value, isNull);

      verify(() => mockTileRepository.getAllTiles()).called(1);
      verify(() => mockBoardgameRepository.getAllBoardgames()).called(1);
      verifyNever(() => mockTileRepository.getTilesByIds(any()));
    },
  );

  test(
    'execute should return specific tiles with their boardgames when idsList is provided',
    () async {
      final boardgames = [
        BoardgameModel(
          id: 1,
          name: 'Cacao',
          description: 'Base',
          filenameImage: 'cacao.png',
        ),
      ];

      final tiles = [
        TileModel(
          id: 'test_tile_1',
          name: 'Tile 1',
          description: 'Desc 1',
          filenameImage: 't1.png',
          quantity: 1,
          boardgameId: 1,
        ),
      ];

      when(
        () => mockTileRepository.getTilesByIds(['test_tile_1']),
      ).thenAnswer((_) async => tiles);
      when(
        () => mockBoardgameRepository.getAllBoardgames(),
      ).thenAnswer((_) async => boardgames);

      final result = await useCase.execute(idsList: ['test_tile_1']);

      expect(result.length, 1);
      expect(result[0].boardgame.value?.name, 'Cacao');

      verify(() => mockTileRepository.getTilesByIds(['test_tile_1'])).called(1);
      verify(() => mockBoardgameRepository.getAllBoardgames()).called(1);
      verifyNever(() => mockTileRepository.getAllTiles());
    },
  );
}
