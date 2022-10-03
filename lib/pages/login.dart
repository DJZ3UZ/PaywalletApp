import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({Key? key}): super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
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
                              keyboardType: TextInputType.emailAddress,
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
                      SizedBox(height: 30),
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
                      SizedBox(height: 30),
                      //Iniciar Sesión Button
                      Container(
                        width: 200,
                        height: 50,
                        child: ElevatedButton(
                            onPressed: (){

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
                          Text(' Registrate aquí',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.lightBlue),)
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