import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Cuenta extends StatelessWidget {
  const Cuenta({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    final _styleBotones = ElevatedButton.styleFrom(
        primary: Color(0xff202f36),
        onPrimary: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 10,
        shadowColor: Colors.black12
    );
    
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Color(0xff3a4d54),
          body: Container(
            width: double.infinity,
            height: double.infinity,
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
                        onTap: (){
                          showDialog(
                              context: context,
                              builder: (context)=> AlertDialog(
                                backgroundColor: Color(0xff3a4d54),
                                title: Text('¿Seguro que deseas cerrar sesión?',style: TextStyle(color: Colors.white,fontSize: 18),),
                                actions: [
                                  //Salir
                                  TextButton(
                                      onPressed: (){
                                        FirebaseAuth.instance.signOut();
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Salir")),
                                  //Cancelar
                                  TextButton(
                                      onPressed: (){
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Cancelar")),
                                ],
                              )
                          );
                        },
                          child: Icon(Icons.logout,color: Colors.white,size: 28,)
                      ),
                    ),
                  ),
                ),
                Text("Hola ${user.email} estás en tu cuenta",style: TextStyle(color: Colors.white),),
              ],
            ),
          ),
        )
    );
  }
}