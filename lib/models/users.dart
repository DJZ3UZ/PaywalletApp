import 'package:cloud_firestore/cloud_firestore.dart';

class Ahorro {
  String id;
  final String nombre;
  final String apellido;
  final String usuario;
  final String email;
  final String imagen;

  Ahorro(
      {this.id = '',
      required this.nombre,
      required this.apellido,
      required this.usuario,
      required this.email,
        this.imagen=''
      });

  Map<String, dynamic> toJson() =>{
    'id': id,
    'nombre': nombre,
    'apellido': apellido,
    'usuario': usuario,
    'email': email,
    'imagen':imagen
  };

  static Ahorro fromJson(Map<String, dynamic> json)=>Ahorro(
      id: json['id'],
      nombre: json['nombre'],
      apellido: json['apellido'],
      usuario: json['usuario'],
      email: json['email'],
    imagen: json['imagen']
  );

  factory Ahorro.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return Ahorro(
      id: data?['id'],
      nombre: data?['nombre'],
      apellido: data?['apellido'],
      usuario: data?['usuario'],
      email: data?['email'],
      imagen: data?['imagen']
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) "id": id,
      if (nombre != null) "nombre": nombre,
      if (apellido != null) "apellido": apellido,
      if (usuario != null) "usuario": usuario,
      if (email != null) "email": email,
      if (imagen != null) "imagen": imagen,
    };
  }
}
