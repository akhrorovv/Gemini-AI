import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gemini/data/repositories/gemini_talk_repository_impl.dart';
import 'package:gemini/domain/usecases/gemini_text_and_image_usecase.dart';
import 'package:gemini/domain/usecases/gemini_text_only_usecase.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/services/log_service.dart';
import '../../core/services/utils_service.dart';

class HomePage extends StatefulWidget {
  static const String id = 'home_page';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GeminiTextOnlyUseCase textOnlyUseCase =
      GeminiTextOnlyUseCase(GeminiTalkRepositoryImpl());
  GeminiTextAndImageUseCase textAndImageUseCase =
      GeminiTextAndImageUseCase(GeminiTalkRepositoryImpl());

  final FocusNode _focusNode = FocusNode();
  TextEditingController textController = TextEditingController();
  String response = '';
  String base64 = '';
  final ImagePicker _picker = ImagePicker();
  File? _image;

  // _imgFromGallery() async {
  //   XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
  //   setState(() {
  //     _image = File(image!.path);
  //   });
  // }

  @override
  void dispose() {
    // Clean up the FocusNode when the widget is disposed
    _focusNode.dispose();
    super.dispose();
  }

  pickImage() async {
    XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      _image = File(image!.path);
    });
    base64 = await Utils.pickAndConvertImage();
    LogService.i('Image selected !!!');
  }

  apiTextOnly(String text) async {
    textController.clear();
    var result = await textOnlyUseCase.call(text);
    setState(() {
      response = result;
    });
    LogService.d(result);
  }

  apiTextAndImage(String text, String base64) async {
    textController.clear();
    var result = await textAndImageUseCase.call(text, base64);
    setState(() {
      _image = null;
      base64 = '';
      response = result;
    });

    LogService.d(result);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          onTap: () {
            // Dismiss the keyboard when tapping outside the TextField
            _focusNode.unfocus();
          },
          child: Container(
            padding: const EdgeInsets.only(bottom: 20, top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(
                  height: 45,
                  child: Image(
                    image: AssetImage('assets/images/gemini_logo.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(15),
                    child: response.isEmpty
                        ? Center(
                            child: SizedBox(
                              height: 100,
                              width: 100,
                              child:
                                  Image.asset('assets/images/gemini_icon.png'),
                            ),
                          )
                        : ListView(
                            children: [
                              Text(
                                response,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              )
                            ],
                          ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 20, left: 20),
                  padding: const EdgeInsets.only(left: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.grey, width: 2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _image == null
                          ? SizedBox.shrink()
                          : Container(
                              margin: EdgeInsets.only(top: 15),
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                // color: Colors.blue,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.white),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  _image!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: textController,
                              maxLines: null,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Message',
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                              onChanged: (String text) {
                                setState(
                                    () {}); // Trigger a rebuild to update the UI
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Add some space between TextField and Icons
                          if (textController
                              .text.isEmpty) // Show icons only if text is empty
                            IconButton(
                              onPressed: () async {
                                pickImage();
                              },
                              icon: const Icon(
                                Icons.attach_file,
                                color: Colors.grey,
                              ),
                            ),
                          if (textController
                              .text.isEmpty) // Show icons only if text is empty
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.mic,
                                color: Colors.grey,
                              ),
                            ),
                          IconButton(
                            onPressed: () {
                              if (base64 != '') {
                                apiTextAndImage(textController.text, base64);
                              } else {
                                apiTextOnly(textController.text);
                              }
                              _focusNode.unfocus();
                            },
                            icon: const Icon(
                              Icons.send,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
