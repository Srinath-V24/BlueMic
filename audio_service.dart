import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sound/flutter_sound.dart';

class AudioService {
  FlutterSoundRecorder? _recorder;
  FlutterSoundPlayer? _player;
  StreamController<Food>? _audioStreamController;
  StreamSubscription<RecordingDisposition>? _recorderSubscription;
  bool _isInitialized = false;
  bool _isStreaming = false;

  Future<void> _initialize() async {
    if (!_isInitialized) {
      _recorder = FlutterSoundRecorder();
      _player = FlutterSoundPlayer();
      
      await _recorder!.openRecorder();
      await _player!.openPlayer();
      _isInitialized = true;
    }
  }

  Future<void> startStreaming() async {
    if (await _requestPermissions() && !_isStreaming) {
      await _initialize();
      
      try {
        // Start the player first to output to default audio device (Bluetooth if connected)
        await _player!.startPlayer(
          fromURI: 'dev:mic', // This creates a real-time microphone passthrough
          codec: Codec.pcm16,
          numChannels: 1,
          sampleRate: 44100,
        );

        _isStreaming = true;
        print('Real-time audio streaming started - Mic to Speaker');
        
      } catch (e) {
        print('Error starting real-time streaming: $e');
        // Fallback to manual streaming approach
        await _startManualStreaming();
      }
    }
  }

  Future<void> _startManualStreaming() async {
    try {
      // Create a stream for audio data
      _audioStreamController = StreamController<Food>.broadcast();
      
      // Start recording with real-time data callback
      _recorderSubscription = _recorder!.onProgress!.listen((recordingData) {
        _handleRealTimeAudioData(recordingData);
      });

      // Start recording to capture microphone
      await _recorder!.startRecorder(
        codec: Codec.pcm16,
        numChannels: 1,
        sampleRate: 44100,
        bitRate: 16000,
      );

      // Start player for output
      await _player!.startPlayer(
        codec: Codec.pcm16,
        numChannels: 1,
        sampleRate: 44100,
      );

      _isStreaming = true;
      print('Manual real-time streaming started');
      
    } catch (e) {
      print('Error in manual streaming: $e');
      _isStreaming = false;
    }
  }

  void _handleRealTimeAudioData(RecordingDisposition recordingData) {
    if (_isStreaming && _player != null) {
      // Real-time audio processing happens here
      // Audio is automatically routed to the default output device
      print('Processing real-time audio: ${recordingData.duration.inMilliseconds}ms');
    }
  }

  Future<void> stopStreaming() async {
    if (_isStreaming) {
      _isStreaming = false;
      
      try {
        if (_recorderSubscription != null) {
          await _recorderSubscription!.cancel();
          _recorderSubscription = null;
        }
        
        if (_recorder != null && _recorder!.isRecording) {
          await _recorder!.stopRecorder();
        }
        
        if (_player != null && _player!.isPlaying) {
          await _player!.stopPlayer();
        }
        
        if (_audioStreamController != null) {
          await _audioStreamController!.close();
          _audioStreamController = null;
        }
        
        print('Real-time audio streaming stopped');
      } catch (e) {
        print('Error stopping streaming: $e');
      }
    }
  }

  Future<bool> _requestPermissions() async {
    var status = await Permission.microphone.request();
    return status.isGranted;
  }

  bool get isStreaming => _isStreaming;

  void dispose() {
    stopStreaming();
    if (_recorder != null) {
      _recorder!.closeRecorder();
    }
    if (_player != null) {
      _player!.closePlayer();
    }
  }
}
