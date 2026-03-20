import 'package:companion_for_cacao/core/data/models/boardgame_model.dart';
import 'package:companion_for_cacao/core/data/models/module_model.dart';
import 'package:companion_for_cacao/core/data/models/tile_model.dart';
import 'package:companion_for_cacao/core/data/repositories/boardgame_repository.dart';
import 'package:companion_for_cacao/shared/domain/use_cases/load_boardgames_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBoardgameRepository extends Mock implements BoardgameRepository {}

void main() {
  late LoadBoardgamesUseCase useCase;
  late MockBoardgameRepository mockRepository;

  setUp(() {
    mockRepository = MockBoardgameRepository();
    useCase = LoadBoardgamesUseCase(mockRepository);
  });

  test('execute should load boardgames and merge modules and tiles', () async {
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

    final modules = [
      ModuleModel(
        id: 1,
        boardgameId: 2,
        name: 'Map',
        description: 'Map module',
      ),
      ModuleModel(
        id: 2,
        boardgameId: 2,
        name: 'Chocolate',
        description: 'Choc module',
      ),
    ];

    final tiles = [
      TileModel(
        id: 1,
        name: 'Tile 1',
        description: 'Desc 1',
        filenameImage: 't1.png',
        quantity: 1,
        boardgameId: 1,
      ),
      TileModel(
        id: 2,
        name: 'Tile 2',
        description: 'Desc 2',
        filenameImage: 't2.png',
        quantity: 1,
        boardgameId: 2,
      ),
    ];

    when(
      () => mockRepository.getAllBoardgames(),
    ).thenAnswer((_) async => boardgames);
    when(() => mockRepository.getAllModules()).thenAnswer((_) async => modules);
    when(() => mockRepository.getAllTiles()).thenAnswer((_) async => tiles);

    final result = await useCase.execute();

    expect(result.length, 2);

    // Check Cacao (id: 1)
    expect(result[0].name, 'Cacao');
    expect(result[0].modules.isEmpty, true);
    expect(result[0].tiles.length, 1);
    expect(result[0].tiles[0].name, 'Tile 1');
    expect(result[0].tiles[0].boardgame.value?.name, 'Cacao');

    // Check Chocolatl (id: 2)
    expect(result[1].name, 'Chocolatl');
    expect(result[1].modules.length, 2);
    expect(result[1].modules[0].name, 'Map');
    expect(result[1].modules[1].name, 'Chocolate');
    expect(result[1].tiles.length, 1);
    expect(result[1].tiles[0].name, 'Tile 2');
    expect(result[1].tiles[0].boardgame.value?.name, 'Chocolatl');

    verify(() => mockRepository.getAllBoardgames()).called(1);
    verify(() => mockRepository.getAllModules()).called(1);
    verify(() => mockRepository.getAllTiles()).called(1);
  });
}
