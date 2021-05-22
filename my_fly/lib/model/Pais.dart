class Pais {

  int _id;
  String _nombre;

  Pais(this._id, this._nombre);

  String get nombre => _nombre;

  set nombre(String value) {
    _nombre = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }
}
