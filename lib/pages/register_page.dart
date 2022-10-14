import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';



class RegisterPage extends StatefulWidget{
  final VoidCallback mostrarLoginPage;
  const RegisterPage({Key? key, required this.mostrarLoginPage}): super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>{
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

  Future Registrarse() async{
    if (passwordConfirmada()){
      //Crear usuario
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailcontroller.text.trim(),
          password: _passwordcontroller.text.trim(),
      );
      //Agregar datos del usuario
      agregarDatosUsuario(
          _nombrecontroller.text.trim(),
          _apellidocontroller.text.trim(),
          _usuariocontroller.text.trim(),
          _emailcontroller.text.trim()
      );
    }else{
      var snackBarIncorrecto = SnackBar(content: Text('Ingrese sus datos correctamente'),duration: Duration(seconds: 2),);
      ScaffoldMessenger.of(context).showSnackBar(snackBarIncorrecto);
    }
  }

  Future agregarDatosUsuario(String nombre,String apellido,String usuario,String email) async{
    await FirebaseFirestore.instance.collection('usuarios').add({
      'nombre': nombre,
      'apellido': apellido,
      'usuario': usuario,
      'email': email,
    });
  }

  bool passwordConfirmada(){
    if(_passwordcontroller.text.trim() == _confirmarpasswordcontroller.text.trim()){
      return true;
    }else{
      return false;
    }
  }

  final _styleBotones = ElevatedButton.styleFrom(
      primary: Color(0xff202f36),
      onPrimary: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 10,
      shadowColor: Colors.black12
  );

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
          backgroundColor: Color(0xff3a4d54),
          body: SingleChildScrollView(
            child: SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 50,),
                    Image.asset('assets/images/logo.png',height: 100),
                    SizedBox(height: 20),
                    //Hola de nuevo
                    Text(
                        'Registrate llenando el formulario',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.permanentMarker(
                            fontSize: 24,
                        )
                    ),
                    SizedBox(height: 15),
                    //Nombre Textfield
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(12)
                        ),
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
                            borderRadius: BorderRadius.circular(12)
                        ),
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
                            borderRadius: BorderRadius.circular(12)
                        ),
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
                            borderRadius: BorderRadius.circular(12)
                        ),
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
                            borderRadius: BorderRadius.circular(12)
                        ),
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
                            borderRadius: BorderRadius.circular(12)
                        ),
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
                    SizedBox(height: 30),
                    //Iniciar Sesión Button
                    Container(
                      width: 200,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: (){
                            if(_passwordcontroller.text.length<6){
                              var snackBarPassword = SnackBar(content: Text('Por favor, ingrese una contraseña de por lo menos 6 caracteres'),duration: Duration(seconds: 2),);
                              ScaffoldMessenger.of(context).showSnackBar(snackBarPassword);
                            }else{
                              Registrarse();
                            }
                          },
                          style: _styleBotones,
                          child: Text('REGISTRARSE',style: TextStyle(color: Colors.white),)),
                    ),
                    SizedBox(height: 30),

                    //Volver
                    Container(
                      width: 200,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: widget.mostrarLoginPage,
                          style: _styleBotones,
                          child: Text('VOLVER',style: TextStyle(color: Colors.white),)),
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          )
      ),
    );
  }
}