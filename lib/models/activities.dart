class Activity {
  String id;
  final String nombre;
  final String descripcion;
  final double monto;
  String fecha; //Formato: '1969-07-20 20:18:04'
  final String tipo;
  bool fijo;

  Activity(
      {this.id = '',
        required this.nombre,
        required this.descripcion,
        required this.monto,
        required this.tipo,
        this.fijo = false,
        this.fecha = ''
        //this.fecha = DateTime(2022,DateTime.november,24,0,0,0,0,0)
      });

  Map<String, dynamic> toJson() =>{
    'id': id,
    'nombre': nombre,
    'descripcion': descripcion,
    'monto': monto,
    'fecha': fecha,
    'tipo': tipo,
    'fijo': fijo,
  };

  static Activity fromJson(Map<String, dynamic> json)=>Activity(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      monto: json['monto'],
      fecha: json['fecha'],
      tipo: json['tipo'],
      fijo: json['fijo'],
  );

}