import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/score/domain/entities/hut_type.dart';
import 'package:companion_for_cacao/features/score/domain/entities/player_score_input_entity.dart';
import 'package:companion_for_cacao/features/score/domain/entities/score_category.dart';
import 'package:companion_for_cacao/features/score/domain/entities/score_input_entity.dart';
import 'package:companion_for_cacao/features/score/domain/entities/temple_entry_entity.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:companion_for_cacao/features/score/domain/services/score_calculator_service.dart';

void main() {
  const service = ScoreCalculatorService();

  PlayerEntity player(String color) =>
      PlayerEntity(name: color, color: color, isSelected: true);

  group('scoreTemple', () {
    test('clear first and clear second get 6 and 3 gold', () {
      final gold = service.scoreTemple(
        TempleEntryEntity(
          id: 1,
          workersByColor: {'red': 3, 'white': 2, 'purple': 1},
        ),
      );
      expect(gold, {'red': 6, 'white': 3});
    });

    test('tie for first splits 6 rounded down and second is not awarded', () {
      final gold = service.scoreTemple(
        TempleEntryEntity(
          id: 1,
          workersByColor: {'red': 2, 'white': 2, 'purple': 1},
        ),
      );
      expect(gold, {'red': 3, 'white': 3});
    });

    test('four-way tie for first gives 1 gold each (6 ~/ 4)', () {
      final gold = service.scoreTemple(
        TempleEntryEntity(
          id: 1,
          workersByColor: {'red': 1, 'white': 1, 'purple': 1, 'yellow': 1},
        ),
      );
      expect(gold, {'red': 1, 'white': 1, 'purple': 1, 'yellow': 1});
    });

    test('three-way tie for first gives 2 gold each (6 ~/ 3)', () {
      final gold = service.scoreTemple(
        TempleEntryEntity(
          id: 1,
          workersByColor: {'red': 2, 'white': 2, 'purple': 2},
        ),
      );
      expect(gold, {'red': 2, 'white': 2, 'purple': 2});
    });

    test('clear first with tie for second splits 3 rounded down', () {
      final gold = service.scoreTemple(
        TempleEntryEntity(
          id: 1,
          workersByColor: {'red': 3, 'white': 1, 'purple': 1},
        ),
      );
      expect(gold, {'red': 6, 'white': 1, 'purple': 1});
    });

    test('single player with workers gets 6, no second place', () {
      final gold = service.scoreTemple(
        TempleEntryEntity(id: 1, workersByColor: {'red': 1}),
      );
      expect(gold, {'red': 6});
    });

    test('players with 0 workers never score', () {
      final gold = service.scoreTemple(
        TempleEntryEntity(id: 1, workersByColor: {'red': 2, 'white': 0}),
      );
      expect(gold, {'red': 6});
    });

    test('temple with no adjacent workers awards nothing', () {
      final gold = service.scoreTemple(
        TempleEntryEntity(id: 1, workersByColor: {'red': 0}),
      );
      expect(gold, isEmpty);
    });
  });

  group('scoreHuts', () {
    test('refunds building costs and adds fixed bonuses', () {
      final gold = service.scoreHuts(
        PlayerScoreInputEntity(
          huts: const {HutType.marketCrier, HutType.chief},
        ),
        templesWithPresence: 0,
      );
      // 4 (refund) + 24 (refund) + 6 (chief bonus)
      expect(gold, 34);
    });

    test('fountain master pays 4 only on the 16 water field', () {
      final onTop = service.scoreHuts(
        PlayerScoreInputEntity(
          huts: const {HutType.fountainMaster},
          waterFieldIndex: 8,
        ),
        templesWithPresence: 0,
      );
      final belowTop = service.scoreHuts(
        PlayerScoreInputEntity(
          huts: const {HutType.fountainMaster},
          waterFieldIndex: 7,
        ),
        templesWithPresence: 0,
      );
      expect(onTop, 12 + 4);
      expect(belowTop, 12);
    });

    test('trader pays 1 gold per leftover cacao fruit', () {
      final gold = service.scoreHuts(
        PlayerScoreInputEntity(huts: const {HutType.trader}, cacaoFruits: 5),
        templesWithPresence: 0,
      );
      expect(gold, 6 + 5);
    });

    test('monk pays 1 gold per temple with own presence', () {
      final gold = service.scoreHuts(
        PlayerScoreInputEntity(huts: const {HutType.monk}),
        templesWithPresence: 3,
      );
      expect(gold, 10 + 3);
    });

    test('master builder pays 1 gold per other hut', () {
      final gold = service.scoreHuts(
        PlayerScoreInputEntity(
          huts: const {
            HutType.masterBuilder,
            HutType.marketCrier,
            HutType.farmer,
          },
        ),
        templesWithPresence: 0,
      );
      // Refunds 10 + 4 + 8, master builder bonus 2 (the other two huts)
      expect(gold, 22 + 2);
    });

    test('hermit and road worker use the manual counts', () {
      final gold = service.scoreHuts(
        PlayerScoreInputEntity(
          huts: const {HutType.hermit, HutType.roadWorker},
          hermitWorkers: 4,
          roadWorkerTiles: 5,
        ),
        templesWithPresence: 0,
      );
      expect(gold, 6 + 4 + 6 + 5);
    });

    test('manual counts are ignored without the matching hut', () {
      final gold = service.scoreHuts(
        PlayerScoreInputEntity(
          huts: const {HutType.marketCrier},
          hermitWorkers: 4,
          roadWorkerTiles: 5,
        ),
        templesWithPresence: 0,
      );
      expect(gold, 4);
    });

    test('no huts means no gold', () {
      final gold = service.scoreHuts(
        PlayerScoreInputEntity(),
        templesWithPresence: 2,
      );
      expect(gold, 0);
    });
  });

  group('calculate', () {
    test('base game: gold + water + temples + sun tokens', () {
      final result = service.calculate(
        ScoreInputEntity(
          players: [player('red'), player('white')],
          temples: [
            TempleEntryEntity(id: 1, workersByColor: {'red': 2, 'white': 1}),
          ],
          inputsByColor: {
            'red': PlayerScoreInputEntity(
              accumulatedGold: 20,
              waterFieldIndex: 4, // value 2
              sunTokens: 2,
            ),
            'white': PlayerScoreInputEntity(
              accumulatedGold: 30,
              waterFieldIndex: 0, // value -10
              sunTokens: 0,
            ),
          },
        ),
      );

      final red = result.standings.firstWhere((s) => s.player.color == 'red');
      final white = result.standings.firstWhere(
        (s) => s.player.color == 'white',
      );

      expect(red.breakdown, {
        ScoreCategory.accumulatedGold: 20,
        ScoreCategory.waterTrack: 2,
        ScoreCategory.temples: 6,
        ScoreCategory.sunTokens: 2,
      });
      expect(red.total, 30);
      expect(white.breakdown[ScoreCategory.waterTrack], -10);
      expect(white.breakdown[ScoreCategory.temples], 3);
      expect(white.total, 23);
      expect(red.rank, 1);
      expect(white.rank, 2);
      expect(result.sharedWin, isFalse);
      expect(result.tiebreakByCacaoApplied, isFalse);
    });

    test('gem mines replace temples: temples ignored, masks + gems scored', () {
      final result = service.calculate(
        ScoreInputEntity(
          players: [player('red')],
          gemMinesActive: true,
          temples: [
            TempleEntryEntity(id: 1, workersByColor: {'red': 3}),
          ],
          inputsByColor: {
            'red': PlayerScoreInputEntity(
              accumulatedGold: 10,
              waterFieldIndex: 3, // value 0
              maskValues: const [8, 10],
              leftoverGems: 3,
            ),
          },
        ),
      );

      final red = result.standings.single;
      expect(red.breakdown.containsKey(ScoreCategory.temples), isFalse);
      expect(red.breakdown[ScoreCategory.gemMines], 8 + 10 + 3);
      expect(red.total, 10 + 0 + 21);
    });

    test('huts step scored only when the hut module is active', () {
      final inputs = {
        'red': PlayerScoreInputEntity(huts: const {HutType.chief}),
      };
      final withHuts = service.calculate(
        ScoreInputEntity(
          players: [player('red')],
          hutModuleActive: true,
          inputsByColor: inputs,
        ),
      );
      final withoutHuts = service.calculate(
        ScoreInputEntity(players: [player('red')], inputsByColor: inputs),
      );

      expect(withHuts.standings.single.breakdown[ScoreCategory.huts], 24 + 6);
      expect(
        withoutHuts.standings.single.breakdown.containsKey(ScoreCategory.huts),
        isFalse,
      );
    });

    test('monk bonus counts temples with own presence from temple entries', () {
      final result = service.calculate(
        ScoreInputEntity(
          players: [player('red'), player('white')],
          hutModuleActive: true,
          temples: [
            TempleEntryEntity(id: 1, workersByColor: {'red': 1, 'white': 2}),
            TempleEntryEntity(id: 2, workersByColor: {'white': 1}),
          ],
          inputsByColor: {
            'red': PlayerScoreInputEntity(huts: const {HutType.monk}),
            'white': PlayerScoreInputEntity(huts: const {HutType.monk}),
          },
        ),
      );

      final red = result.standings.firstWhere((s) => s.player.color == 'red');
      final white = result.standings.firstWhere(
        (s) => s.player.color == 'white',
      );
      expect(red.breakdown[ScoreCategory.huts], 10 + 1);
      expect(white.breakdown[ScoreCategory.huts], 10 + 2);
    });

    test('tie on gold broken by leftover cacao fruits (official rule)', () {
      final result = service.calculate(
        ScoreInputEntity(
          players: [player('red'), player('white')],
          inputsByColor: {
            'red': PlayerScoreInputEntity(
              accumulatedGold: 20,
              waterFieldIndex: 3,
              cacaoFruits: 2,
            ),
            'white': PlayerScoreInputEntity(
              accumulatedGold: 20,
              waterFieldIndex: 3,
              cacaoFruits: 4,
            ),
          },
        ),
      );

      expect(result.standings.first.player.color, 'white');
      expect(result.standings.first.rank, 1);
      expect(result.standings.last.rank, 2);
      expect(result.tiebreakByCacaoApplied, isTrue);
      expect(result.sharedWin, isFalse);
    });

    test('tie on gold and cacao is a shared win', () {
      final result = service.calculate(
        ScoreInputEntity(
          players: [player('red'), player('white'), player('purple')],
          inputsByColor: {
            'red': PlayerScoreInputEntity(
              accumulatedGold: 20,
              waterFieldIndex: 3,
              cacaoFruits: 2,
            ),
            'white': PlayerScoreInputEntity(
              accumulatedGold: 20,
              waterFieldIndex: 3,
              cacaoFruits: 2,
            ),
            'purple': PlayerScoreInputEntity(
              accumulatedGold: 5,
              waterFieldIndex: 3,
            ),
          },
        ),
      );

      expect(result.standings[0].rank, 1);
      expect(result.standings[1].rank, 1);
      expect(result.standings[2].rank, 3);
      expect(result.sharedWin, isTrue);
      expect(result.tiebreakByCacaoApplied, isFalse);
      expect(result.winners.length, 2);
    });

    test('negative water can produce a negative total', () {
      final result = service.calculate(
        ScoreInputEntity(
          players: [player('red')],
          inputsByColor: {
            'red': PlayerScoreInputEntity(
              accumulatedGold: 4,
              waterFieldIndex: 0, // value -10
            ),
          },
        ),
      );
      expect(result.standings.single.total, -6);
    });

    test('players without inputs default to zero everywhere', () {
      final result = service.calculate(
        ScoreInputEntity(players: [player('red'), player('white')]),
      );
      expect(result.standings, hasLength(2));
      // Both sit on the starting water field: -10 gold each.
      expect(result.standings[0].total, -10);
      expect(result.standings[1].total, -10);
      expect(result.sharedWin, isTrue);
    });
  });

  group('constants', () {
    test('water track matches the village board', () {
      expect(ScoreCalculatorService.waterTrackValues, [
        -10,
        -4,
        -1,
        0,
        2,
        4,
        7,
        11,
        16,
      ]);
    });

    test('mask supply matches the Diamante material list', () {
      expect(ScoreCalculatorService.maskValues, [8, 8, 9, 9, 10, 10, 12]);
    });
  });
}
