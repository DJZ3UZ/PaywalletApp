import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paywallet_app/pages/amigos_page.dart';

class Amigos extends StatefulWidget {
  const Amigos({super.key});

  @override
  State<Amigos> createState() => _AmigosState();
}

class _AmigosState extends State<Amigos> {
  final user = FirebaseAuth.instance.currentUser!;
  final String uid = FirebaseAuth.instance.currentUser!.uid.toString();
  List<String> solIDs = [];

  Future getSolicitudes() async {
    await FirebaseFirestore.instance.collection('solicitudes/').doc(uid).collection('solicitado').get().then(
            (snapshot) =>
            snapshot.docs.forEach((document) {
              print(document.reference);
              solIDs.add(document.reference.id);
              setState(() {
                print(solIDs);
              });
            }));
  }

  @override
  void initState() {
    getSolicitudes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Color(0xff3a4d54),
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Amigos",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                          Stack(
                              alignment: Alignment.topRight,
                              children: [
                                Container(
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Color(0xff202f36),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AmigosPage()));
                                        },
                                        child: const Icon(
                                          Icons.person_add,
                                          color: Colors.white,
                                          size: 28,
                                        )
                                    ),
                                  ),
                                ),
                                CircleAvatar(
                                  backgroundColor: solIDs.isEmpty? Colors.transparent : Colors.red,
                                  maxRadius: 5,
                                ),
                              ]),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
        ));
  }
}