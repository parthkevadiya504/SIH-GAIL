
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import 'login.dart';

class SplashScreen extends StatefulWidget {




  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () async {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const LoginScreen()));
    }

    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Container(
            height: 200,
            width: 300,
            child: Image.asset('assets/images/Gail_logo.png'),
          ),
        ),
      ),
    );
  }
}
