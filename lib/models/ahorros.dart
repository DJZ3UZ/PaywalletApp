class Ahorros {
  String id;
  final double ahorro;
  final String tipo;
  final double cantidadMinima;

  Ahorros(
      {this.id = '',
        required this.ahorro,
        required this.tipo,
        required this.cantidadMinima,
      });

  Map<String, dynamic> toJson() =>{
    'id': id,
    'ahorro': ahorro,
    'tipo': tipo,
    'cantidadMinima': cantidadMinima,
  };

  static Ahorros fromJson(Map<String, dynamic> json)=>Ahorros(
    id: json['id'],
    ahorro: json['ahorro'],
    tipo: json['tipo'],
    cantidadMinima: json['cantidadMinima'],
  );

}