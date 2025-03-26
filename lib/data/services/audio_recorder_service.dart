import 'package:record/record.dart';
import 'dart:io';

class AudioRecorderService {
  final AudioRecorder _recorder;

  AudioRecorderService([AudioRecorder? recorder])
      : _recorder = recorder ?? AudioRecorder();

  Future<void> startRecording({required String fullPath}) async {
    if (Platform.isIOS && !await _recorder.hasPermission()) {
      final isSimulator = !Platform.isMacOS &&
          !Platform.isAndroid &&
          !Platform.isWindows &&
          !Platform.isLinux;
      if (isSimulator) {
        throw Exception('Recording is not supported on iOS Simulator');
      }
    }

    if (await _recorder.hasPermission()) {
      await _recorder.start(
        RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: fullPath,
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

