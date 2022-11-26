import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paywallet_app/models/models.dart';
import 'package:paywallet_app/pages/amigos_page.dart';

final amigosRef = FirebaseFirestore.instance.collection('amigos');
final solisRef = FirebaseFirestore.instance.collection('solicitudes');

class Amigos extends StatefulWidget {
  const Amigos({super.key});

  @override
  State<Amigos> createState() => _AmigosState();
}

class _AmigosState extends State<Amigos> {
  final user = FirebaseAuth.instance.currentUser!;
  final String uid = FirebaseAuth.instance.currentUser!.uid.toString();
  List<String> solIDs = [];
  List<String> friendIDs = [];

  Future getSolicitudes() async {
    await solisRef
        .doc(uid)
        .collection('solicitado')
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
              print(document.reference);
              solIDs.add(document.reference.id);
              setState(() {
                print(solIDs);
              });
            }));
  }

  Future getAmigos() async {
    await amigosRef
        .doc(uid)
        .collection('agregado')
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
              print(document.reference);
              friendIDs.add(document.reference.id);
              setState(() {
                print(friendIDs.toString());
              });
            }));
  }

  Stream<List<Ahorro>> leerAmigos() =>
      amigosRef.doc(uid).collection('agregado').snapshots().map((snapshot) =>
          snapshot.docs.map((doc) => Ahorro.fromJson(doc.data())).toList());

  @override
  void initState() {
    getSolicitudes();
    getAmigos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: Scaffold(
          backgroundColor: Color(0xff3a4d54),
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Container(
                child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                      Stack(alignment: Alignment.topRight, children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => AmigosPage()));
                          },
                          child: Container(
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Color(0xff202f36),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.person_add,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor:
                              solIDs.isEmpty ? Colors.transparent : Colors.red,
                          maxRadius: 5,
                        ),
                      ]),
                    ],
                  ),
                ),
                friendIDs.isEmpty
                    ? const Expanded(
                        child: Center(
                            child: Text(
                        "Aún no tienes ningún amigo",
                        style: TextStyle(fontSize: 18),
                      )))
                    : Expanded(
                        child: StreamBuilder<List<Ahorro>>(
                          stream: leerAmigos(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final users = snapshot.data!;
                              return ListView(
                                children: users.map(buildUser).toList(),
                              );
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        ),
                      )
              ],
            )),
          ),
        ));
  }

  Widget buildUser(Ahorro usuario) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Stack(children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xff202f36),
              backgroundImage: usuario.imagen.isEmpty
                  ? null
                  : NetworkImage(usuario.imagen.toString()),
              child: usuario.imagen.isEmpty
                  ? Text(
                      usuario.nombre.substring(0, 1) +
                          usuario.apellido.substring(0, 1),
                      style: TextStyle(color: Colors.white),
                    )
                  : null,
            ),
            title: Text("${usuario.nombre} ${usuario.apellido}"),
            subtitle: Text(usuario.email.toString()),
          ),
          Positioned(
              top: 25,
              right: 20,
              child: GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              backgroundColor: Color(0xff3a4d54),
                              title: Text(
                                '¿Seguro que deseas eliminar a este usuario de tu lista de amigos?',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              actions: [
                                //Eliminar
                                TextButton(
                                    onPressed: () async {
                                      eliminarAmigo() {
                                        amigosRef
                                            .doc(uid)
                                            .collection('agregado')
                                            .doc(usuario.id)
                                            .delete();
                                        amigosRef
                                            .doc(usuario.id)
                                            .collection('agregado')
                                            .doc(uid)
                                            .delete();
                                      }

                                      eliminarAmigo();
                                      friendIDs.removeWhere(
                                          (element) => element == usuario.id);
                                      setState(() {
                                        getAmigos();
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "Eliminar",
                                      style: TextStyle(color: Colors.red),
                                    )),
                                //Cancelar
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Cancelar")),
                              ],
                            ));
                  },
                  child: Icon(Icons.delete, color: Colors.red))),
        ]));
  }
}
