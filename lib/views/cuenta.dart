import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paywallet_app/models/users.dart';

final usersRef = FirebaseFirestore.instance.collection('usuarios');

class Cuenta extends StatefulWidget {
  const Cuenta({Key? key}) : super(key: key);

  @override
  State<Cuenta> createState() => _Cuenta();
}

class _Cuenta extends State<Cuenta> {
  final user = FirebaseAuth.instance.currentUser!;
  final String uid = FirebaseAuth.instance.currentUser!.uid.toString();

  //Para leer todos los usuarios
  Stream<List<Usuario>> leerUsuarios() => FirebaseFirestore.instance
      .collection('usuarios')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Usuario.fromJson(doc.data())).toList());

  //Para leer solo mi usuario
  Future<Usuario?> leerUsuario() async {
    //Get document by ID
    final docUser =
        FirebaseFirestore.instance.collection('usuarios').doc(uid);
    final snapshot = await docUser.get();
    if (snapshot.exists) {
      return Usuario.fromJson(snapshot.data()!);
    }
  }
  
  Future volverAutenticar() async{
    String pass = _contrasenacontroller.text.trim();
    await user.reauthenticateWithCredential(
        EmailAuthProvider.credential(email: '${user.email}',password: pass)
    );
    user.delete();
  }

  final _nombrecontroller = TextEditingController();
  final _apellidocontroller = TextEditingController();
  final _usuariocontroller = TextEditingController();
  final _contrasenacontroller = TextEditingController();

  void dispose() {
    _nombrecontroller.dispose();
    _apellidocontroller.dispose();
    _usuariocontroller.dispose();
    _contrasenacontroller.dispose();
    super.dispose();
  }
  /*// document IDs
  List<String> docIDs = [];

  // get docIDs
  Future getDocId() async {
    await FirebaseFirestore.instance.collection('usuarios').get().then(
            (snapshot) =>
            snapshot.docs.forEach((document) {
              print(document.reference);
              docIDs.add(document.reference.id);
            }));
  }*/

  @override
  Widget build(BuildContext context) {
    final _styleBotones = ElevatedButton.styleFrom(
        primary: Color(0xff202f36),
        onPrimary: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 10,
        shadowColor: Colors.black12);

    final _styleBotonEliminar = ElevatedButton.styleFrom(
        backgroundColor: Color(0xffff6767),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 10,
        shadowColor: Colors.black12);

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Color(0xff3a4d54),
          body: SingleChildScrollView(
            child: Container(
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
                                  builder: (context) => AlertDialog(
                                        backgroundColor: Color(0xff3a4d54),
                                        title: Text(
                                          '¿Seguro que deseas cerrar sesión?',
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 18),
                                        ),
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
                                      ));
                            },
                            child: Icon(
                              Icons.logout,
                              color: Colors.white,
                              size: 28,
                            )),
                      ),
                    ),
                  ),
                  Container(
                      child: Padding(
                        padding:const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                        //Para leer solo mi usuario
                          child: FutureBuilder<Usuario?>(
                              future: leerUsuario(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Text('Algo está mal...${snapshot.error}');
                                } else if (snapshot.hasData) {
                                  final usuario = snapshot.data;
                                  return usuario == null
                                      ? Center(child: Text('No hay usuario'))
                                      : buildUsuario(usuario);
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              }),
                    //Para leer todos los usuarios
                    /*child: StreamBuilder<List<Usuario>>(
                          stream: leerUsuarios(),
                          builder: (context, snapshot){
                            if(snapshot.hasData){
                              final users = snapshot.data!;
                              return ListView(
                                children: users.map(buildUsuario).toList(),
                              );
                            } else{
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        ),*/
                      )
                  ),
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          height: 45,
                          width: 140,
                          child: ElevatedButton(
                            style: _styleBotones,
                              onPressed: (){
                              if(_nombrecontroller.text!='') {
                                final docUser = FirebaseFirestore.instance
                                    .collection('usuarios').doc(uid);
                                //Actualizar campos específicos
                                docUser.update({
                                  'nombre': _nombrecontroller.text.trim(),
                                });
                              }else{
                              }
                              if(_apellidocontroller.text!=''){
                                final docUser = FirebaseFirestore.instance
                                    .collection('usuarios').doc(uid);
                                //Actualizar campos específicos
                                docUser.update({
                                  'apellido': _apellidocontroller.text.trim(),
                                });
                              }else{

                              }
                              if(_usuariocontroller.text!=''){
                                final docUser = FirebaseFirestore.instance
                                    .collection('usuarios').doc(uid);
                                //Actualizar campos específicos
                                docUser.update({
                                  'usuario': _usuariocontroller.text.trim(),
                                });
                              }else{

                              };
                              },
                              child: Text('Actualizar')
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          height: 45,
                          width: 140,
                          child: ElevatedButton(
                            style: _styleBotonEliminar,
                              onPressed: (){
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    backgroundColor: Color(0xff3a4d54),
                                    title: Text(
                                      '¿Seguro que quieres eliminar tu cuenta?',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                    content: Text('Se eliminarán todos tus datos',style: TextStyle(
                                        color: Colors.white, fontSize: 18)),
                                    actions: [
                                      //Salir
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            showDialog(
                                                context: context,
                                                builder: (context)=>AlertDialog(
                                                  backgroundColor: Color(0xff3a4d54),
                                                  title: Text('Por favor ingresa tu contraseña'),
                                                  content: TextField(
                                                    controller: _contrasenacontroller,
                                                    obscureText: true,
                                                    enableSuggestions: false,
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          final docUser = FirebaseFirestore.instance.collection('usuarios').doc(uid);
                                                          docUser.delete();
                                                          volverAutenticar();
                                                          Navigator.of(context).pop();
                                                        },
                                                        child: Text("Ok")),
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
                                          child: Text("Eliminar")),
                                      //Cancelar
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Cancelar")),
                                    ],
                                  ));
                              },
                              child: Text('Eliminar')
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget buildUsuario(Usuario user) => Center(
        child: Column(
          children: [
            SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Nombre:'),
                  Campo(user,'nombre',_nombrecontroller),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Apellido:'),
                  Campo(user,'apellido',_apellidocontroller),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Usuario:'),
                  Campo(user,'usuario',_usuariocontroller),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Email:'),
                  Container(
                    width: 250,
                    child: TextFormField(
                      initialValue: user.email,
                      decoration: InputDecoration(
                          fillColor: Colors.grey,
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          enabled: false),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget Campo(Usuario user,String tipo, campoController){
    String nombre = user.nombre;
    String apellido = user.apellido;
    String usuario = user.usuario;
    switch(tipo){
      case 'nombre':{
        tipo = nombre;
      } break;
      case 'apellido':{
        tipo = apellido;
      } break;
      case 'usuario':{
        tipo = usuario;
      } break;
      default:{
        print('Elección no valida');
      }break;
    }
    return Container(
      width: 250,
      child: TextFormField(
        controller: campoController,
        decoration: InputDecoration(
            fillColor: Colors.grey.shade300,
            filled: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12)),
            hintText: tipo,
            hintStyle: TextStyle(color: Colors.black)
        ),
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}