import 'package:flutter_test/flutter_test.dart';
import 'package:language_through_travel/models/achievement.dart';
import 'package:language_through_travel/models/phrase.dart';
import 'package:language_through_travel/models/srs_card.dart';
import 'package:language_through_travel/screens/games/matching_game_screen.dart';
import 'package:language_through_travel/services/storage_service.dart';
import 'package:language_through_travel/services/tts_service.dart';
import 'package:language_through_travel/state/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<AppState> _newState() async {
  SharedPreferences.setMockInitialValues(<String, Object>{
    'onboarding_done': true,
    'selected_language': 'en',
  });
  final StorageService storage = await StorageService.create();
  return AppState(storage: storage, tts: TtsService());
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Câu yêu thích', () {
    test('bật rồi tắt lại được, và lọc ra đúng danh sách', () async {
      final AppState state = await _newState();
      final Phrase first = state.allPhrases.first;

      expect(state.isFavourite(first.id), isFalse);
      expect(state.favouriteCount, 0);

      await state.toggleFavourite(first.id);
      expect(state.isFavourite(first.id), isTrue);
      expect(state.favouriteCount, 1);
      expect(state.favouritePhrases.single.id, first.id);

      await state.toggleFavourite(first.id);
      expect(state.isFavourite(first.id), isFalse);
      expect(state.favouritePhrases, isEmpty);
    });

    test('yêu thích được lưu lại giữa hai lần mở app', () async {
      final AppState first = await _newState();
      final String id = first.allPhrases.first.id;
      await first.toggleFavourite(id);

      // Không gọi setMockInitialValues nữa: đọc lại đúng kho vừa ghi.
      final StorageService storage = await StorageService.create();
      final AppState reopened =
          AppState(storage: storage, tts: TtsService());

      expect(reopened.isFavourite(id), isTrue);
    });
  });

  group('Kỷ lục trò chơi', () {
    test('chỉ ghi đè khi điểm cao hơn', () async {
      final AppState state = await _newState();

      expect(state.gameBest(matchingGameId), 0);
      expect(await state.recordGameScore(matchingGameId, 40), isTrue);
      expect(state.gameBest(matchingGameId), 40);

      expect(await state.recordGameScore(matchingGameId, 30), isFalse);
      expect(state.gameBest(matchingGameId), 40);

      expect(await state.recordGameScore(matchingGameId, 75), isTrue);
      expect(state.gameBest(matchingGameId), 75);
    });
  });

  group('Lịch học', () {
    test('ôn một thẻ là hôm nay được tính vào lịch', () async {
      final AppState state = await _newState();
      expect(state.activeDaysIn(30), 0);

      await state.reviewPhrase(
        state.allPhrases.first.id,
        RecallQuality.good,
      );

      expect(state.studiedOn(DateTime.now()), isTrue);
      expect(state.activeDaysIn(30), 1);
      expect(state.streak, 1);
    });
  });

  group('Huy hiệu', () {
    test('mở khoá theo tiến độ thật, không lưu riêng', () async {
      final AppState state = await _newState();

      Achievement byId(String id) =>
          state.achievements.firstWhere((Achievement a) => a.id == id);

      expect(byId('first_step').unlocked, isFalse);

      await state.reviewPhrase(
        state.allPhrases.first.id,
        RecallQuality.good,
      );

      expect(byId('first_step').unlocked, isTrue);
      expect(state.unlockedAchievementCount, greaterThanOrEqualTo(1));
    });
  });

  group('Xoá tiến độ', () {
    test('xoá cả yêu thích và kỷ lục trò chơi', () async {
      final AppState state = await _newState();
      await state.toggleFavourite(state.allPhrases.first.id);
      await state.recordGameScore(matchingGameId, 50);
      await state.reviewPhrase(
        state.allPhrases.first.id,
        RecallQuality.good,
      );

      await state.resetProgress();

      expect(state.favouriteCount, 0);
      expect(state.gameBest(matchingGameId), 0);
      expect(state.learnedCount, 0);
    });
  });
}
