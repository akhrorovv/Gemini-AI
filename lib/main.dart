import 'package:flutter/material.dart';
import 'package:gemini/presentation/pages/home_page.dart';
import 'package:gemini/presentation/pages/starter_page.dart';
import 'package:get/get.dart';

import 'core/config/root_binding.dart';

void main() {
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
        'home_page': (context) => HomePage(),
      },
      initialBinding: RootBinding(),
      onGenerateRoute: (settings) {
        if (settings.name == 'home_page') {
          return PageRouteBuilder(
            settings: settings,
            pageBuilder: (context, animation, secondaryAnimation) => HomePage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;

              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          );
        }
        return null;
      },
    );
  }
}
