import 'Pais.dart';

class Ciudad {

  int _id;
  String _nombre;
  Pais _pais;

  Ciudad(this._id, this._nombre, this._pais);

  Pais get pais => _pais;

  set pais(Pais value) {
    _pais = value;
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
