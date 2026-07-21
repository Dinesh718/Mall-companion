import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Service managing Turn-by-Turn Text-to-Speech (TTS) voice announcements.
class TextToSpeechService {
  static final TextToSpeechService _instance = TextToSpeechService._internal();
  factory TextToSpeechService() => _instance;
  TextToSpeechService._internal();

  FlutterTts? _flutterTts;
  String? _lastSpokenKey;
  bool _isMuted = false;
  bool _isInitialized = false;

  bool get isMuted => _isMuted;

  void setMuted(bool muted) {
    _isMuted = muted;
    if (_isMuted) {
      stop();
    }
  }

  void toggleMute() {
    setMuted(!_isMuted);
  }

  Future<void> _initTts() async {
    if (_isInitialized) return;
    try {
      _flutterTts = FlutterTts();
      await _flutterTts?.setLanguage('en-US');
      await _flutterTts?.setSpeechRate(0.5);
      await _flutterTts?.setVolume(1.0);
      await _flutterTts?.setPitch(1.0);
      _isInitialized = true;
    } catch (e) {
      debugPrint('TTS initialization skipped or failed: $e');
    }
  }

  /// Speaks the given text prompt if voice guidance is not muted and the key has changed.
  Future<void> speak({
    required String speechKey,
    required String text,
    bool force = false,
  }) async {
    if (_isMuted || text.trim().isEmpty) return;

    if (!force && _lastSpokenKey == speechKey) {
      return;
    }

    _lastSpokenKey = speechKey;
    try {
      await _initTts();
      await _flutterTts?.stop();
      await _flutterTts?.speak(text);
    } catch (e) {
      debugPrint('TTS speak info: $e');
    }
  }

  Future<void> stop() async {
    try {
      await _flutterTts?.stop();
    } catch (_) {}
  }

  void resetHistory() {
    _lastSpokenKey = null;
  }
}
