import 'package:flutter/material.dart';
import 'package:gemini/data/repositories/gemini_talk_repository_impl.dart';
import 'package:gemini/domain/usecases/gemini_text_and_image_usecase.dart';
import 'package:gemini/domain/usecases/gemini_text_only_usecase.dart';

import '../../core/constants/constants.dart';
import '../../core/services/log_service.dart';
import '../../core/services/utils_service.dart';
import '../../data/models/message_model.dart';
import '../widgets/item_gemini_message.dart';
import '../widgets/item_user_message.dart';

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

  TextEditingController textController = TextEditingController();
  final FocusNode textFieldFocusNode = FocusNode();
  final ScrollController scrollController = ScrollController();

  List<MessageModel> messages = [
    MessageModel(
        isMine: true,
        message:
            'How to learn Flutter? How to learn Flutter?How to learn Flutter?efwefewfewfewfff'),
    MessageModel(
        isMine: false,
        message:
            'In Flutter, the BorderRadius.only constructor is used to apply rounded corners to specific edges of a widget. It provides more granular control compared to other BorderRadius constructors that set a uniform radius for all corners'),
    MessageModel(
        isMine: true, message: 'What is this picture?', base64: testImage),
    MessageModel(
        isMine: false,
        message:
            "In Flutter, the BorderRadius.only constructor is used to apply rounded corners to specific edges of a widget. It provides more granular control compared to other BorderRadius constructors that set a uniform radius for all cornersIn Flutter, the BorderRadius.only constructor is used to apply rounded corners to specific edges of a widget. It provides more granular control compared to other BorderRadius constructors that set a uniform radius for all corners")
  ];

  apiTextOnly() async {
    var text = "What is the best way to learn Flutter development?";
    var either = await textOnlyUseCase.call(text);
    either.fold((l) {
      LogService.d(l);
    }, (r) async {
      LogService.d(r);
    });
  }

  apiTextAndImage() async {
    var text = "What is this image?";
    var base64 = await Utils.pickAndConvertImage();

    var either = await textAndImageUseCase.call(text, base64);
    either.fold((l) {
      LogService.d(l);
    }, (r) async {
      LogService.d(r);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    apiTextOnly();

    textFieldFocusNode.addListener(() {
      if (textFieldFocusNode.hasFocus) {
        scrollToBottom();
      }
    });
  }

  @override
  void dispose() {
    textController.dispose();
    scrollController.dispose();
    textFieldFocusNode.dispose();
    super.dispose();
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
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
                  child: messages.isEmpty
                      ? Center(
                          child: SizedBox(
                            height: 100,
                            width: 100,
                            child: Image.asset('assets/images/gemini_icon.png'),
                          ),
                        )
                      : ListView.builder(
                          controller: scrollController,
                          itemCount: messages.length,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            var message = messages[index];
                            if (message.isMine!) {
                              return itemOfUserMessage(message);
                            } else {
                              return itemOfGeminiMessage(message);
                            }
                          },
                        ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 20, left: 20),
                padding: const EdgeInsets.only(left: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.grey, width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: textController,
                            focusNode: textFieldFocusNode,
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
                            onPressed: () {},
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
                            scrollToBottom();
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
    );
  }
}
