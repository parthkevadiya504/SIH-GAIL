import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ssip2025/pages/splashscreen.dart';


Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
