import 'package:flutter/material.dart';

const heightImage = 90.0;

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final width = 20;
  final height = 50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 1.0, end: 2.0),
              curve: Curves.bounceIn,
              duration: const Duration(milliseconds: 3000),
              child: const Image(
                height: heightImage,
                image: AssetImage('assets/logo/VacunApp3.png'),
              ),
              builder: (BuildContext context, double value, child) {
                return Transform.scale(
                  // origin: Offset(0.0, 1.0),
                  scale: value,
                  child: child,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
