import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paywallet_app/models/models.dart';

final amigosRef = FirebaseFirestore.instance.collection('amigos');
final solisRef = FirebaseFirestore.instance.collection('solicitudes');

class SolicitudesPage extends StatefulWidget {
  const SolicitudesPage({Key? key}) : super(key: key);

  @override
  State<SolicitudesPage> createState() => _SolicitudesPageState();
}

class _SolicitudesPageState extends State<SolicitudesPage> {
  final user = FirebaseAuth.instance.currentUser!;
  final String uid = FirebaseAuth.instance.currentUser!.uid.toString();
  List<String> docIDs = [];

  Future getDocId() async {
    await FirebaseFirestore.instance.collection('solicitudes').doc(uid).collection('solicitado').get().then(
            (snapshot) =>
            snapshot.docs.forEach((document) {
              print(document.reference);
              docIDs.add(document.reference.id);
              setState(() {
                print(docIDs.toString());
              });
            }));
  }

  //Para leer todos los usuarios
  Stream<List<Usuario>> leerUsuarios() => FirebaseFirestore.instance
      .collection('usuarios/')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Usuario.fromJson(doc.data())).toList());

  @override
  void initState() {
    getDocId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xff3a4d54),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0xff202f36),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 28,
                          )),
                    ),
                  ),
                  const Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "Solicitudes",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                ],
              ),
            ),
            docIDs.isEmpty
                ? const Expanded(
                    child: Center(
                        child: Text(
                    "No tienes solicitudes",
                    style: TextStyle(fontSize: 18),
                  )))
                : Expanded(
                    child: StreamBuilder<List<Usuario>>(
                      stream: leerUsuarios(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final users = snapshot.data!;
                          return ListView(
                            children:  users.map(buildUser).toList(),
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
        ),
      ),
    );
  }

  Widget buildUser(Usuario usuario) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: usuario.id == leerDocIDs(usuario).toString()
            ? ListTile(
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
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            backgroundColor: Color(0xff3a4d54),
                            title: Text(
                              '¿Deseas enviar una solicitud de amistad?',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            actions: [
                              //Salir
                              TextButton(
                                  onPressed: () {
                                    solicitarAmistad() {
                                      solisRef
                                          .doc(usuario.id)
                                          .collection('solicitado')
                                          .doc(uid)
                                          .set({});
                                    }

                                    solicitarAmistad();
                                    Navigator.pop(context);
                                  },
                                  child: Text("Enviar")),
                              //Cancelar
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Cancelar")),
                            ],
                          ));
                },
              )
            : null
    );
  }
  leerDocIDs(Usuario usuario){
    for (var element in docIDs) {
      if(usuario.id == element){
        return usuario.id;
      } else{
        return null;
      }
    }
  }
}
