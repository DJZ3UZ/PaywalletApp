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
  List<String> solIDs = [];

  Future getSolId() async {
    await solisRef
        .doc(uid)
        .collection('solicitado')
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
              print(document.reference);
              solIDs.add(document.reference.id);
              setState(() {
                print(solIDs.toString());
              });
            }));
  }

  //Para leer todos los usuarios
  Stream<List<Usuario>> leerSolicitudes() => solisRef
      .doc(uid)
      .collection('solicitado')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Usuario.fromJson(doc.data())).toList());

  @override
  void initState() {
    getSolId();
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
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Color(0xff202f36),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 28,
                          ),
                      ),
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
            solIDs.isEmpty
                ? const Expanded(
                    child: Center(
                        child: Text(
                    "No tienes solicitudes",
                    style: TextStyle(fontSize: 18),
                  )))
                : Expanded(
                    child: StreamBuilder<List<Usuario>>(
                      stream: leerSolicitudes(),
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
        ),
      ),
    );
  }

  Widget buildUser(Usuario usuario) {
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
              right: 60,
              child:
              GestureDetector(
                  onTap: () async {
                    Usuario currentUsuario = Usuario(nombre: "", apellido: "", usuario: "", email: "");
                    final docUser = FirebaseFirestore.instance.collection('usuarios/').doc(uid);
                    final snapshot = await docUser.get();
                    if (snapshot.exists) {
                      currentUsuario = Usuario.fromJson(snapshot.data()!);
                    }
                    aceptarAmistad(Usuario currentUsuario){
                      amigosRef.doc(uid).collection('agregado').doc(usuario.id).set(
                          {
                            "id": usuario.id,
                            "nombre": usuario.nombre,
                            "apellido": usuario.apellido,
                            "usuario": usuario.usuario,
                            "imagen": usuario.imagen,
                            "email": usuario.email
                          });
                      amigosRef.doc(usuario.id).collection('agregado').doc(uid).set(
                          {
                            "id": currentUsuario.id,
                            "nombre": currentUsuario.nombre,
                            "apellido": currentUsuario.apellido,
                            "usuario": currentUsuario.usuario,
                            "imagen": currentUsuario.imagen,
                            "email": currentUsuario.email
                          });
                      solisRef.doc(uid).collection('solicitado').doc(usuario.id).delete();
                    }
                    aceptarAmistad(currentUsuario);
                    solIDs.removeWhere((element) => element == usuario.id);
                    setState(() {
                      getSolId();
                    });
                  },
                  child: Icon(Icons.check, color: Colors.green)
              )
          ),
          Positioned(
              top: 25,
              right: 20,
              child:
              GestureDetector(
                  onTap: (){
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Color(0xff3a4d54),
                          title: Text(
                            '¿Seguro que deseas eliminar esta solicitud?',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          actions: [
                            //Eliminar
                            TextButton(
                                onPressed: () async {
                                  eliminarSolicitud(){
                                    solisRef.doc(uid).collection('solicitado').doc(usuario.id).delete();
                                  }
                                  eliminarSolicitud();
                                  solIDs.removeWhere((element) => element == usuario.id);
                                  setState(() {
                                    getSolId();
                                  });
                                  Navigator.pop(context);
                                },
                                child: Text("Eliminar",style: TextStyle(color: Colors.red),)),
                            //Cancelar
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("Cancelar")),
                          ],
                        ));
                  },
                  child: Icon(Icons.delete, color: Colors.red)
              )
          ),
        ]));
  }
}
