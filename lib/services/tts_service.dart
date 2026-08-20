import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Bọc flutter_tts để phần UI không phải xử lý lỗi nền tảng.
///
/// Engine được tạo lười (lazy) ở lần phát đầu tiên: nhờ vậy khởi tạo
/// [TtsService] không đụng tới plugin channel, và widget test dựng được app
/// mà không cần mock plugin.
///
/// Nếu thiết bị thiếu giọng đọc cho locale yêu cầu, [speak] im lặng bỏ qua
/// thay vì ném lỗi — người học vẫn dùng được app bình thường.
class TtsService {
  FlutterTts? _engine;
  String _currentLocale = '';
  bool _speaking = false;

  bool get isSpeaking => _speaking;

  FlutterTts get _tts => _engine ??= FlutterTts();

  Future<void> speak(String text, String locale, {double rate = 0.45}) async {
    if (text.trim().isEmpty) return;
    try {
      if (_speaking) {
        await _tts.stop();
      }
      if (_currentLocale != locale) {
        await _tts.setLanguage(locale);
        _currentLocale = locale;
      }
      await _tts.setSpeechRate(rate);
      await _tts.setPitch(1.0);
      await _tts.setVolume(1.0);
      _speaking = true;
      await _tts.speak(text);
    } catch (error) {
      debugPrint('TTS không phát được ($locale): $error');
    } finally {
      _speaking = false;
    }
  }

  Future<void> stop() async {
    if (_engine == null) return;
    try {
      await _tts.stop();
    } catch (_) {
      // Bỏ qua: dừng khi chưa phát không phải là lỗi đáng báo.
    }
    _speaking = false;
  }

  /// Kiểm tra thiết bị có hỗ trợ đọc [locale] hay không.
  Future<bool> isLocaleAvailable(String locale) async {
    try {
      final Object? result = await _tts.isLanguageAvailable(locale);
      return result == true;
    } catch (_) {
      return false;
    }
  }
}
