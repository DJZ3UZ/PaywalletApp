import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:paywallet_app/autenticacion/autenticacion.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Paywallet',
      home: Scaffold(
        body: AnimatedSplashScreen(
          backgroundColor: Colors.black,
            splash: Image.asset('assets/images/logo_con_letras.png'),
            nextScreen: MainPage(),
          splashIconSize: 250,
          duration: 1000,
          splashTransition: SplashTransition.slideTransition,
          pageTransitionType: PageTransitionType.bottomToTop,
        ),
      ),
    );
  }
}