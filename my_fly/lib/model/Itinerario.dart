import 'Aeropuerto.dart';

class Itinerario {
  int _id;
  String _origen;
  Aeropuerto _puertoOrigen;
  DateTime _fechaSalida;
  String _horaSalida;
  String _destino;
  Aeropuerto _puertoDestino;
  DateTime _fechaLlegada;
  String _horaLlegada;

  Itinerario(
      this._origen,
      this._puertoOrigen,
      this._fechaSalida,
      this._horaSalida,
      this._destino,
      this._puertoDestino,
      this._fechaLlegada,
      this._horaLlegada);

  Itinerario.id(
      this._id,
      this._origen,
      this._puertoOrigen,
      this._fechaSalida,
      this._horaSalida,
      this._destino,
      this._puertoDestino,
      this._fechaLlegada,
      this._horaLlegada);

  int get id => _id;
  String get horaLlegada => _horaLlegada;

  set horaLlegada(String value) {
    _horaLlegada = value;
  }

  DateTime get fechaLlegada => _fechaLlegada;

  set fechaLlegada(DateTime value) {
    _fechaLlegada = value;
  }

  Aeropuerto get puertoDestino => _puertoDestino;

  set puertoDestino(Aeropuerto value) {
    _puertoDestino = value;
  }

  String get destino => _destino;

  set destino(String value) {
    _destino = value;
  }

  String get horaSalida => _horaSalida;

  set horaSalida(String value) {
    _horaSalida = value;
  }

  DateTime get fechaSalida => _fechaSalida;

  set fechaSalida(DateTime value) {
    _fechaSalida = value;
  }

  Aeropuerto get puertoOrigen => _puertoOrigen;

  set puertoOrigen(Aeropuerto value) {
    _puertoOrigen = value;
  }

  String get origen => _origen;

  set origen(String value) {
    _origen = value;
  }

  
}
