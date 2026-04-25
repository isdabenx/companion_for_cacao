import 'package:companion_for_cacao/config/constants/tile_settings.dart';
import 'package:companion_for_cacao/config/providers/repository_providers.dart';
import 'package:companion_for_cacao/core/domain/repositories/settings_repository.dart';
import 'package:companion_for_cacao/features/tile/presentation/providers/tile_settings_notifier.dart';
import 'package:companion_for_cacao/shared/domain/entities/tile_settings_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

class TestException implements Exception {
  const TestException(this.message);

  final String message;

  @override
  String toString() => 'TestException($message)';
}

void main() {
  setUpAll(() {
    registerFallbackValue(TileSettingsEntity());
  });

  late MockSettingsRepository mockSettingsRepository;

  ProviderContainer createContainer() {
    final container = ProviderContainer(
      retry: (_, _) => null,
      overrides: [
        settingsRepositoryProvider.overrideWith(
          (ref) => mockSettingsRepository,
        ),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUp(() {
    mockSettingsRepository = MockSettingsRepository();
    when(
      () => mockSettingsRepository.saveTileSettings(any()),
    ).thenAnswer((_) async {});
  });

  group('TileSettingsNotifier', () {
    test('build loads settings from repository', () async {
      final storedSettings = TileSettingsEntity(
        playerColorInBorder: false,
        playerColorInCircle: false,
        badgeTypeInImage: false,
        badgeTypeInText: true,
        boardgameInTitle: false,
        showQuantity: false,
        compactTileLayout: true,
      );
      when(
        () => mockSettingsRepository.getTileSettings(),
      ).thenAnswer((_) async => storedSettings);

      final container = createContainer();

      final result = await container.read(tileSettingsProvider.future);

      _expectSettings(result, storedSettings);
      verify(() => mockSettingsRepository.getTileSettings()).called(1);
    });

    test('build returns defaults when repository throws', () async {
      when(
        () => mockSettingsRepository.getTileSettings(),
      ).thenThrow(const TestException('load failed'));

      final container = createContainer();

      final result = await container.read(tileSettingsProvider.future);

      _expectSettings(result, TileSettingsEntity());
      verify(() => mockSettingsRepository.getTileSettings()).called(1);
      verifyNever(() => mockSettingsRepository.saveTileSettings(any()));
    });

    test('togglePlayerColorInBorder toggles and saves', () async {
      await _expectTogglePersists(
        createContainer: createContainer,
        repository: mockSettingsRepository,
        act: (notifier) => notifier.togglePlayerColorInBorder(),
        expected: TileSettingsEntity(playerColorInBorder: false),
      );
    });

    test('togglePlayerColorInCircle toggles and saves', () async {
      await _expectTogglePersists(
        createContainer: createContainer,
        repository: mockSettingsRepository,
        act: (notifier) => notifier.togglePlayerColorInCircle(),
        expected: TileSettingsEntity(playerColorInCircle: false),
      );
    });

    test('toggleBadgeTypeInImage toggles and saves', () async {
      await _expectTogglePersists(
        createContainer: createContainer,
        repository: mockSettingsRepository,
        act: (notifier) => notifier.toggleBadgeTypeInImage(),
        expected: TileSettingsEntity(badgeTypeInImage: false),
      );
    });

    test('toggleBadgeTypeInText toggles and saves', () async {
      await _expectTogglePersists(
        createContainer: createContainer,
        repository: mockSettingsRepository,
        act: (notifier) => notifier.toggleBadgeTypeInText(),
        expected: TileSettingsEntity(badgeTypeInText: false),
      );
    });

    test('toggleBoardgameInTitle toggles and saves', () async {
      await _expectTogglePersists(
        createContainer: createContainer,
        repository: mockSettingsRepository,
        act: (notifier) => notifier.toggleBoardgameInTitle(),
        expected: TileSettingsEntity(boardgameInTitle: false),
      );
    });

    test('toggleShowQuantity toggles and saves', () async {
      await _expectTogglePersists(
        createContainer: createContainer,
        repository: mockSettingsRepository,
        act: (notifier) => notifier.toggleShowQuantity(),
        expected: TileSettingsEntity(showQuantity: false),
      );
    });

    test('toggleCompactTileLayout toggles and saves', () async {
      await _expectTogglePersists(
        createContainer: createContainer,
        repository: mockSettingsRepository,
        act: (notifier) => notifier.toggleCompactTileLayout(),
        expected: TileSettingsEntity(compactTileLayout: true),
      );
    });

    final dispatchCases = [
      (
        label: 'playerColorInBorder',
        action: TileSettings.playerColorInBorder,
        expected: TileSettingsEntity(playerColorInBorder: false),
      ),
      (
        label: 'playerColorInCircle',
        action: TileSettings.playerColorInCircle,
        expected: TileSettingsEntity(playerColorInCircle: false),
      ),
      (
        label: 'badgeTypeInImage',
        action: TileSettings.badgeTypeInImage,
        expected: TileSettingsEntity(badgeTypeInImage: false),
      ),
      (
        label: 'badgeTypeInText',
        action: TileSettings.badgeTypeInText,
        expected: TileSettingsEntity(badgeTypeInText: false),
      ),
      (
        label: 'boardgameInTitle',
        action: TileSettings.boardgameInTitle,
        expected: TileSettingsEntity(boardgameInTitle: false),
      ),
      (
        label: 'showQuantity',
        action: TileSettings.showQuantity,
        expected: TileSettingsEntity(showQuantity: false),
      ),
      (
        label: 'compactTileLayout',
        action: TileSettings.compactTileLayout,
        expected: TileSettingsEntity(compactTileLayout: true),
      ),
    ];

    for (final dispatchCase in dispatchCases) {
      test(
        'toggleSettings(${dispatchCase.label}) dispatches to correct toggle',
        () async {
          await _expectTogglePersists(
            createContainer: createContainer,
            repository: mockSettingsRepository,
            act: (notifier) => notifier.toggleSettings(dispatchCase.action),
            expected: dispatchCase.expected,
          );
        },
      );
    }
  });
}

Future<void> _expectTogglePersists({
  required ProviderContainer Function() createContainer,
  required MockSettingsRepository repository,
  required void Function(TileSettingsNotifier notifier) act,
  required TileSettingsEntity expected,
}) async {
  when(
    () => repository.getTileSettings(),
  ).thenAnswer((_) async => TileSettingsEntity());

  final container = createContainer();
  await container.read(tileSettingsProvider.future);

  final notifier = container.read(tileSettingsProvider.notifier);
  act(notifier);

  await untilCalled(() => repository.saveTileSettings(any()));

  final state = container.read(tileSettingsProvider).requireValue;
  final saved =
      verify(() => repository.saveTileSettings(captureAny())).captured.single
          as TileSettingsEntity;

  _expectSettings(state, expected);
  _expectSettings(saved, expected);
  verify(() => repository.getTileSettings()).called(1);
}

void _expectSettings(TileSettingsEntity actual, TileSettingsEntity expected) {
  expect(actual.playerColorInBorder, expected.playerColorInBorder);
  expect(actual.playerColorInCircle, expected.playerColorInCircle);
  expect(actual.badgeTypeInImage, expected.badgeTypeInImage);
  expect(actual.badgeTypeInText, expected.badgeTypeInText);
  expect(actual.boardgameInTitle, expected.boardgameInTitle);
  expect(actual.showQuantity, expected.showQuantity);
  expect(actual.compactTileLayout, expected.compactTileLayout);
}
