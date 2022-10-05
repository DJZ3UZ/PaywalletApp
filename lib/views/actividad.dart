import 'package:flutter/material.dart';

class Actividad extends StatelessWidget {
  const Actividad({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: Text("Estás en Actividad",style: TextStyle(color: Colors.white),),
          ),
        )
    );
  }
}