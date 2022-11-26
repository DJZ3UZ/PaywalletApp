import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paywallet_app/models/models.dart';
import 'package:paywallet_app/pages/home_page.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback mostrarLoginPage;

  const RegisterPage({Key? key, required this.mostrarLoginPage})
      : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isPasswordSixCharacters = false;

  final _emailcontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();
  final _confirmarpasswordcontroller = TextEditingController();
  final _nombrecontroller = TextEditingController();
  final _apellidocontroller = TextEditingController();
  final _usuariocontroller = TextEditingController();

  @override
  void dispose() {
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    _confirmarpasswordcontroller.dispose();
    _nombrecontroller.dispose();
    _apellidocontroller.dispose();
    _usuariocontroller.dispose();
    super.dispose();
  }

  Future Registrarse() async {
    if (passwordConfirmada()) {
      //Crear usuario
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailcontroller.text.trim(),
        password: _passwordcontroller.text.trim(),
      );
      //Agregar datos del usuario
      final user = Ahorro(
        nombre: _nombrecontroller.text.trim(),
        apellido: _apellidocontroller.text.trim(),
        usuario: _usuariocontroller.text.trim(),
        email: _emailcontroller.text.trim()
      );
      crearUsuario(user);
      /*agregarDatosUsuario(
          _nombrecontroller.text.trim(),
          _apellidocontroller.text.trim(),
          _usuariocontroller.text.trim(),
          _emailcontroller.text.trim());*/
    } else {
      var snackBarIncorrecto = SnackBar(
        content: Text('Ingrese sus datos correctamente'),
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBarIncorrecto);
    }
  }

  Future crearUsuario(Ahorro user) async{
    final uid = FirebaseAuth.instance.currentUser!.uid.toString();
    final docUser = FirebaseFirestore.instance.collection('usuarios').doc(uid);
    user.id=docUser.id;
    final json = user.toJson();
    await docUser.set(json);
  }

  /*Future agregarDatosUsuario(
      String nombre, String apellido, String usuario, String email) async {
    final docUser = FirebaseFirestore.instance.collection('usuarios').doc(usuario);
    final datos = {
      'nombre': nombre,
      'apellido': apellido,
      'usuario': usuario,
      'email': email,
    };
    await docUser.set(datos);
  }*/

  bool passwordConfirmada() {
    if (_passwordcontroller.text.trim() ==
        _confirmarpasswordcontroller.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  onPasswordChanged(String password){
    setState(() {
      _isPasswordSixCharacters = false;
      if(password.length>=6){
        _isPasswordSixCharacters = true;
      }
    });
  }

  final _styleBotones = ElevatedButton.styleFrom(
      primary: Color(0xff202f36),
      onPrimary: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 10,
      shadowColor: Colors.black12);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Paywallet',
      theme: ThemeData.dark(),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
          backgroundColor: Color(0xff3a4d54),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Image.asset('assets/images/logo.png', height: 50),
                    SizedBox(height: 20),
                    //Hola de nuevo
                    Text('Registrate llenando el formulario',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.permanentMarker(
                          fontSize: 24,
                        )),
                    SizedBox(height: 15),
                    //Nombre Textfield
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: TextField(
                            controller: _nombrecontroller,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Nombre',
                              hintStyle: TextStyle(color: Colors.grey[600]),
                            ),
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    //Apellido Textfield
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: TextField(
                            controller: _apellidocontroller,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Apellido',
                              hintStyle: TextStyle(color: Colors.grey[600]),
                            ),
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    //Usuario Textfield
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: TextField(
                            controller: _usuariocontroller,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Usuario',
                              hintStyle: TextStyle(color: Colors.grey[600]),
                            ),
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    //Email Textfield
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: TextField(
                            controller: _emailcontroller,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Email',
                              hintStyle: TextStyle(color: Colors.grey[600]),
                            ),
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    //Contraseña Textfield
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: TextField(
                            controller: _passwordcontroller,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Contraseña',
                              hintStyle: TextStyle(color: Colors.grey[600]),
                            ),
                            style: TextStyle(color: Colors.black),
                            onChanged: (password) => onPasswordChanged(password),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: TextField(
                            controller: _confirmarpasswordcontroller,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Confirmar contraseña',
                              hintStyle: TextStyle(color: Colors.grey[600]),
                            ),
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 25,right: 10),
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 500),
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: _isPasswordSixCharacters ? Colors.green : Colors.transparent,
                              border: _isPasswordSixCharacters ? Border.all(color: Colors.transparent) : Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(50)
                            ),
                            child: Center(
                              child: Icon(
                                Icons.check,
                                color: _isPasswordSixCharacters ? Colors.white : Colors.transparent,
                                size: 15,
                              ),
                            ),
                          ),
                        ),
                        Text('La contraseña contiene al menos 6 caracteres')
                      ],
                    ),
                    SizedBox(height: 30),
                    //Iniciar Sesión Button
                    Container(
                      width: 200,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            if (_passwordcontroller.text.length < 6) {
                              var snackBarPassword = SnackBar(
                                content: Text(
                                    'Por favor, ingrese una contraseña de por lo menos 6 caracteres'),
                                duration: Duration(seconds: 2),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBarPassword);
                            } else {
                              Registrarse();
                            }
                          },
                          style: _styleBotones,
                          child: Text(
                            'REGISTRARSE',
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                    SizedBox(height: 30),

                    //Volver
                    Container(
                      width: 200,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: widget.mostrarLoginPage,
                          style: _styleBotones,
                          child: Text(
                            'VOLVER',
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
