import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class AudioRecorderService {
  static final AudioRecorderService _instance = AudioRecorderService._internal();
  late final AudioRecorder _recorder;

  factory AudioRecorderService() {
    return _instance;
  }

  AudioRecorderService._internal() {
    _recorder = AudioRecorder();
  }

  Future<void> startRecording(String fileName) async {
    if (await _recorder.hasPermission()) {
      final dir = await getApplicationDocumentsDirectory();
      final path = join(dir.path, fileName);

      await _recorder.start(
        RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: path,
      );
    } else {
      throw Exception('Microphone permission not granted');
    }
  }

  Future<String?> stopRecording() async {
    if (await _recorder.isRecording()) {
      return await _recorder.stop();
    }
    return null;
  }

  Future<bool> isRecording() async => await _recorder.isRecording();
}
