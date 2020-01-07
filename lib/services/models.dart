import 'package:cloud_firestore/cloud_firestore.dart';

class Cuenta{
  Timestamp dia;
  int cantidad;
  List<dynamic> detalles;
  String excusas;
  DocumentReference reference;

  Cuenta.fromDSnapshot(DocumentSnapshot snapshot){
    dia = snapshot['dia'];
    cantidad = snapshot['cantidad'];
    detalles = snapshot['detalles'];
    excusas = snapshot['excusas'];
    reference = snapshot.reference;
  }

}

class Historial{
  Timestamp dia;
  int gasto;
  List<dynamic> gastos;
  String nombre;
  DocumentReference reference;

  Historial.fromDSanpshot(DocumentSnapshot snapshot){
    dia = snapshot['dia'];
    gasto = snapshot['gasto'];
    gastos = snapshot['gastos'];
    nombre = snapshot['nombre'];
    reference = snapshot.reference;
  }
}

class Urban{
  List<String> chofer;
  dynamic gpd;
  String modelo;
  String no;
  String ruta;
  String id;

  Urban.fromDSnapshot(DocumentSnapshot snapshot){
    chofer = List<String>.from(snapshot['chofer']) ?? [''];
    gpd = snapshot['gpd'] ?? 0;
    modelo = snapshot['modelo'] ?? '';
    no = snapshot['no'] ?? ' ';
    ruta = snapshot['ruta'] ?? '' ;
    id = snapshot.documentID;
  }
}