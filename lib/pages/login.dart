import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paywallet_app/pages/pages.dart';

class LoginPage extends StatefulWidget{
  final VoidCallback mostrarRegisterPage;
  const LoginPage({Key? key, required this.mostrarRegisterPage}): super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  bool _isVisible = true;

  //Text controllers
  final _emailcontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();

  Future IniciarSesion() async{
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailcontroller.text.trim(),
        password: _passwordcontroller.text.trim()
    );
  }

  @override
  void dispose() {
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    super.dispose();
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
      title: 'Paywallet',
      theme: ThemeData.dark(),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
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
                          '¡Bienvenido!',
                        style: GoogleFonts.permanentMarker(
                          fontSize: 40
                        )
                      ),
                      SizedBox(height: 30),

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
                      SizedBox(height: 30),
                      //Contraseña Textfield
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: TextField(
                              controller: _passwordcontroller,
                              obscureText: _isVisible,
                              enableSuggestions: false,
                              autocorrect: false,
                              keyboardType: TextInputType.visiblePassword,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Contraseña',
                                hintStyle: TextStyle(color: Colors.grey[600]),
                                suffixIcon: GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      _isVisible = !_isVisible;
                                    });
                                  },
                                  child: Icon(_isVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,color: Colors.black54),
                                )
                              ),
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context){
                                      return ForgotPasswordPage();
                                })
                                );
                              },
                                child: Text(
                                    '¿Olvidaste tu contraseña?',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.lightBlue)
                                )
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      //Iniciar Sesión Button
                      Container(
                        width: 200,
                        height: 50,
                        child: ElevatedButton(
                            onPressed: (){
                              if(_emailcontroller.text.characters.contains('@')){
                                IniciarSesion();
                              }else{
                                var snackBarEmail = SnackBar(content: Text('Por favor, ingrese un correo válido'),duration: Duration(seconds: 2),);
                                ScaffoldMessenger.of(context).showSnackBar(snackBarEmail);
                              }
                            },
                            style: _styleBotones,
                            child: Text('INICIAR SESIÓN',style: TextStyle(color: Colors.white),)),
                      ),
                      SizedBox(height: 70),

                      //Aún no eres miembro? Registrate ahora
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('¿Aún no eres miembro?'),
                          GestureDetector(
                            onTap: widget.mostrarRegisterPage,
                              child: Text(
                                  ' Registrate aquí',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.lightBlue)
                              )
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
        )
        ),
    );
  }

}