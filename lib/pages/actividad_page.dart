import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paywallet_app/models/models.dart';
import 'package:paywallet_app/views/views.dart';

class ActividadPage extends StatefulWidget {
  const ActividadPage({super.key});

  @override
  State<ActividadPage> createState() => _ActividadPageState();
}

class _ActividadPageState extends State<ActividadPage> {
  final uid = FirebaseAuth.instance.currentUser!.uid.toString();
  bool esFijo = false;
  //Valor por default del dropdown
  String valorDropdown = 'Ingreso';
  String tipo ='Ingreso';
  var items = [
    'Ingreso',
    'Gasto',
    'Deuda'
  ];

  final _nombrecontroller = TextEditingController();
  final _descripcioncontroller = TextEditingController();
  final _montocontroller = TextEditingController();

  @override
  void dispose() {
    _nombrecontroller.dispose();
    _descripcioncontroller.dispose();
    _montocontroller.dispose();
    super.dispose();
  }

  Future crearActividad(Activity activity) async{
    final docActivity = actRef.doc(uid).collection('activity').doc();
    activity.id=docActivity.id;
    final json = activity.toJson();
    await docActivity.set(json);
  }

  final _styleBotones = ElevatedButton.styleFrom(
      primary: Color(0xff202f36),
      onPrimary: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 10,
      shadowColor: Colors.black12);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff3a4d54),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: SafeArea(
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
                            "Nueva Actividad",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Column(
                  children: [
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
                  ],
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
                      controller: _descripcioncontroller,
                      minLines: 4,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Descripción...',
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
                      controller: _montocontroller,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Monto',
                        hintStyle: TextStyle(color: Colors.grey[600]),
                      ),
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: DropdownButton(
                    isExpanded: true,
                    value: valorDropdown,
                    icon: Icon(Icons.keyboard_arrow_down),
                    items: items.map((String items){
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? nuevoValor) {
                      setState(() {
                        valorDropdown = nuevoValor!;
                        tipo = valorDropdown;
                      });
                    }
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: GestureDetector(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: esFijo? Colors.greenAccent : Colors.transparent,
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(5)
                        ),
                        child: Icon(Icons.check,color: esFijo? Colors.white : Colors.transparent,size: 15,),
                      ),
                      SizedBox(width: 10),
                      const Text('Actividad fija')
                    ],
                  ),
                  onTap: (){
                    setState(() {
                      esFijo = !esFijo;
                    });
                  },
                ),
              ),
              //Email Textfield
              SizedBox(height: 30),
              //Iniciar Sesión Button
              Container(
                width: 200,
                height: 50,
                child: ElevatedButton(
                    onPressed: () {
                      double cantidad = double.parse(_montocontroller.text);
                      switch(tipo){
                        case 'Ingreso':{
                          cantidad = cantidad;
                        }break;
                        case 'Gasto':{
                          cantidad = cantidad*(-1);
                        }break;
                        case 'Deuda':{
                          cantidad = cantidad*(-1);
                        }break;
                      }
                      final activity = Activity(
                          nombre: _nombrecontroller.text.trim(),
                          descripcion: _descripcioncontroller.text.trim(),
                          monto: cantidad,
                          tipo: tipo,
                          fijo: esFijo,
                          fecha: DateTime.now().toString()
                      );
                      crearActividad(activity);
                      Navigator.of(context).pop();
                    },
                    style: _styleBotones,
                    child: Text(
                      'Registrar Actividad',
                      style: TextStyle(color: Colors.white),
                    )),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
