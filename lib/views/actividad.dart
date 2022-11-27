import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paywallet_app/models/models.dart';
import 'package:paywallet_app/pages/actividad_page.dart';
import 'package:paywallet_app/pages/ahorros_page.dart';
import 'package:paywallet_app/pages/modificar_actividad_page.dart';

final actRef = FirebaseFirestore.instance.collection('actividades');

class Actividad extends StatefulWidget {
  const Actividad({super.key});

  @override
  State<Actividad> createState() => _ActividadState();
}

class _ActividadState extends State<Actividad> {
  final user = FirebaseAuth.instance.currentUser!;
  final String uid = FirebaseAuth.instance.currentUser!.uid.toString();
  List<String> actIDs = [];
  double total = 0;
  double ahorro = 0;
  double cantidadMinima = 0;
  String tipoAhorro = '';
  final String fechaActual = DateTime.now().toString();


  Future getActivity() async {
    await actRef
        .doc(uid)
        .collection('activity')
        .get()
        .then((snapshot) =>
        snapshot.docs.forEach((document) {
          actIDs.add(document.reference.id);
        }));
  }

  Future obtenerSumaActivity() async {
    final docUser = FirebaseFirestore.instance.collection('ahorros/').doc(uid);
    final snapshot = await docUser.get();
    if (snapshot.exists) {
      setState(() {
        tipoAhorro = snapshot.data()!["tipo"];
        ahorro = snapshot.data()!["ahorro"];
        cantidadMinima = snapshot.data()!["cantidadMinima"];
      });
    }
    await actRef
        .doc(uid)
        .collection('activity')
        .get()
        .then((snapshot) =>
        snapshot.docs.forEach((document) async {
          double value = document.data()["monto"];
          setState(() {
            total = total + value;
          });
        }));
  }

  Future crearActivityFijo() async {
    String id = '';
    String nombre = '';
    String descripcion = '';
    double monto = 0;
    String tipo = '';
    bool tipoFijoActual = false;
    String fecha = '';
    await actRef
        .doc(uid)
        .collection('activity')
        .get()
        .then((snapshot) =>
        snapshot.docs.where((element) =>
        element.data()["fecha"]
            .toString()
            .substring(8, 10) == fechaActual.substring(8, 10)).forEach((
            document) async {
          setState(() {
            id = document.data()["id"];
            nombre = document.data()["nombre"];
            descripcion = document.data()["descripcion"];
            monto = document.data()["monto"];
            tipo = document.data()["tipo"];
            bool tipoFijo = document.data()["fijo"];
            fecha = document.data()["fecha"];
            if (tipoFijo == true && fechaActual.substring(5, 7) !=
                fecha.toString().substring(5, 7) &&
                fechaActual.substring(8, 10) ==
                    fecha.toString().substring(8, 10)) {
              final docActivity = actRef.doc(uid).collection('activity').doc();
              docActivity.set({
                'id': docActivity.id,
                'nombre': nombre,
                'descripcion': descripcion,
                'monto': monto,
                'fecha': fechaActual,
                'tipo': tipo,
                'fijo': tipoFijo,
              });
              final docActivityOld = actRef.doc(uid).collection('activity').doc(
                  id);
              docActivityOld.update({'fijo': tipoFijoActual});
            } else {
              null;
            }
          });
        }));
  }

  Stream<List<Activity>> leerActividades() =>
      actRef.doc(uid).collection('activity').orderBy("fecha").snapshots().map((
          snapshot) =>
          snapshot.docs.map((doc) => Activity.fromJson(doc.data())).toList());

