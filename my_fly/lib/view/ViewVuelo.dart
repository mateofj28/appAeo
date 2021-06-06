class ViewVuelo {
  int _idVuelo;
  String _destino;
  int _precio;

  ViewVuelo(this._idVuelo, this._destino, this._precio);

  int get id => _idVuelo;
  int get precio => _precio;
  String get destino => _destino;
}
