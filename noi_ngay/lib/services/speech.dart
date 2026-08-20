import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Bọc [FlutterTts] để phần giao diện không phải nghĩ tới nền tảng.
///
/// Giọng đọc là giọng có sẵn của hệ điều hành. App không gửi văn bản đi đâu và
/// không tải giọng nào về. Nếu máy chưa cài giọng tiếng Anh, hệ thống trả về im
/// lặng — lớp này nuốt lỗi để nút loa không bao giờ làm app dừng lại.
class Speech {
  Speech() {
    _configure();
  }

  final FlutterTts _tts = FlutterTts();
  bool _ready = false;
  double _rate = 0.45;

  /// Tốc độ đọc hiện tại, từ 0.25 (rất chậm) tới 0.7 (nhanh như người bản ngữ).
  double get rate => _rate;

  Future<void> _configure() async {
    try {
      await _tts.setLanguage('en-US');
      await _tts.setSpeechRate(_rate);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);
      _ready = true;
    } catch (error) {
      debugPrint('Speech: khong khoi tao duoc TTS ($error)');
      _ready = false;
    }
  }

  Future<void> setRate(double value) async {
    _rate = value.clamp(0.25, 0.7);
    try {
      await _tts.setSpeechRate(_rate);
    } catch (error) {
      debugPrint('Speech: khong doi duoc toc do ($error)');
    }
  }

  /// Đọc [text]. Luôn dừng câu đang đọc trước để hai câu không chồng lên nhau.
  Future<void> say(String text) async {
    if (text.trim().isEmpty) return;
    if (!_ready) await _configure();
    try {
      await _tts.stop();
      await _tts.speak(text);
    } catch (error) {
      debugPrint('Speech: khong doc duoc ($error)');
    }
  }

  Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (error) {
      debugPrint('Speech: khong dung duoc ($error)');
    }
  }
}