  @override
  void initState() {
    crearActivityFijo();
    obtenerSumaActivity();
    getActivity();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: Scaffold(
            backgroundColor: Color(0xff3a4d54),
            resizeToAvoidBottomInset: false,
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: FloatingActionButton.extended(
                  label: const Text(
                    'Nueva Actividad',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Color(0xff202f36).withOpacity(0.9),
                  elevation: 10,
                  icon: Icon(
                    Icons.sticky_note_2_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (builder) => ActividadPage()));
                  }),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            body: Container(
                child: Column(children: [
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Actividad",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => AhorrosPage()));
                          },
                          child: Container(
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Color(0xff202f36),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Stack(
                                  children: const [
                                    Icon(
                                      Icons.attach_money_rounded,
                                      size: 28,
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.lightGreenAccent,
                                        size: 10,
                                      ),
                                    ),
                                  ]
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text("Tu saldo actual es: ${total.toString()}",
                    style: TextStyle(
                        color: tipoAhorro == "Cantidad" && total > ahorro
                            ? Colors.white
                            : tipoAhorro == "Cantidad" && total == ahorro
                            ? Colors.yellow
                            : tipoAhorro == "Cantidad" && total < ahorro
                            ? Colors.red
                            : tipoAhorro == "Porcentaje" && total > cantidadMinima
                            ? Colors.white
                            : tipoAhorro == "Porcentaje" && total == cantidadMinima
                            ? Colors.yellow
                            : tipoAhorro == "Porcentaje" && total < cantidadMinima
                            ? Colors.red
                            : Colors.white
                    ),),
                  actIDs.isEmpty
                      ? const Expanded(
                      child: Center(
                          child: Text(
                            "Aún no tienes ninguna actividad",
                            style: TextStyle(fontSize: 18),
                          )))
                      : Expanded(
                    child: StreamBuilder<List<Activity>>(
                      stream: leerActividades(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final activities = snapshot.data!;
                          return ListView(
                            children: activities.map(buildActivity).toList(),
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 130)
                ]))));
  }


  Widget buildActivity(Activity activity) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Stack(children: [
          ListTile(
            title: Text(activity.nombre),
            subtitle: Text(activity.fecha.toString().substring(0, 10)),
            trailing: Container(
              width: 100,
              height: 100,
              child: Padding(
                padding: EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        Text(activity.tipo,
                            style: TextStyle(
                                color: activity.tipo == 'Ingreso'
                                    ? Colors.green
                                    : activity.tipo == 'Gasto'
                                    ? Colors.red
                                    : activity.tipo == 'Deuda'
                                    ? Colors.yellow
                                    : Colors.white,
                                fontSize: 14
                            )),
                        Text(activity.monto.toString(),
                            style: TextStyle(
                                color: activity.tipo == 'Ingreso'
                                    ? Colors.green
                                    : activity.tipo == 'Gasto'
                                    ? Colors.red
                                    : activity.tipo == 'Deuda'
                                    ? Colors.yellow
                                    : Colors.white,
                                fontSize: 12
                            ))
                      ],
                    )
                  ],
                ),
              ),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (builder) =>
                  ModificarActividadPage(actividad: Activity(id: activity.id,
                      nombre: activity.nombre,
                      descripcion: activity.descripcion,
                      monto: activity.monto,
                      tipo: activity.tipo,
                      fecha: activity.fecha,
                      fijo: activity.fijo))));
            },
            onLongPress: () {
              showDialog(
                  context: context,
                  builder: (context) =>
                      AlertDialog(
                        backgroundColor: Color(0xff3a4d54),
                        title: Text(
                          '¿Seguro que deseas eliminar esta actividad?',
                          style: TextStyle(
                              color: Colors.white, fontSize: 18),
                        ),
                        actions: [
                          //Eliminar
                          TextButton(
                              onPressed: () async {
                                eliminarActividad() {
                                  actRef
                                      .doc(uid)
                                      .collection('activity')
                                      .doc(activity.id)
                                      .delete();
                                }

                                eliminarActividad();
                                actIDs.removeWhere(
                                        (element) => element == activity.id);
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Eliminar",
                                style: TextStyle(color: Colors.red),
                              )),
                          //Cancelar
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("Cancelar")),
                        ],
                      ));
            },
          ),
        ]));
  }
}
