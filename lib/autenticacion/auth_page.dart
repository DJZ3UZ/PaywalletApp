import 'package:flutter/material.dart';
import 'package:paywallet_app/pages/pages.dart';

class AuthPage extends StatefulWidget{
  const AuthPage({Key? key}): super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage>{
  //inicialmente mostrar LoginPage
  bool mostrarLoginPage = true;

  void cambiarPantallas(){
    setState(() {
      mostrarLoginPage = !mostrarLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (mostrarLoginPage){
      return LoginPage(mostrarRegisterPage: cambiarPantallas);
    } else{
      return RegisterPage(mostrarLoginPage: cambiarPantallas);
    }
  }
}
