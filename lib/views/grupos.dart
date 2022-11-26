import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paywallet_app/models/models.dart';
import 'package:paywallet_app/pages/grupos_page.dart';

final gruposRef = FirebaseFirestore.instance.collection('grupos');

class Grupos extends StatefulWidget {
  const Grupos({super.key});

  @override
  State<Grupos> createState() => _GruposState();
}

class _GruposState extends State<Grupos> {
  final user = FirebaseAuth.instance.currentUser!;
  final String uid = FirebaseAuth.instance.currentUser!.uid.toString();
  List<String> grupIDs = [];

  Future getGrupos() async {
    await gruposRef
        .doc(uid)
        .collection('miembros')
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
      print(document.reference);
      grupIDs.add(document.reference.id);
      setState(() {
        print(grupIDs.toString());
      });
    }));
  }

  Stream<List<Ahorro>> leerGrupos() =>
      gruposRef.doc(uid).collection('miembros').snapshots().map((snapshot) =>
          snapshot.docs.map((doc) => Ahorro.fromJson(doc.data())).toList());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: Scaffold(
            backgroundColor: Color(0xff3a4d54),
            resizeToAvoidBottomInset: false,
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: FloatingActionButton.extended(
                  label: const Text('Crear nuevo grupo',style: TextStyle(color: Colors.white),),
                  backgroundColor: Color(0xff202f36).withOpacity(0.9),
                  elevation: 10,
                  icon: Icon(Icons.group_add_outlined,color: Colors.white,),
                  onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (builder)=>GruposPage()));
                  }
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            body: SafeArea(
                child: Container(
                    child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Grupos",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          grupIDs.isEmpty
                              ? const Expanded(
                              child: Center(
                                  child: Text(
                                    "Aún no tienes ningún grupo",
                                    style: TextStyle(fontSize: 18),
                                  )))
                              : Expanded(
                            child: StreamBuilder<List<Ahorro>>(
                              stream: leerGrupos(),
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
                        ]
                    )
                )
            )
        )
    );
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
        ]));
  }
}
