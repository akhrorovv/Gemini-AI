import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gemini/presentation/pages/home_page.dart';
import 'package:gemini/presentation/pages/starter_page.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'core/config/root_binding.dart';
import 'data/models/message_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: 'AIzaSyC6uuKlftNS9Q1IztfzqHX2A_RGUmc6-wg',
        appId: '1:877105179774:android:e5c65ab9045828c7587c2f',
        messagingSenderId: '877105179774',
        projectId: 'gemini-ai-1d3ee',
      )
  );

  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive
    ..init(appDocumentDirectory.path)
    ..registerAdapter(MessageModelAdapter());
  await Hive.openBox("my_nosql");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const StarterPage(),
      routes: {
        HomePage.id: (context) => HomePage(),
        StarterPage.id: (context) => StarterPage(),
      },
      initialBinding: RootBinding(),
    );
  }
}
