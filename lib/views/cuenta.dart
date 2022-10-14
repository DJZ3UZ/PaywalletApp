import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paywallet_app/leer_data/get_nombre_usuario.dart';

class Cuenta extends StatefulWidget {
  const Cuenta({Key? key}) : super(key: key);

  @override
  State<Cuenta> createState() => _Cuenta();
}

class _Cuenta extends State<Cuenta> {

  final user = FirebaseAuth.instance.currentUser!;

  // document IDs
  List<String> docIDs = [];

  // get docIDs
  Future getDocId() async {
    await FirebaseFirestore.instance.collection('usuarios').get().then(
            (snapshot) =>
            snapshot.docs.forEach((document) {
              print(document.reference);
              docIDs.add(document.reference.id);
            }));
  }

  @override
  Widget build(BuildContext context) {
    final _styleBotones = ElevatedButton.styleFrom(
        primary: Color(0xff202f36),
        onPrimary: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 10,
        shadowColor: Colors.black12
    );

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: Scaffold(
          backgroundColor: Color(0xff3a4d54),
          body: Container(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0xff202f36),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) =>
                                    AlertDialog(
                                      backgroundColor: Color(0xff3a4d54),
                                      title: Text(
                                        '¿Seguro que deseas cerrar sesión?',
                                        style: TextStyle(color: Colors.white,
                                            fontSize: 18),),
                                      actions: [
                                        //Salir
                                        TextButton(
                                            onPressed: () {
                                              FirebaseAuth.instance.signOut();
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("Salir")),
                                        //Cancelar
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("Cancelar")),
                                      ],
                                    )
                            );
                          },
                          child: Icon(
                            Icons.logout, color: Colors.white, size: 28,)
                      ),
                    ),
                  ),
                ),
                Text("Hola ${user.email} estás en tu cuenta"),
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                      child: FutureBuilder(
                          future: getDocId(),
                          builder: (context, snapshot) {
                            return ListView.builder(
                                itemCount: docIDs.length,
                                itemBuilder: (context, index) {
                                  return ListTile(title: GetNombreUsuario(documentId: docIDs[index]));
                                }
                                );
                          }
                          ),
                    )
                ),
              ],
            ),
          ),
        )
    );
  }
}