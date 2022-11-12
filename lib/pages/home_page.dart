import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paywallet_app/models/models.dart';
import 'package:paywallet_app/views/views.dart';

class HomePage extends StatefulWidget{
  const HomePage({Key? key}): super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  final navigationKey = GlobalKey<CurvedNavigationBarState>();
  int index = 0;
  final screens =[
    Grupos(),
    Amigos(),
    Actividad(),
    Cuenta()
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    final items =<Widget>[
      Icon(
        Icons.group,
        color: Colors.white,
      ),
      Icon(
        Icons.person,
        color: Colors.white,
      ),
      Icon(
        Icons.add_task_outlined,
        color: Colors.white,
      ),
      Icon(
        Icons.account_circle,
        color: Colors.white,
      )
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      title: 'Paywallet',
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBody: true,
        body: screens[index],
        bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(iconTheme: IconThemeData(color: Colors.white)),
            child: CurvedNavigationBar(
              backgroundColor: Colors.transparent,
              height: 50,
              key: navigationKey,
              color: Color(0xff202f36),
              index: index,
              items: items,
              onTap: (index) => setState(()=>this.index = index),
              animationDuration: Duration(milliseconds: 350),
            )
        ),
      ),
    );
  }
}