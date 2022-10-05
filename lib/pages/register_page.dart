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

  @override
  void dispose() {
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    _confirmarpasswordcontroller.dispose();
    super.dispose();
  }

  Future Registrarse() async{
    if (passwordConfirmada()){
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailcontroller.text.trim(),
          password: _passwordcontroller.text.trim(),
      );
    }else{
      var snackBar = SnackBar(content: Text('Ingrese sus datos correctamente'),duration: Duration(seconds: 2),);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
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
                    Image.asset('assets/images/logo_con_letras.png'),
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
                            Registrarse();
                          },
                          style: _styleBotones,
                          child: Text('REGISTRARSE',style: TextStyle(color: Colors.white),)),
                    ),
                    SizedBox(height: 30),

                    //Volver
                    GestureDetector(
                      onTap: widget.mostrarLoginPage,
                      child: Container(
                        width: 200,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Color(0xff202f36),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Text('VOLVER',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white))
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
      ),

    );
  }
}