import 'package:flutter/material.dart';

class Grupos extends StatelessWidget {
  const Grupos({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Color(0xff3a4d54),
          body: Center(
            child: Text("Estás en Grupos",style: TextStyle(color: Colors.white),),
          ),
        )
    );
  }
}