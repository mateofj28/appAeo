class Itinerario {
  String _origen;
  int _puertoOrigen;
  String _fechaSalida;
  String _horaSalida;
  String _destino;
  int _puertoDestino;
  String _fechaLlegada;
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

  String getOrigen() {
    return this._origen;
  }

  void setOrigen(String origen) {
    this._origen = origen;
  }

  int getAeroPuerto() {
    return this._puertoOrigen;
  }

  void setAeropuerto(int puertoOrigen) {
    this._puertoOrigen = puertoOrigen;
  }

  String getFechaSalida() {
    return this._fechaSalida;
  }

  void setFechaSalida(String fechaSalida) {
    this._fechaSalida = fechaSalida;
  }

  String getHoraSalida() {
    return this._horaSalida;
  }

  void setHoraSalida(String horaSalida) {
    this._horaSalida = horaSalida;
  }

  String getDestino() {
    return this._destino;
  }

  void setDestino(String destino) {
    this._destino = destino;
  }

  int getPuertoLlegada() {
    return this._puertoDestino;
  }

  void setPuertoLlegada(int puertoLlegada) {
    this._puertoDestino = puertoLlegada;
  }

  String getFechaLlegada() {
    return this._fechaLlegada;
  }

  void setFechaLlegada(String fechaLlegada) {
    this._fechaLlegada = fechaLlegada;
  }

  String getHoraLlegada() {
    return this._horaLlegada;
  }

  void setHoraLlegada(String horaLlegada) {
    this._horaLlegada = horaLlegada;
  }

  Map<String, dynamic> toMap(Itinerario itinerario) {
    return {
      "origen": itinerario.getOrigen(),
      "puerto_origen_id": itinerario.getAeroPuerto(),
      "fecha_salida": itinerario.getFechaSalida(),
      "hora_salia": itinerario.getHoraSalida(),
      "destino": itinerario.getDestino(),
      "puerto_destino_id": itinerario.getPuertoLlegada(),
      "fecha_llegada": itinerario.getFechaLlegada(),
      "hora_llegada": itinerario.getHoraLlegada(),
    };
  }
}
