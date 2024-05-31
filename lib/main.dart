import 'package:flutter/material.dart';
import 'package:gemini/presentation/pages/home_page.dart';
import 'package:gemini/presentation/pages/starter_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const StarterPage(),
      routes: {
        HomePage.id: (context) => HomePage(),
      },
    );
  }
}
