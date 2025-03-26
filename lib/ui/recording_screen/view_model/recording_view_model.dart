import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/services/audio_recorder_service.dart';
import '../../../data/repositories/voice_memo_repository.dart';
import '../../../domain/models/voice_memo.dart';

class RecordingViewModel extends Notifier<bool> {
  late final AudioRecorderService _recorderService;
  late final VoiceMemoRepository _repository;
  late DateTime _startTime;

  @override
  bool build() {
    _recorderService = AudioRecorderService();
    _repository = VoiceMemoRepository();
    return false;
  }

  Future<void> start() async {
    _startTime = DateTime.now();
    final filename = '${_startTime.millisecondsSinceEpoch}.m4a';
    await _recorderService.startRecording(filename);
    state = true;
  }

  Future<void> stop() async {
    final path = await _recorderService.stopRecording();
    final endTime = DateTime.now();

    if (path != null) {
      await _repository.insertVoiceMemo(
        VoiceMemo(
          id: _startTime.millisecondsSinceEpoch,
          filePath: path,
          createdAt: _startTime,
          duration: endTime.difference(_startTime),
        ),
      );
    }

    state = false;
  }
}

// Inlined provider
final recordingViewModelProvider = NotifierProvider<RecordingViewModel, bool>(() => RecordingViewModel());

