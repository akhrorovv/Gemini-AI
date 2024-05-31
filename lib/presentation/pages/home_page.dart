import 'package:flutter/material.dart';
import 'package:gemini/data/repositories/gemini_talk_repository_impl.dart';
import 'package:gemini/domain/usecases/gemini_text_and_image_usecase.dart';
import 'package:gemini/domain/usecases/gemini_text_only_usecase.dart';

import '../../core/services/log_service.dart';
import '../../core/services/utils_service.dart';
import '../../data/datasources/remote/http_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  GeminiTextOnlyUseCase textOnlyUseCase = GeminiTextOnlyUseCase(GeminiTalkRepositoryImpl());
  GeminiTextAndImageUseCase textAndImageUseCase = GeminiTextAndImageUseCase(GeminiTalkRepositoryImpl());

  apiTextOnly() async {
    var text = "What is the best way to learn Flutter development?";
    var result = await textOnlyUseCase.call(text);
    LogService.d(result);
  }

  apiTextAndImage() async {
    var text = "What is this image?";
    var base64 = await Utils.pickAndConvertImage();

    var result = await textAndImageUseCase.call(text, base64);
    LogService.d(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Gemini"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              color: Colors.blue,
              onPressed: () {
                apiTextOnly();
              },
              child: const Text("Text Only Input"),
            ),
            MaterialButton(
              color: Colors.blue,
              onPressed: () {
                apiTextAndImage();
              },
              child: const Text("Text And Image Input"),
            ),
          ],
        ),
      ),
    );
  }
}
