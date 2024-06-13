import 'package:flutter/cupertino.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:gemini/core/services/auth_service.dart';
import 'package:gemini/core/services/log_service.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../pages/home_page.dart';

class StarterController extends GetxController {
  late VideoPlayerController videoPlayerController;
  FlutterTts flutterTts = FlutterTts();

  initVideoPlayer() {
    videoPlayerController =
        VideoPlayerController.asset("assets/videos/gemini_video.mp4")
          ..initialize().then((_) {
            update();
          });

    videoPlayerController.play();
    videoPlayerController.setLooping(true);
  }

  callHomePage(BuildContext context){
    Navigator.pushReplacementNamed(context, HomePage.id);
  }

  callGoogleSignIn()async{
    var result = await AuthService.signInWithGoogle();
    LogService.i(result);
  }

  stopVideoPlayer() {
    videoPlayerController.dispose();
  }

  Future speakTTS(String text) async {
    var result = await flutterTts.speak(text);
    // if (result == 1) setState(() => ttsState = TtsState.playing);
  }

  Future stopTTS() async {
    var result = await flutterTts.stop();
    // if (result == 1) setState(() => ttsState = TtsState.stopped);
  }
}
