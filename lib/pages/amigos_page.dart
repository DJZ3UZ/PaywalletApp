import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paywallet_app/models/models.dart';
import 'package:paywallet_app/pages/solicitudes_page.dart';

final amigosRef = FirebaseFirestore.instance.collection('amigos');
final solisRef = FirebaseFirestore.instance.collection('solicitudes');

class AmigosPage extends StatefulWidget {
  const AmigosPage({Key? key}) : super(key: key);

  @override
  State<AmigosPage> createState() => _AmigosPageState();
}

class _AmigosPageState extends State<AmigosPage> {
  final user = FirebaseAuth.instance.currentUser!;
  final String uid = FirebaseAuth.instance.currentUser!.uid.toString();
  String nombre = "";
  String retorno = "";
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

  //Para leer todos los usuarios
  Stream<List<Usuario>> leerUsuarios() => FirebaseFirestore.instance
      .collection('usuarios/')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Usuario.fromJson(doc.data())).toList());

  //Para buscar un usuario con un nombre especifico
  Stream<List<Usuario>> buscarUsuarios() => FirebaseFirestore.instance
      .collection('usuarios/')
      .snapshots()
      .map((snapshot) => snapshot.docs
              .map((doc) => Usuario.fromJson(doc.data()))
              .where((name) {
            if (name.nombre.toString().toLowerCase() !=
                nombre.toString().toLowerCase()) {
              name.apellido.toString().toLowerCase() ==
                  nombre.toString().toLowerCase();
              retorno = name.apellido.toString().toLowerCase();
            } else if (name.apellido.toString().toLowerCase() !=
                nombre.toString().toLowerCase()) {
              retorno = name.nombre.toString().toLowerCase();
            }
            return retorno == nombre.toString().toLowerCase();
          }).toList());

  @override
  void initState() {
    getSolicitudes();
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
                          "Usuarios",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                  Align(
                    alignment: Alignment.topRight,
                    child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Container(
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                              decoration: BoxDecoration(
                                color: Color(0xff202f36),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SolicitudesPage()));
                                  },
                                  child: const Text(
                                      'Solicitudes',
                                      style: TextStyle(
                                        fontSize: 12
                                      ),
                                  )
                              ),
                            ),
                          ),
                          CircleAvatar(
                            backgroundColor: solIDs.isEmpty? Colors.transparent : Colors.red,
                            maxRadius: 5,
                          ),
                        ]),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25,top: 5,bottom: 20),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12)),
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Buscar...',
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                  ),
                  style: TextStyle(color: Colors.black),
                  onChanged: (val) {
                    setState(() {
                      nombre = val;
                    });
                  },
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<List<Usuario>>(
                stream: nombre.isEmpty ? leerUsuarios() : buscarUsuarios(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final users = snapshot.data!;
                    return ListView(
                      children: users.map(buildUser).toList(),
                    );
                  } else {
                    return Center(
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
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xff202f36),
          backgroundImage: usuario.imagen.isEmpty? null : NetworkImage(usuario.imagen.toString()),
          child: usuario.imagen.isEmpty? Text(
            usuario.nombre.substring(0, 1) + usuario.apellido.substring(0, 1),
            style: TextStyle(color: Colors.white),
          ) : null,
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
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    actions: [
                      //Salir
                      TextButton(
                          onPressed: () {
                            solicitarAmistad(){
                              solisRef.doc(usuario.id).collection('solicitado').doc(uid).set(
                                  {});
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
      ),
    );
  }


}
