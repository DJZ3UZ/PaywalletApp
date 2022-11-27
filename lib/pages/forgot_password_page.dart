import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paywallet_app/autenticacion/autenticacion.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {

  final _emailcontroller = TextEditingController();

  @override
  void dispose() {
    _emailcontroller.dispose();
    super.dispose();
  }

  final _styleBotones = ElevatedButton.styleFrom(
      primary: Color(0xff202f36),
      onPrimary: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 10,
      shadowColor: Colors.black12
  );

  Future reiniciarPassword() async{
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(
          email: _emailcontroller.text.trim());
          showDialog(
              context: context,
              builder: (context){
                return AlertDialog(
                  backgroundColor: const Color(0xff3a4d54),
                  content: const Text('¡Se te envió el link de reinicio! Por favor revisa tu correo',style: TextStyle(color: Colors.white)),
                  actions: [
                    TextButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: const Text("Ok")
                    )
                  ],
                );
              }
          );
    } on FirebaseAuthException catch (e){
      print(e);
      showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              backgroundColor: const Color(0xff3a4d54),
              content: Text(e.message.toString(),style: TextStyle(color: Colors.white)),
              actions: [
                TextButton(
                    onPressed: (){
                      Navigator.pop(context);
                      },
                    child: const Text("Ok"))
              ],
            );
          }
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Paywallet',
      theme: ThemeData.dark(),
      home: Scaffold(
        backgroundColor: Color(0xff3a4d54),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 100,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    'Ingresa tu email y te enviaremos un link para reiniciar tu contraseña',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.abel(
                      fontSize: 24,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 25),
                        child: Container(
                            width: 300,
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(top: 75),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)
                            ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 70,left: 25,right: 25),
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
                              SizedBox(height: 20,),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 25),
                                child: Container(
                                  width: 200,
                                  height: 50,
                                  child: ElevatedButton(
                                      onPressed: (){
                                        reiniciarPassword();
                                      },
                                      style: _styleBotones,
                                      child: Text('REINICIAR CONTRASEÑA',style: TextStyle(color: Colors.white),)),
                                ),
                              ),
                            ],
                          ),
                          ),
                      ),
                      Container(
                          width: 150,
                          height: 150,
                          child: Image.asset('assets/images/logo.png')
                      ),
                ]
                ),
                SizedBox(height: 30),
                Container(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>MainPage()));
                      },
                      style: _styleBotones,
                        child: Text('VOLVER',style: TextStyle(color: Colors.white),)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
