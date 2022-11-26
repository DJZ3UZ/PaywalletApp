import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paywallet_app/models/ahorros.dart';
import 'package:paywallet_app/views/views.dart';

final ahorrosRef = FirebaseFirestore.instance.collection('ahorros');

class AhorrosPage extends StatefulWidget {
  const AhorrosPage({super.key});

  @override
  State<AhorrosPage> createState() => _AhorrosPageState();
}

class _AhorrosPageState extends State<AhorrosPage> {
  final user = FirebaseAuth.instance.currentUser!;
  final String uid = FirebaseAuth.instance.currentUser!.uid.toString();
  double total = 0;
  String valorDropdown = 'Porcentaje';
  String tipo = 'Porcentaje';
  double cantidadMinima = 0;
  var items = [
    'Porcentaje',
    'Cantidad',
  ];

  final _cantidadcontroller = TextEditingController();

  @override
  void dispose() {
    _cantidadcontroller.dispose();
    super.dispose();
  }

  Future obtenerAhorro() async {
    await actRef
        .doc(uid)
        .collection('activity')
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) async {
              double value = document.data()["monto"];
              setState(() {
                total = total + value;
              });
            }));
  }

  Future crearAhorro(Ahorros ahorros) async{
    final docAhorro = ahorrosRef.doc(uid);
    ahorros.id=docAhorro.id;
    final json = ahorros.toJson();
    await docAhorro.set(json);
  }

  final _styleBotones = ElevatedButton.styleFrom(
      primary: Color(0xff202f36),
      onPrimary: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 10,
      shadowColor: Colors.black12);

  @override
  void initState() {
    obtenerAhorro();
    total = 0;
    super.initState();
  }

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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                          "Ahorrar",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                ],
              ),
            ),
            Text('¡FELICIDADES!',
                textAlign: TextAlign.center,
                style: GoogleFonts.permanentMarker(
                  fontSize: 28,
                )),
            SizedBox(height: 15),
            Text('Aquí empieza tu camino al ahorro',
                textAlign: TextAlign.center,
                style: GoogleFonts.permanentMarker(
                  fontSize: 18,
                )),
            SizedBox(height: 15),
            Image.asset('assets/images/logo.png', height: 100),
            SizedBox(height: 20),
            //Bienvenido cuanto deseas ahorrar
            Text('¿Cuánto deseas ahorrar?',
                textAlign: TextAlign.center,
                style: GoogleFonts.permanentMarker(
                  fontSize: 24,
                )),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: DropdownButton(
                  isExpanded: true,
                  value: valorDropdown,
                  icon: Icon(Icons.keyboard_arrow_down),
                  items: items.map((String items) {
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
                  }),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'S/.',
                  style: TextStyle(
                      fontSize: 25,
                      color: tipo == 'Cantidad'
                          ? Colors.white
                          : Colors.transparent),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 150,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Container(
                      width: 100,
                      child: TextField(
                        controller: _cantidadcontroller,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey[600]),
                        ),
                        style: TextStyle(color: Colors.black),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onEditingComplete: () {
                          double cantidad = double.parse(_cantidadcontroller.text);

                          setState(() {
                            if(cantidad!=null&&tipo=='Cantidad'){
                              total = cantidad;
                            }else if (cantidad!=null&&tipo=='Porcentaje'){
                              total = total-total*(cantidad/100);
                              setState(() {
                                cantidadMinima = total;
                              });
                            }
                          });
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text('%',
                    style: TextStyle(
                        fontSize: 25,
                        color: tipo == 'Porcentaje'
                            ? Colors.white
                            : Colors.transparent)),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Tu saldo mínimo será de: ',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
                Text(total.toString())
              ],
            ),
            SizedBox(height: 40),
            Container(
              width: 150,
              height: 50,
              child: ElevatedButton(
                  onPressed: () {
                    double cantidad = double.parse(_cantidadcontroller.text);
                    final ahorro = Ahorros(
                        ahorro: cantidad,
                        tipo: tipo,
                        cantidadMinima: cantidadMinima
                    );
                    crearAhorro(ahorro);
                    Navigator.of(context).pop();
                  },
                  style: _styleBotones,
                  child: Text(
                    'Ahorrar',
                    style: TextStyle(color: Colors.white),
                  )),
            ),
          ],
        )),
      ),
    );
  }
}
