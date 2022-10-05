import 'package:flutter/material.dart';

class Amigos extends StatelessWidget {
  const Amigos({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: Text("Estás en Amigos",style: TextStyle(color: Colors.white),),
          ),
        )
    );
  }
}