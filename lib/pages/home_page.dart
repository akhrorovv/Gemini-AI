import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gemini/services/http_service.dart';
import 'package:gemini/services/log_service.dart';
import 'package:gemini/services/utils_service.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ImagePicker picker = ImagePicker();
  File? imageFile;

  imgFromGallery() async {
    XFile? image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    imageFile = File(image!.path);
    String? base64 = await convertFileToBase64(imageFile!);
    LogService.d(base64!);
    _onTextAndImageInput('What is this picture?', base64);
  }

  _onTextOnlyInput(String text) async {
    var response = await Network.POST(
        Network.API_TEXT_ONLY_INPUT, Network.paramsTextOnly(text));
    LogService.d(response!);
  }

  _onTextAndImageInput(String text, String base64) async {
    var response = await Network.POST(
        Network.API_TEXT_AND_IMAGE, Network.paramsTextAndImage(text, base64));
    LogService.d(response!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        centerTitle: true,
        title: Text('Gemini AI'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _onTextOnlyInput('How to learn Flutter?');
              },
              child: Text('Text'),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                imgFromGallery();
              },
              child: Text('Text + Image'),
            ),
          ],
        ),
      ),
    );
  }
}
