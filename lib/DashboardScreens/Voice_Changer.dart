// import 'package:flutter/material.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:microphone/microphone.dart';
//
//
// class SoundMaking extends StatefulWidget {
//   const SoundMaking({Key? key}) : super(key: key);
//
//   @override
//   _SoundMakingState createState() => _SoundMakingState();
// }
//
// class _SoundMakingState extends State<SoundMaking> {
//   AudioPlayer _audioPlayer = AudioPlayer();
//   MicrophoneRecorder _recorder = MicrophoneRecorder();
//   VoiceChanger _voiceChanger = VoiceChanger();
//
//   @override
//   void dispose() {
//     _audioPlayer.dispose();
//     _recorder.close();
//     _voiceChanger.close();
//     super.dispose();
//   }
//
//   Future<void> startRecording() async {
//     await _recorder.start();
//   }
//
//   Future<void> stopRecording() async {
//     final recording = await _recorder.stop();
//     await _audioPlayer.playBytes(recording.audioData);
//   }
//
//   Future<void> applyVoiceChange() async {
//     final recording = await _recorder.stop();
//
//     // Modify the voice using the voice changer
//     final modifiedRecording = await _voiceChanger.transform(
//       recording.audioData,
//       pitch: 2.0, // Change the pitch by a factor of 2
//       speed: 1.5, // Increase the speed by 50%
//     );
//
//     await _audioPlayer.playBytes(modifiedRecording);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Voice Changer App'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: startRecording,
//               child: Text('Start Recording'),
//             ),
//             ElevatedButton(
//               onPressed: stopRecording,
//               child: Text('Stop Recording and Play'),
//             ),
//             ElevatedButton(
//               onPressed: applyVoiceChange,
//               child: Text('Apply Voice Change'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
