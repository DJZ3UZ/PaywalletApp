import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paywallet_app/models/models.dart';
import 'package:paywallet_app/views/amigos.dart';

class GruposPage extends StatefulWidget {
  const GruposPage({Key? key}) : super(key: key);

  @override
  State<GruposPage> createState() => _GruposPageState();
}

class _GruposPageState extends State<GruposPage> {
  final user = FirebaseAuth.instance.currentUser!;
  final String uid = FirebaseAuth.instance.currentUser!.uid.toString();
  List<String> friendIDs = [];
  List<Usuario> usuariosGrupo=[];
  bool isChecked = false;
  int index=0;
  List<String> numero=[];
  int selectedIndex=-1;

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

  Stream<List<Usuario>> leerAmigos() =>
      amigosRef.doc(uid).collection('agregado').snapshots().map((snapshot) =>
          snapshot.docs.map((doc) => Usuario.fromJson(doc.data())).toList());

  final _styleBotones = ElevatedButton.styleFrom(
      backgroundColor: Color(0xff202f36),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 10,
      shadowColor: Colors.black12,
    textStyle: TextStyle(fontSize: 16)
  );

  @override
  void initState() {
    getAmigos();
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
                                "Crear Grupo",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                        ),
                      ],
                    ),
                  ),
                  friendIDs.isEmpty
                      ? const Text("")
                  : Padding(
                    padding: const EdgeInsets.only(left: 25,right: 25,top: 10,bottom: 30),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Nombre del grupo',
                            hintStyle: TextStyle(color: Colors.grey[600]),
                          ),
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
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
                    child: StreamBuilder<List<Usuario>>(
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
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: ElevatedButton(
                      style: _styleBotones,
                        onPressed: (){

                        },
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text("Crear"),
                        )),
                  )
                ]
            )
        )
    );
  }

  Widget buildUser(Usuario usuario) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Stack(children: [
          ListTile(
            selected: isChecked,
            selectedColor: Colors.white10,
            //tileColor: selectedIndex==index? Colors.white10 : Colors.transparent,
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
            onTap: (){
              setState(() {
                isChecked=!isChecked;
              });
            },
          ),
        ]));
  }

  obtenerUsuario(Usuario usuario){
    usuariosGrupo.add(usuario);
    setState(() {
      print(usuariosGrupo.toString());
    });
    return usuario;
  }
  quitarUsuarioLista(Usuario usuario){
    usuariosGrupo.removeWhere((element) => element.id==usuario.id);
    setState(() {
      print(usuariosGrupo.toString());
    });
  }
}
