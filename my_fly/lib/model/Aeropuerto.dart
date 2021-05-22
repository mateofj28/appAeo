import 'Ciudad.dart';

class Aeropuerto {

  int _id;
  String _nombre;
  Ciudad _ciudad;

  Aeropuerto(
      this._id,
      this._nombre,
      this._ciudad
      );

  Ciudad get ciudad => _ciudad;

  set ciudad(Ciudad value) {
    _ciudad = value;
  }

  String get nombre => _nombre;

  set nombre(String value) {
    _nombre = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }
}