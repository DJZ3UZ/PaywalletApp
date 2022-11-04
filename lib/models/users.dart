class Usuario {
  String id;
  final String nombre;
  final String apellido;
  final String usuario;
  final String email;

  Usuario(
      {this.id = '',
      required this.nombre,
      required this.apellido,
      required this.usuario,
      required this.email
      });

  Map<String, dynamic> toJson() =>{
    'id': id,
    'nombre': nombre,
    'apellido': apellido,
    'usuario': usuario,
    'email': email
  };

  static Usuario fromJson(Map<String, dynamic> json)=>Usuario(
      id: json['id'],
      nombre: json['nombre'],
      apellido: json['apellido'],
      usuario: json['usuario'],
      email: json['email']);

  String getUsuario() {
    return this.usuario;
  }
}
