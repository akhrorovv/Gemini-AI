import 'package:flutter/material.dart';
import 'package:gemini/presentation/pages/home_page.dart';
import 'package:page_transition/page_transition.dart';
import 'package:video_player/video_player.dart';

class StarterPage extends StatefulWidget {
  const StarterPage({super.key});

  @override
  State<StarterPage> createState() => _StarterPageState();
}

class _StarterPageState extends State<StarterPage> {
  late VideoPlayerController videoPlayerController;

  @override
  void initState() {
    super.initState();
    videoPlayerController =
        VideoPlayerController.asset("assets/videos/gemini_video.mp4")
          ..initialize().then((_) {
            setState(() {});
          });

    videoPlayerController.play();
    videoPlayerController.setLooping(true);
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  Route _createRoute(Widget child) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            children: [
              Container(
                child: const Image(
                  width: 150,
                  image: AssetImage('assets/images/gemini_logo.png'),
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: videoPlayerController.value.isInitialized
                    ? VideoPlayer(videoPlayerController)
                    : Container(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, HomePage.id);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 2),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Chat with Gemini ',
                            style: TextStyle(
                                color: Colors.grey[400], fontSize: 18),
                          ),
                          const Icon(
                            Icons.arrow_forward,
                            color: Colors.grey,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
